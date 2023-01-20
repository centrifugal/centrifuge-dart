import 'dart:typed_data';

import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Sends the given [data] over the specified [channel]
void sendData(ByteBuffer data, WebSocketChannel channel) {
  (channel as HtmlWebSocketChannel).innerWebSocket.sendByteBuffer(data);
}

/// Extends the web socket channel
extension HtmlWebSocketChannelExtension on WebSocketChannel {
  /// Sends the given binary [data]
  void sendData(List<int> data) {
    final channel = this;
    if (channel is HtmlWebSocketChannel) {
      final byteBuffer =
          data is Uint8List ? data.buffer : Uint8List.fromList(data).buffer;
      channel.innerWebSocket.sendByteBuffer(byteBuffer);
    } else {
      channel.sink.add(data);
    }
  }
}
