import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Connects the web socket channel.
///
/// On VM/Flutter (non-web) platforms, [tlsSkipVerify]=true makes the
/// [HttpClient] used for the handshake accept every certificate
/// ([HttpClient.badCertificateCallback]). Useful for development against a
/// server with a self-signed cert. Has no effect for `ws://` URLs.
///
/// A handshake that doesn't complete within [connectTimeout], or is still in
/// progress when [abort] completes, is aborted, and its socket closed, unless
/// [HttpOverrides] are in effect.
WebSocketChannel connect(
  Uri uri, {
  Iterable<String>? protocols,
  Map<String, dynamic>? headers,
  bool tlsSkipVerify = false,
  Duration? connectTimeout,
  Future<void>? abort,
}) {
  if (HttpOverrides.current != null) {
    // The client from the app's HttpOverrides may be one the app shares: it's
    // used as before, and not closed, so a handshake can't be aborted.
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
    webSocket = handshakeWithTimeout(webSocket, connectTimeout, abort: () => client.close(force: true));
  }
  // The transport completes it only while the handshake is in progress; a
  // WebSocket that still completes is closed by the transport.
  abort?.then((_) => client.close(force: true));
  // The connected socket is detached from the client, which is no longer used.
  return IOWebSocketChannel(webSocket.whenComplete(client.close));
}

/// [handshake] with a [timeout]. When it times out, [abort] stops it, and a
/// WebSocket it still completes with, too late to be aborted, is closed.
@visibleForTesting
Future<WebSocket> handshakeWithTimeout(Future<WebSocket> handshake, Duration timeout,
    {required void Function() abort}) {
  return handshake.timeout(timeout, onTimeout: () {
    abort();
    // Future.timeout drops a value that comes after the timeout: the handshake
    // may complete right now, after the client let go of its socket.
    handshake.then((webSocket) => webSocket.close().catchError((Object _) {}), onError: (Object _) {});
    throw TimeoutException('WebSocket handshake not completed', timeout);
  });
}

/// Extends the web socket channel
extension WebSocketChannelExtension on WebSocketChannel {
  /// Sends the given binary [data]
  void sendData(List<int> data) {
    sink.add(data);
  }
}
