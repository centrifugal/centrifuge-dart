import 'dart:async';
import 'dart:io';

import 'client.dart';
import 'codec.dart';
import 'transport.dart';

class Centrifuge {
  static Future<CentrifugeClient> connect(String url) async {
    final socket = await WebSocket.connect(url);
    final replyDecoder = ProtobufReplyDecoder();
    final commandEncoder = ProtobufCommandEncoder();

    final transport = CentrifugeTransport(
      socket,
      commandEncoder,
      replyDecoder,
    );

    final client = CentrifugeClientImpl(transport);
    await client.connect();
    return client;
  }
}
