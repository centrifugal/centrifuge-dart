import 'dart:typed_data';

import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Connects the web socket channel.
///
/// [tlsSkipVerify] is accepted for API parity with the VM channel but is a
/// no-op on the web: TLS certificate validation is owned by the browser
/// and cannot be overridden from JavaScript. To use a self-signed cert in
/// the browser, trust it at the OS / browser level.
WebSocketChannel connect(
  Uri uri, {
  Iterable<String>? protocols,
  Map<String, dynamic>? headers,
  bool tlsSkipVerify = false,
}) =>
    HtmlWebSocketChannel.connect(
      uri,
      protocols: protocols,
      binaryType: BinaryType.list,
    );

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
