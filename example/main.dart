import 'dart:convert';
import 'dart:io';
import '../lib/centrifuge.dart';

void main() async {
  final url = 'ws://localhost:8000/connection/websocket?format=protobuf';
  final centrifuge = CentrifugeClient(url: url);

  try {
    await centrifuge.connect();

    final events = SubscriptionEvents(onPublish: (subscription, event) {
      final channel = subscription.channel;
      final input = utf8.decode(event.data);
      print('New publication received from channel $channel: $input');
    }, onJoin: (subscription, event) {
      final channel = subscription.channel;
      final user = event.user;
      final client = event.client;
      print('User $user (client ID $client) joined channel $channel');
    }, onLeave: (subscription, event) {
      final channel = subscription.channel;
      final user = event.user;
      final client = event.client;
      print('User $user (client ID $client) left channel $channel');
    }, onSubscribeSuccess: (subscription, event) {
      final channel = subscription.channel;
      print('Subscribed successfuly to channel $channel');
    }, onSubscribeError: (subscription, error) {
      final channel = subscription.channel;
      print('Subscribed to channel $channel with error $error');
    }, onUnsubscribe: (subscription, event) {
      final channel = subscription.channel;
      final resubscribe = event.resubscribe;
      print('Unsubscribed from channel $channel with resubscribe $resubscribe');
    });

    centrifuge.subscribe('chat:index', events);

    await for (List<int> codeUnit in stdin) {
      final message = utf8.decode(codeUnit).trim();
      if (message == 'disconnect') {
        await centrifuge.disconnect();
      }
    }
  } catch (ex) {
    print(ex);
  }
}
