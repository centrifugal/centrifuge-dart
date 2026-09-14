import 'dart:js_interop';

const bool isWeb = true;

/// Why [url] can't be a websocket endpoint, or null if it can.
///
/// Checked with the browser's URL parser, as `new WebSocket()` checks it: a
/// ws://, wss://, http:// or https:// URL, or one relative to the page, which
/// the browser resolves to a websocket URL, without a fragment.
String? endpointError(String url) {
  // The transport parses it with Uri too.
  if (Uri.tryParse(url) == null) {
    return 'endpoint must be a valid URL, got "$url"';
  }
  final base = _document?.baseURI ?? _location?.href;
  final _Url endpoint;
  try {
    endpoint = base == null ? _Url(url) : _Url(url, base);
  } catch (_) {
    return 'endpoint must be a valid URL, got "$url"';
  }
  if (!const ['ws:', 'wss:', 'http:', 'https:'].contains(endpoint.protocol)) {
    return 'endpoint must be a ws://, wss://, http:// or https:// URL, or relative to the page, got "$url"';
  }
  if (endpoint.href.contains('#')) {
    return 'endpoint must not have a fragment, got "$url"';
  }
  return null;
}

@JS('URL')
extension type _Url._(JSObject _) implements JSObject {
  external factory _Url(String url, [String base]);
  external String get protocol;
  external String get href;
}

@JS('document')
external _Document? get _document;

extension type _Document._(JSObject _) implements JSObject {
  external String get baseURI;
}

// In a worker, which has no document.
@JS('location')
external _Location? get _location;

extension type _Location._(JSObject _) implements JSObject {
  external String get href;
}
