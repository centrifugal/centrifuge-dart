import 'dart:async';
import 'dart:typed_data';

import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Connects the web socket channel.
///
/// [tlsSkipVerify] is accepted for API parity with the VM channel but is a
/// no-op on the web: TLS certificate validation is owned by the browser
/// and cannot be overridden from JavaScript. To use a self-signed cert in
/// the browser, trust it at the OS / browser level.
///
/// A handshake that doesn't complete within [connectTimeout] is aborted.
WebSocketChannel connect(
  Uri uri, {
  Iterable<String>? protocols,
  Map<String, dynamic>? headers,
  bool tlsSkipVerify = false,
  Duration? connectTimeout,
}) {
  final channel = HtmlWebSocketChannel.connect(
    uri,
    protocols: protocols,
    binaryType: BinaryType.list,
  );
  if (connectTimeout != null) {
    // Closing a websocket that is still connecting fails the connection. A
    // browser opens one websocket to a server at a time, so a handshake left
    // pending would also hold up the next attempt.
    final timer = Timer(connectTimeout, () => channel.innerWebSocket.close());
    channel.ready.then((_) => timer.cancel(), onError: (_) => timer.cancel());
  }
  return channel;
}

/// Extends the web socket channel
extension HtmlWebSocketChannelExtension on WebSocketChannel {
  /// Sends the given binary [data]
  void sendData(List<int> data) {
    final channel = this;
    if (channel is HtmlWebSocketChannel) {
      final byteBuffer = data is Uint8List ? data.buffer : Uint8List.fromList(data).buffer;
      channel.sink.add(byteBuffer);
    } else {
      channel.sink.add(data);
    }
  }
}
