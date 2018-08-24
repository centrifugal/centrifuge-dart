import 'dart:async';
import 'dart:convert';

import 'package:centrifuge/src/codec.dart';
import 'package:centrifuge/src/proto/client.pb.dart' hide Error;
import 'package:centrifuge/src/proto/client.pb.dart' as proto show Error;
import 'package:centrifuge/src/transport.dart';
import 'package:protobuf/protobuf.dart';
import 'package:test/test.dart';

import 'src/utils.dart';

void main() {
  Transport transport;
  MockWebSocket webSocket;

  Function(Push) onPush = (_) => fail('unexpected invocation');
  final Function(dynamic) onError =
      (dynamic error) => fail('unexpected invocation');
  final Function onDone = () => fail('unexpected invocation');

  setUp(() {
    webSocket = MockWebSocket();

    transport = Transport(
      () => Future.value(webSocket),
      ProtobufCommandEncoder(),
      ProtobufReplyDecoder(),
    );
  });

  test('Transport.open() triggers websocket\'s listen', () async {
    await transport.open((p) => onPush(p),
        onError: (dynamic e) => onError(e), onDone: () => onDone());

    expect(webSocket.onData, isNotNull);
    expect(webSocket.onError, isNotNull);
    expect(webSocket.onDone, isNotNull);
  });

  group('Opened transport', () {
    setUp(() => transport.open((p) => onPush(p),
        onError: (dynamic e) => onError(e), onDone: () => onDone()));

    test('Transport.send() returns result', () async {
      webSocket.onCommand(withMethod(MethodType.CONNECT)).result(ConnectResult()
        ..client = 'c1'
        ..version = 'v2');

      final result = await transport.send(ConnectRequest(), ConnectResult());

      expect(result.client, equals('c1'));
      expect(result.version, equals('v2'));
    });

    test('Transport.send() throws error', () async {
      webSocket.onCommand(withMethod(MethodType.CONNECT)).error(proto.Error()
        ..message = 'some exception'
        ..code = 999);

      expect(
          transport.send(ConnectRequest(), ConnectResult()), throwsA(anything));
    });

    test('Transport.send() throws error', () async {
      webSocket.onCommand(withMethod(MethodType.CONNECT)).error(proto.Error()
        ..message = 'some exception'
        ..code = 999);

      expect(
          transport.send(ConnectRequest(), ConnectResult()), throwsA(anything));
    });

    test('Transport processes push', () async {
      final replyData = (Reply()
            ..result = (Push()..data = utf8.encode('hello')).writeToBuffer())
          .writeToBuffer();
      final writer = CodedBufferWriter();
      writer.writeInt32NoTag(replyData.length);
      Push push;
      onPush = (Push p) => push = p;

      webSocket.onData(writer.toBuffer() + replyData);

      expect(utf8.decode(push.data), equals('hello'));
    });
  });
}
