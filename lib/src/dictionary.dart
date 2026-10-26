import 'dart:convert';

import 'inflate_io.dart' if (dart.library.js_interop) 'inflate_web.dart';
import 'proto/client.pb.dart' as protocol;

export 'inflate_io.dart'
    if (dart.library.js_interop) 'inflate_web.dart'
    show inflateSupported;

/// ConnectRequest.flag bit saying the client can decode frames compressed
/// against a dictionary the connect reply carries. The server replies with the
/// bits it enabled in ConnectResult.flag.
const connectionFlagDictionaryCompression = 1 << 0;

/// What this SDK advertises at connect: every connection level capability it
/// can handle on this platform. There is no option for it on purpose: the
/// client states capability, the server decides what to use, and a server
/// supporting none of it ignores the flag.
const supportedConnectionFlags =
    inflateSupported ? connectionFlagDictionaryCompression : 0;

/// Once a connection has a dictionary, every frame starts with one of these.
///
/// The marker does not name a codec: which one a connection uses is settled
/// at connect, by the flags the client advertised. It only says whether this
/// frame was compressed at all.
const frameCodecRaw = 0x00;
const frameCodecCompressed = 0x01;

/// Bounds a frame after decompression, so a small crafted frame can't be
/// inflated into an unbounded allocation.
const maxDecompressedFrameSize = 16 * 1024 * 1024;

/// Bounds a dictionary after inflation, for the same reason. Useful
/// dictionaries are a few kilobytes; this leaves generous headroom.
const maxDictionarySize = 1024 * 1024;

/// What a connection measured on the frames it decoded against a dictionary.
class DictionaryCompressionStats {
  const DictionaryCompressionStats({
    this.accepted = false,
    this.active = false,
    this.dictionaryId = '',
    this.frames = 0,
    this.bytesReceived = 0,
    this.bytesDecompressed = 0,
    this.dictionaryBytes = 0,
    this.transportBytesReceived = 0,
  });

  /// Whether the server enabled dictionary compression at connect.
  final bool accepted;

  /// Whether frames are being decompressed.
  final bool active;

  /// Identifier of the dictionary in use.
  final String dictionaryId;

  /// How many compressed frames were received.
  final int frames;

  /// Size of those frames as received.
  final int bytesReceived;

  /// What they expanded to.
  final int bytesDecompressed;

  /// What the dictionary itself cost to receive: zero when the client already
  /// held it.
  final int dictionaryBytes;

  /// Total bytes the transport delivered since connect, before any
  /// decompression, whether compression is active or not, so the two modes
  /// can be compared directly.
  final int transportBytesReceived;

  /// Net saving: what these frames would have cost uncompressed, less what
  /// they cost, less the dictionary transfer. Negative on a connection that
  /// received too little to earn the dictionary back.
  int get bytesSaved => bytesDecompressed - bytesReceived - dictionaryBytes;

  /// Uncompressed over compressed, leaving the dictionary transfer out.
  double get ratio => bytesReceived > 0 ? bytesDecompressed / bytesReceived : 0;

  @override
  String toString() =>
      'DictionaryCompressionStats{accepted: $accepted, active: $active, '
      'dictionaryId: $dictionaryId, frames: $frames, '
      'bytesReceived: $bytesReceived, bytesDecompressed: $bytesDecompressed, '
      'dictionaryBytes: $dictionaryBytes, bytesSaved: $bytesSaved, '
      'ratio: ${ratio.toStringAsFixed(2)}, '
      'transportBytesReceived: $transportBytesReceived}';
}

/// DictionaryCache keeps the dictionary the server sent in a connect reply, so
/// a reconnect costs an id rather than a transfer.
///
/// One entry, the most recent. A dictionary belongs to a profile and changes
/// only when the server publishes a new version, so a single entry matches on
/// essentially every reconnect; during a rolling deploy, where nodes disagree,
/// a client downloads it again once per hop, which needs no eviction policy.
///
/// Kept in memory for the life of the client. An id is a hash of the content,
/// so one held here can never stand for different bytes.
class DictionaryCache {
  String _id = '';
  List<int>? _dictionary;

  /// The id to advertise at connect, empty when nothing is held.
  String get id => _id;

  List<int>? get(String id) => id != '' && id == _id ? _dictionary : null;

  void put(String id, List<int> dictionary) {
    if (id == '' || dictionary.isEmpty) return;
    _id = id;
    _dictionary = dictionary;
  }

  /// Drops [id]: a dictionary that failed to decode must not be advertised on
  /// the next connect, or the client would fail the same way in a loop.
  void forget(String id) {
    if (id == _id) {
      _id = '';
      _dictionary = null;
    }
  }
}

/// FrameCodec decodes the frames of one connection compressed with DEFLATE
/// against the dictionary its connect reply carried.
class FrameCodec {
  FrameCodec(this.id, this.dictionary, {required this.transferred});

  final String id;
  final List<int> dictionary;

  /// What the dictionary cost to receive, zero when it came from the cache.
  final int transferred;

  /// Whether the dictionary came from the cache rather than this connection.
  bool get cached => transferred == 0;

  int frames = 0;
  int bytesReceived = 0;
  int bytesDecompressed = 0;

  /// Decodes one frame as the transport delivered it.
  ///
  /// Throws [FormatException] for a frame that can't be decoded, and
  /// [InflateLimitError] for one that would expand past
  /// [maxDecompressedFrameSize].
  List<int> decode(List<int> frame) {
    if (frame.isEmpty) {
      throw const FormatException('centrifuge: empty frame');
    }
    final marker = frame[0];
    final body = frame.sublist(1);
    final List<int> out;
    if (marker == frameCodecRaw) {
      out = body;
    } else if (marker == frameCodecCompressed) {
      out = inflateRaw(
        body,
        dictionary: dictionary,
        maxSize: maxDecompressedFrameSize,
      );
    } else {
      // A codec that was never negotiated: guessing would corrupt the stream.
      throw FormatException('centrifuge: unknown frame codec $marker');
    }
    frames++;
    bytesReceived += frame.length;
    bytesDecompressed += out.length;
    return out;
  }
}

/// Builds a codec from the dictionary of a connect reply, or returns null when
/// this client can't use it: content that doesn't decode, or an id alone for
/// a dictionary the [cache] doesn't hold.
///
/// Content is always DEFLATE compressed, as raw bytes on Protobuf connections
/// and base64 on JSON ones, where a bytes field carries raw JSON.
FrameCodec? frameCodecFromDictionary(
  protocol.Dictionary dictionary,
  DictionaryCache cache,
) {
  final id = dictionary.id;
  List<int>? delivered;
  // Measured on the encoded form, because that is what crossed the wire.
  var wireBytes = 0;
  if (dictionary.data.isNotEmpty) {
    delivered = dictionary.data;
    wireBytes = delivered.length;
  } else if (dictionary.dataB64.isNotEmpty) {
    wireBytes = dictionary.dataB64.length;
    try {
      delivered = base64.decode(dictionary.dataB64);
    } on FormatException {
      return null;
    }
  }
  if (delivered == null) {
    // An id alone means "use the one you hold": the server recognised the id
    // this client advertised at connect, so there was nothing to send.
    final held = cache.get(id);
    if (held == null) return null;
    return FrameCodec(id, held, transferred: 0);
  }
  final List<int> content;
  try {
    content = inflateRaw(delivered, maxSize: maxDictionarySize);
  } on Exception {
    return null;
  }
  if (content.isEmpty) return null;
  cache.put(id, content);
  return FrameCodec(id, content, transferred: wireBytes);
}
