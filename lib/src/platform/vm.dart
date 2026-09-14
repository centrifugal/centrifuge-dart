const bool isWeb = false;

/// Why [url] can't be a websocket endpoint, or null if it can: dart:io opens
/// ws:// and wss:// URLs with a host and a valid port only.
String? endpointError(String url) {
  final endpoint = Uri.tryParse(url);
  if (endpoint == null || (endpoint.scheme != 'ws' && endpoint.scheme != 'wss') || endpoint.host.isEmpty) {
    return 'endpoint must be a ws:// or wss:// URL, got "$url"';
  }
  if (endpoint.port > 65535) {
    return 'endpoint must have a valid port, got "$url"';
  }
  return null;
}
