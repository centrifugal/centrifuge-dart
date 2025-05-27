import 'dart:typed_data';

/// Fossil delta implementation in Dart
/// Applies a binary delta to a source Uint8List, producing a target Uint8List.

class Reader {
  final Uint8List _data;
  int _pos = 0;

  Reader(Uint8List data) : _data = data;

  bool get hasBytes => _pos < _data.length;

  int getByte() {
    if (_pos >= _data.length) {
      throw RangeError('out of bounds');
    }
    return _data[_pos++];
  }

  /// Read a base64-like unsigned integer using the zValue table.
  int getInt() {
    var v = 0;
    while (true) {
      final b = getByte();
      final z = _zValue[b & 0x7F];
      if (z < 0) {
        _pos--; // push back terminator
        break;
      }
      v = (v << 6) + z;
    }
    return v & 0xFFFFFFFF;
  }

  /// Take [count] bytes from current position, advancing the cursor.
  Uint8List takeBytes(int count) {
    if (_pos + count > _data.length) {
      throw RangeError('read extends past end of data');
    }
    final slice = _data.sublist(_pos, _pos + count);
    _pos += count;
    return slice;
  }

  String getChar() => String.fromCharCode(getByte());

  static const List<int> _zValue = <int>[ /* same mapping as before */
    // 0..47
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    // 48..57 ('0'-'9')
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
    // 58..64
    -1, -1, -1, -1, -1, -1, -1,
    // 65..90 ('A'-'Z')
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
    26, 27, 28, 29, 30, 31, 32, 33, 34, 35,
    // 91..94
    -1, -1, -1, -1,
    // 95 ('_')
    36,
    // 96
    -1,
    // 97..122 ('a'-'z')
    37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52,
    53, 54, 55, 56, 57, 58, 59, 60, 61, 62,
    // 123..125
    -1, -1, -1,
    // 126 ('~')
    63,
    // 127
    -1,
  ];
}

class Writer {
  final List<int> _out = [];

  /// Append bytes from [data] between [start] (inclusive) and [end] (exclusive).
  void putArray(Uint8List data, int start, int end) {
    _out.addAll(data.sublist(start, end));
  }

  /// Return the accumulated bytes as a Uint8List.
  Uint8List toByteArray() => Uint8List.fromList(_out);
}

/// Compute a 32-bit checksum of [data] using unrolled summation.
int checksum(Uint8List data) {
  var sum0 = 0, sum1 = 0, sum2 = 0, sum3 = 0;
  var z = 0;
  var n = data.length;

  // Unrolled loops for speed
  while (n >= 16) {
    sum0 = (sum0 + data[z    ]) & 0xFFFFFFFF;
    sum1 = (sum1 + data[z + 1]) & 0xFFFFFFFF;
    sum2 = (sum2 + data[z + 2]) & 0xFFFFFFFF;
    sum3 = (sum3 + data[z + 3]) & 0xFFFFFFFF;
    sum0 = (sum0 + data[z + 4]) & 0xFFFFFFFF;
    sum1 = (sum1 + data[z + 5]) & 0xFFFFFFFF;
    sum2 = (sum2 + data[z + 6]) & 0xFFFFFFFF;
    sum3 = (sum3 + data[z + 7]) & 0xFFFFFFFF;
    sum0 = (sum0 + data[z + 8]) & 0xFFFFFFFF;
    sum1 = (sum1 + data[z + 9]) & 0xFFFFFFFF;
    sum2 = (sum2 + data[z + 10]) & 0xFFFFFFFF;
    sum3 = (sum3 + data[z + 11]) & 0xFFFFFFFF;
    sum0 = (sum0 + data[z + 12]) & 0xFFFFFFFF;
    sum1 = (sum1 + data[z + 13]) & 0xFFFFFFFF;
    sum2 = (sum2 + data[z + 14]) & 0xFFFFFFFF;
    sum3 = (sum3 + data[z + 15]) & 0xFFFFFFFF;
    z += 16;
    n -= 16;
  }
  while (n >= 4) {
    sum0 = (sum0 + data[z    ]) & 0xFFFFFFFF;
    sum1 = (sum1 + data[z + 1]) & 0xFFFFFFFF;
    sum2 = (sum2 + data[z + 2]) & 0xFFFFFFFF;
    sum3 = (sum3 + data[z + 3]) & 0xFFFFFFFF;
    z += 4;
    n -= 4;
  }

  // Combine the four partial sums
  var result = (((sum3 + ((sum2 << 8) & 0xFFFFFFFF)) & 0xFFFFFFFF)
      + ((sum1 << 16) & 0xFFFFFFFF)) & 0xFFFFFFFF;
  result = (result + ((sum0 << 24) & 0xFFFFFFFF)) & 0xFFFFFFFF;

  // Handle any remaining bytes (n < 4)
  for (var i = 0; i < n; i++) {
    result = (result + ((data[z + i] << ((3 - i) * 8)) & 0xFFFFFFFF)) & 0xFFFFFFFF;
  }

  return result;
}

/// Applies a Fossil delta [delta] to [source], returning the patched output.
Uint8List applyDelta(Uint8List source, Uint8List delta) {
  final reader = Reader(delta);

  // Read expected output size
  final limit = reader.getInt();
  if (reader.getChar() != '\n') {
    throw FormatException("size integer not terminated by '\n'");
  }

  final writer = Writer();
  var total = 0;

  while (reader.hasBytes) {
    final cnt = reader.getInt();
    final op = reader.getChar();

    switch (op) {
      case '@':
        final ofst = reader.getInt();
        if (reader.hasBytes && reader.getChar() != ',') {
          throw FormatException("copy command not terminated by ','");
        }
        total += cnt;
        if (total > limit) {
          throw StateError('copy exceeds output file size');
        }
        if (ofst + cnt > source.length) {
          throw RangeError('copy extends past end of input');
        }
        writer.putArray(source, ofst, ofst + cnt);
        break;

      case ':':
        total += cnt;
        if (total > limit) {
          throw StateError('insert command gives an output larger than predicted');
        }
        if (cnt > delta.length - reader._pos) {
          throw StateError('insert count exceeds size of delta');
        }
        final bytes = reader.takeBytes(cnt);
        writer.putArray(bytes, 0, bytes.length);
        break;

      case ';':
        final out = writer.toByteArray();
        final cs = checksum(out);
        if (cnt != cs) {
          throw StateError('bad checksum');
        }
        if (total != limit) {
          throw StateError('generated size does not match predicted size');
        }
        return out;

      default:
        throw FormatException('unknown delta operator');
    }
  }

  throw FormatException('unterminated delta');
}
