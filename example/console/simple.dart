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
    final client = centrifuge.createClient(url,
        headers: <String, dynamic>{'user-id': 42, 'user-name': 'The Answer'});

    client.connectStream.listen(onEvent);
    client.errorStream.listen(onEvent);
    client.disconnectStream.listen(onEvent);

//    client.setToken(
//        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJkYXJ0IiwiZXhwIjoxNTgwOTg2MzY4LCJpYXQiOjE1NDk0NTAzNjgsImlzcyI6ImxvY2FsaG9zdC5jb20iLCJqdGkiOiJHdElrdGpLUTY4SFV6TEJsem84VkNSekIzVktiRzNrZyIsInN1YiI6ImRhcnQifQ.mUOf9rV7bb_RLtF4gzs84mkUyLC_o-19PZ0xiC3vCN0');

    await client.connect();

    final subscription = client.subscribe(channel);

    subscription.publishStream.map((e) => utf8.decode(e.data)).listen(onEvent);
    subscription.joinStream.listen(onEvent);
    subscription.leaveStream.listen(onEvent);

    subscription.subscribeSuccessStream.listen(onEvent);
    subscription.subscribeErrorStream.listen(onEvent);
    subscription.unsubscribeStream.listen(onEvent);

    final handler = _handleUserInput(client, subscription);
//    Future<void>.delayed(Duration(seconds: 1)).then((_) => exit(0));

    await for (List<int> codeUnit in stdin) {
      final message = utf8.decode(codeUnit).trim();
      handler(message);
    }
  } catch (ex) {
    print(ex);
  }
}

Function(String) _handleUserInput(
    centrifuge.Client centrifuge, centrifuge.Subscription subscription) {
  return (String message) async {
    switch (message) {
      case '#subscribe':
        await subscription.subscribe();
        break;
      case '#unsubscribe':
        await subscription.unsubscribe();
        break;
      case '#connect':
        await centrifuge.connect();
        break;
      case '#disconnect':
        await centrifuge.disconnect();
        break;
      default:
        final output = jsonEncode({'input': message});
        final data = utf8.encode(output);
        await subscription.publish(data);
        break;
    }
    return;
  };
}
