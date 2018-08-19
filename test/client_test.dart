import 'package:centrifuge/src/client.dart';
import 'package:centrifuge/src/proto/client.pb.dart';
import "package:test/test.dart";

import 'utils/mocks.dart';

void main() {
  CentrifugeClient client;
  MockWebSocket webSocket;

  setUp(() {
    webSocket = MockWebSocket();
    client = CentrifugeClient._(socket: webSocket);
  });

  test("Client.connect() triggers connectStream", () async {
    final future = client.connectStream.first;
    final result = ConnectResult()
      ..version = 'version A'
      ..client = '123';

    webSocket.onCommand(withMethod(MethodType.CONNECT)).send(result);

    client.connect();

    final event = await future;

    expect(event.client, equals('123'));
    expect(event.version, equals('version A'));
    expect(webSocket.commands, hasLength(1));
  });

  test("WebSocket done triggers disconnectStream", () async {
    final future = client.disconnectStream.first;
    webSocket.onCommand(withMethod(MethodType.CONNECT)).send(ConnectResult());
    client.connect();

    webSocket.onDone();

    expect(future, completion(TypeMatcher<DisconnectEvent>()));
  });
}
