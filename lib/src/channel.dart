import 'dart:async';
import 'dart:io';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Connects the web socket channel.
///
/// On VM/Flutter (non-web) platforms, [tlsSkipVerify]=true makes the
/// [HttpClient] used for the handshake accept every certificate
/// ([HttpClient.badCertificateCallback]). Useful for development against a
/// server with a self-signed cert. Has no effect for `ws://` URLs.
///
/// A handshake that doesn't complete within [connectTimeout] is aborted, and
/// its socket closed.
WebSocketChannel connect(
  Uri uri, {
  Iterable<String>? protocols,
  Map<String, dynamic>? headers,
  bool tlsSkipVerify = false,
  Duration? connectTimeout,
}) {
  // A client of its own, so that an unfinished handshake can be aborted.
  final client = HttpClient()..userAgent = WebSocket.userAgent;
  if (tlsSkipVerify) {
    client.badCertificateCallback = (_, __, ___) => true;
  }
  var webSocket = WebSocket.connect(
    uri.toString(),
    protocols: protocols,
    headers: headers,
    customClient: client,
  );
  if (connectTimeout != null) {
    webSocket = webSocket.timeout(connectTimeout, onTimeout: () {
      client.close(force: true);
      throw TimeoutException('WebSocket handshake not completed', connectTimeout);
    });
  }
  // The connected socket is detached from the client, which is no longer used.
  return IOWebSocketChannel(webSocket.whenComplete(client.close));
}

/// Extends the web socket channel
extension WebSocketChannelExtension on WebSocketChannel {
  /// Sends the given binary [data]
  void sendData(List<int> data) {
    sink.add(data);
  }
}
