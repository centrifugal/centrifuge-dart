/// Whether this platform can decode frames compressed against a dictionary.
///
/// Not in a browser: it has no DEFLATE with a preset dictionary to call, and
/// the client does not advertise the capability there, so a server never sends
/// it such frames.
const bool inflateSupported = false;

/// Thrown when inflating would produce more than the caller's limit.
class InflateLimitError implements Exception {
  const InflateLimitError(this.maxSize);

  final int maxSize;

  @override
  String toString() => 'centrifuge: inflated data exceeds $maxSize bytes';
}

List<int> inflateRaw(
  List<int> data, {
  List<int>? dictionary,
  required int maxSize,
}) => throw UnsupportedError('dictionary compression is not supported here');
