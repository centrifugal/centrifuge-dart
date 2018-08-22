import 'dart:async';
import 'dart:io';

import 'client.dart';
import 'codec.dart';
import 'transport.dart';

class Centrifuge {
  static Future<CentrifugeClient> connect(String url) async {
    final builder = () async {
      final socket = await WebSocket.connect(url);
      final replyDecoder = ProtobufReplyDecoder();
      final commandEncoder = ProtobufCommandEncoder();

      final transport = Transport(
        socket,
        commandEncoder,
        replyDecoder,
      );

      return transport;
    };

    final client = CentrifugeClientImpl(builder);
    await client.connect();
    return client;
  }
}
