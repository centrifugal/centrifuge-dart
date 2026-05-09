import 'dart:io';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Connects the web socket channel.
///
/// On VM/Flutter (non-web) platforms, [tlsSkipVerify]=true installs a
/// custom [HttpClient] whose [HttpClient.badCertificateCallback] accepts
/// every certificate. Useful for development against a server with a
/// self-signed cert. Has no effect for `ws://` URLs.
WebSocketChannel connect(
  Uri uri, {
  Iterable<String>? protocols,
  Map<String, dynamic>? headers,
  bool tlsSkipVerify = false,
}) {
  HttpClient? customClient;
  if (tlsSkipVerify) {
    customClient = HttpClient()..badCertificateCallback = (_, __, ___) => true;
  }
  return IOWebSocketChannel.connect(
    uri,
    protocols: protocols,
    headers: headers,
    customClient: customClient,
  );
}

/// Extends the web socket channel
extension WebSocketChannelExtension on WebSocketChannel {
  /// Sends the given binary [data]
  void sendData(List<int> data) {
    sink.add(data);
  }
}
