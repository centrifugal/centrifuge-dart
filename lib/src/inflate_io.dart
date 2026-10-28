import 'dart:io';
import 'dart:typed_data';

/// Whether this platform can decode frames compressed against a dictionary.
const bool inflateSupported = true;

/// Thrown when inflating would produce more than the caller's limit.
class InflateLimitError implements Exception {
  const InflateLimitError(this.maxSize);

  final int maxSize;

  @override
  String toString() => 'centrifuge: inflated data exceeds $maxSize bytes';
}

/// Inflates raw DEFLATE [data], with a preset [dictionary] when given, refusing
/// to produce more than [maxSize] bytes.
///
/// dart:io ignores a preset dictionary in raw mode, for inflating and deflating
/// alike, so a stream that refers back into one fails as bad data. zlib only
/// applies a dictionary when the zlib header asks for it, so the raw stream is
/// given one: FDICT set and the dictionary's Adler-32, which is what the
/// decoder checks before using the dictionary it was given.
///
/// The zlib trailer is left out, since it is a checksum of the output this
/// call is producing. Without it a stream cut short is not detected here; a
/// frame is a whole WebSocket message, and a cut one fails to decode as the
/// protocol after this.
List<int> inflateRaw(
  List<int> data, {
  List<int>? dictionary,
  required int maxSize,
}) {
  final out = BytesBuilder(copy: false);
  final limited = _LimitedSink(out, maxSize);
  final Sink<List<int>> decoder;
  if (dictionary == null) {
    decoder = ZLibDecoder(raw: true).startChunkedConversion(limited);
  } else {
    decoder = ZLibDecoder(
      dictionary: dictionary,
    ).startChunkedConversion(limited);
    decoder.add(_zlibHeader(dictionary));
  }
  decoder.add(data);
  decoder.close();
  return out.takeBytes();
}

List<int> _zlibHeader(List<int> dictionary) {
  const cmf = 0x78; // DEFLATE, 32KB window.
  var flg = 0x20 | 0x80; // FDICT, default compression level.
  flg += 31 - ((cmf * 256 + flg) % 31);
  final id = _adler32(dictionary);
  return [
    cmf,
    flg,
    (id >> 24) & 0xff,
    (id >> 16) & 0xff,
    (id >> 8) & 0xff,
    id & 0xff,
  ];
}

int _adler32(List<int> data) {
  var a = 1;
  var b = 0;
  for (final x in data) {
    a = (a + x) % 65521;
    b = (b + a) % 65521;
  }
  return (b << 16) | a;
}

class _LimitedSink implements Sink<List<int>> {
  _LimitedSink(this._out, this._maxSize);

  final BytesBuilder _out;
  final int _maxSize;

  @override
  void add(List<int> chunk) {
    if (_out.length + chunk.length > _maxSize) {
      throw InflateLimitError(_maxSize);
    }
    _out.add(chunk);
  }

  @override
  void close() {}
}
