import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:centrifuge/centrifuge.dart' as centrifuge;

void main() async {
  final url = 'ws://localhost:8000/connection/websocket?cf_protocol_version=v2';
  final channel = 'chat:index';

  final onSubscriptionEvent = (dynamic event) {
    print('subscription $channel> $event');
  };

  final onEvent = (dynamic event) {
    print('client> $event');
  };

  try {
    final client = centrifuge.createClient(
      url,
      centrifuge.ClientConfig(
          headers: <String, dynamic>{'X-Example-Header': 'example'},
          onConnectionToken: (centrifuge.ConnectionTokenEvent event) {
            return Future.value('<CONNECTION JWT>');
          },
          onSubscriptionToken: (centrifuge.SubscriptionTokenEvent event) {
            return Future.value('<SUBSCRIPTION JWT>');
          }),
    );

    client.connectStream.listen(onEvent);
    client.disconnectStream.listen(onEvent);
    client.failStream.listen(onEvent);
    client.errorStream.listen(onEvent);
    client.subscribeStream.listen(onEvent);

    // Uncomment to use example token based on secret key `secret`.
    // client.setToken('eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXN0c3VpdGVfand0In0.hPmHsVqvtY88PvK4EmJlcdwNuKFuy3BGaF7dMaKdPlw');
    await client.connect();

    // try {
    //   await client.ready().timeout(const Duration(milliseconds: 1000));
    //   final res = await client.presence('#42');
    //   print(res);
    // } catch (ex) {
    //   print(ex);
    // }

    final subscription = client.newSubscription(channel);

    subscription.publicationStream.listen(onSubscriptionEvent);
    subscription.joinStream.listen(onSubscriptionEvent);
    subscription.leaveStream.listen(onSubscriptionEvent);
    subscription.subscribeStream.listen(onSubscriptionEvent);
    subscription.unsubscribeStream.listen(onSubscriptionEvent);
    subscription.errorStream.listen(onSubscriptionEvent);
    subscription.failStream.listen(onSubscriptionEvent);

    await subscription.subscribe();

    final handler = _handleUserInput(client, subscription);

    await for (List<int> codeUnit in stdin) {
      final message = utf8.decode(codeUnit).trim();
      handler(message);
    }
  } catch (ex) {
    print(ex);
  }
}

Function(String) _handleUserInput(centrifuge.Client client, centrifuge.Subscription subscription) {
  return (String message) async {
    switch (message) {
      case '#subscribe':
        await subscription.subscribe();
        break;
      case '#unsubscribe':
        await subscription.unsubscribe();
        break;
      case '#connect':
        await client.connect();
        break;
      case '#rpc':
        final request = jsonEncode({'param': 'test'});
        final data = utf8.encode(request);
        final result = await client.rpc('test', data);
        print('RPC result: ' + utf8.decode(result.data));
        break;
      case '#presence':
        final result = await subscription.presence();
        print(result);
        break;
      case '#presenceStats':
        final result = await subscription.presenceStats();
        print(result);
        break;
      case '#history':
        final result = await subscription.history(limit: 10);
        print('History num publications: ' + result.publications.length.toString());
        print('Stream top position: ' + result.offset.toString() + ', epoch: ' + result.epoch);
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
