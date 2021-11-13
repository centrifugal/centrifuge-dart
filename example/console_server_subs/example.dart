import 'dart:convert';
import 'dart:io';

import 'package:centrifuge/centrifuge.dart' as centrifuge;

void main() async {
  final url = 'ws://localhost:8000/connection/websocket?format=protobuf';

  final onEvent = (dynamic event) {
    print('$event');
  };

  try {
    final client = centrifuge.createClient(
      url,
      config: centrifuge.ClientConfig(),
    );

    client.connectStream.listen(onEvent);
    client.disconnectStream.listen(onEvent);
    client.subscribeStream.listen(onEvent);
    client.unsubscribeStream.listen(onEvent);
    client.publishStream.listen(onEvent);
    client.joinStream.listen(onEvent);
    client.leaveStream.listen(onEvent);

    // Uncomment to use example token based on secret key `secret`.
    // client.setToken('eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXN0c3VpdGVfand0In0.hPmHsVqvtY88PvK4EmJlcdwNuKFuy3BGaF7dMaKdPlw');
    await client.connect();

    final handler = _handleUserInput(client);

    await for (List<int> codeUnit in stdin) {
      final message = utf8.decode(codeUnit).trim();
      handler(message);
    }
  } catch (ex) {
    print(ex);
  }
}

Function(String) _handleUserInput(centrifuge.Client client) {
  return (String message) async {
    switch (message) {
      case '#connect':
        await client.connect();
        break;
      case '#disconnect':
        await client.disconnect();
        break;
      default:
        break;
    }
    return;
  };
}
