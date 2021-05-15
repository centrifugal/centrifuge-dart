import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:centrifuge/centrifuge.dart' as centrifuge;

void main() async {
  final url = 'ws://localhost:8000/connection/websocket?format=protobuf';
  final channel = 'chat:index';

  final onEvent = (dynamic event) {
    print('$channel> $event');
  };

  try {
    final client = centrifuge.createClient(
      url,
      config: centrifuge.ClientConfig(
          headers: <String, dynamic>{'user-id': 42, 'user-name': 'The Answer'},
          onPrivateSub: (centrifuge.PrivateSubEvent event) {
            return Future.value('<SUBSCRIPTION JWT>');
          }),
    );

    client.connectStream.listen(onEvent);
    client.disconnectStream.listen(onEvent);

    // Uncomment to use example token based on secret key `secret`.
    // client.setToken('eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXN0c3VpdGVfand0In0.hPmHsVqvtY88PvK4EmJlcdwNuKFuy3BGaF7dMaKdPlw');
    client.connect();

    final subscription = client.getSubscription(channel)!;

    subscription.publishStream.map((e) => utf8.decode(e.data)).listen(onEvent);
    subscription.joinStream.listen(onEvent);
    subscription.leaveStream.listen(onEvent);

    subscription.subscribeSuccessStream.listen(onEvent);
    subscription.subscribeErrorStream.listen(onEvent);
    subscription.unsubscribeStream.listen(onEvent);

    subscription.subscribe();

    final handler = _handleUserInput(client, subscription);

    await for (List<int> codeUnit in stdin) {
      final message = utf8.decode(codeUnit).trim();
      handler(message);
    }
  } catch (ex) {
    print(ex);
  }
}

Function(String) _handleUserInput(
    centrifuge.Client client, centrifuge.Subscription subscription) {
  return (String message) async {
    switch (message) {
      case '#subscribe':
        subscription.subscribe();
        break;
      case '#unsubscribe':
        subscription.unsubscribe();
        break;
      case '#connect':
        client.connect();
        break;
      case '#rpc':
        final request = jsonEncode({'method': 'test'});
        final data = utf8.encode(request);
        final result = await client.rpc(data);
        print('RPC result: ' + utf8.decode(result.data));
        break;
      case '#disconnect':
        client.disconnect();
        break;
      default:
        final output = jsonEncode({'input': message});
        final data = utf8.encode(output);
        try {
          await subscription.publish(data);
        } catch (ex) {
          print("can't publish: $ex");
        }
        break;
    }
    return;
  };
}
