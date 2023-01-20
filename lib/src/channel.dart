import 'package:web_socket_channel/web_socket_channel.dart';

/// Extends the web socket channel
extension WebSocketChannelExtension on WebSocketChannel {
  /// Sends the given binary [data]
  void sendData(List<int> data) {
    sink.add(data);
  }
}
