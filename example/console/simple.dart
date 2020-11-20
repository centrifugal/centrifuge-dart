import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:centrifuge/centrifuge.dart' as centrifuge;

void main() async {
  final url = 'ws://localhost:8000/connection/websocket?format=protobuf';
  final channel = 'public:test';

  // Uncomment to subscribe to private channels
  // final channel = r'$user:test';

  // Uncomment to use batching
  // final channels = [
  //   r'$usert:test1',
  //   r'$user:test2',
  //   r'$user:test3',
  //   r'public:test1',
  // ];

  final onEvent = (String channel, dynamic event) {
    print('$channel> $event');
  };

  try {
    final httpClient = http.Client();
    final client = centrifuge.createClient(
      url,
      config: centrifuge.ClientConfig(
        onPrivateSub: (event) =>
            _auth(httpClient, event.clientID, event.channels),
      ),
    );

    client.connectStream.listen((e) => onEvent('', e));
    client.disconnectStream.listen((e) => onEvent('', e));

    // Uncomment to use example token based on secret key `secret`.
    // client.setToken(
    //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXN0c3VpdGVfand0In0.hPmHsVqvtY88PvK4EmJlcdwNuKFuy3BGaF7dMaKdPlw');
    await client.connect();

    // Uncomment to use batching
    // client.startBatching();
    // client.startSubscribeBatching();
    // for (final channel in channels) {
    final subscription = client.getSubscription(channel);

    subscription.publishStream
        .map((e) => utf8.decode(e.data))
        .listen((e) => onEvent(channel, e));
    subscription.joinStream.listen((e) => onEvent(channel, e));
    subscription.leaveStream.listen((e) => onEvent(channel, e));

    subscription.subscribeSuccessStream.listen((e) => onEvent(channel, e));
    subscription.subscribeErrorStream.listen((e) => onEvent(channel, e));
    subscription.unsubscribeStream.listen((e) => onEvent(channel, e));

    subscription.subscribe();
    // Uncomment to use batching
    // }
    // client.stopSubscribeBatching();
    // client.stopBatching();

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
        await client.disconnect();
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

Future<centrifuge.PrivateSubSign> _auth(
    http.Client httpClient, String clientID, List<String> channels) async {
  final body = json.encode(<String, dynamic>{
    'client': clientID,
    'channels': channels,
  });
  final res = await httpClient.post(
    'http://localhost:5000/auth',
    headers: <String, String>{
      'content-type': 'application/json',
      'accept': 'application/json',
    },
    body: body,
  );
  return centrifuge.PrivateSubSign.fromRawJson(res.body);
}
