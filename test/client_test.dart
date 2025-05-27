import 'dart:convert';
import 'dart:math';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:test/test.dart';

String randomChannel(String base) {
  final rand = Random();
  final suffix =
      List.generate(5, (_) => rand.nextInt(36).toRadixString(36)).join();
  return '$base\_$suffix';
}

void main() {
  final url = 'ws://localhost:8000/connection/websocket';

  setUp(() {});

  group('Client', () {
    test('client starts in disconnected state', () async {
      final client = centrifuge.createClient(
        url,
        centrifuge.ClientConfig(
            token: "test", data: utf8.encode('test connect data')),
      );
      expect(centrifuge.State.disconnected, client.state);
    });

    test('connect emits error event when url invalid', () async {
      final client = centrifuge.createClient(
        "invalid",
        centrifuge.ClientConfig(data: utf8.encode('test connect data')),
      );
      final errorFinish = client.error.first;
      client.connect();
      final event = await errorFinish;
      expect(true, event.error.toString().contains('Unsupported URL scheme'));
    });

    test('invalid token - disconnect code received', () async {
      final client = centrifuge.createClient(
        url,
        centrifuge.ClientConfig(token: "invalid"),
      );
      final disconnectFinish = client.disconnected.first;
      client.connect();
      final disconnect = await disconnectFinish;
      expect(centrifuge.State.disconnected, client.state);
      expect(disconnect.code, 3500);
    });

    test('can connect and disconnect', () async {
      final client = centrifuge.createClient(
        url,
        centrifuge.ClientConfig(data: utf8.encode('test connect data')),
      );
      final connectFinish = client.connected.first;
      client.connect();
      final event = await connectFinish;
      expect(true, event.client != "");
      expect(centrifuge.State.connected, client.state);

      final disconnectFinish = client.disconnected.first;
      client.disconnect();
      await disconnectFinish;
      expect(centrifuge.State.disconnected, client.state);
    });
  });

  group('Subscription', () {
    test('newSubscription/removeSubscription work correctly', () async {
      final client = centrifuge.createClient(url, centrifuge.ClientConfig());
      final s1 = client.newSubscription('some_channel');
      expect(true, client.getSubscription(s1.channel) != null);
      expect(true, client.subscriptions().isNotEmpty);
      await client.removeSubscription(s1);
      expect(false, client.getSubscription(s1.channel) != null);
    });

    test('newSubscription throws duplicate', () {
      final client = centrifuge.createClient(url, centrifuge.ClientConfig());
      client.newSubscription('channel');
      expect(() => client.newSubscription('channel'), throwsException);
    });

    test('subscribes with fossil', () async {
      final client = centrifuge.createClient(url, centrifuge.ClientConfig());
      final s1 = client.newSubscription('some_channel',
          centrifuge.SubscriptionConfig(delta: centrifuge.DeltaType.fossil));
      expect(true, client.getSubscription(s1.channel) != null);
      expect(true, client.subscriptions().isNotEmpty);
      await client.removeSubscription(s1);
      expect(false, client.getSubscription(s1.channel) != null);
    });

    test('subscribes with fossil and receives published messages', () async {
      final client =
          centrifuge.createClient(url, centrifuge.ClientConfig());

      final channel = randomChannel('some_channel');
      final s1 = client.newSubscription(
          channel,
          centrifuge.SubscriptionConfig(
            delta: centrifuge.DeltaType.fossil,
          ));

      // Listen to the publication stream
      final received = <centrifuge.PublicationEvent>[];
      final sub = s1.publication.listen((event) {
        received.add(event);
      });

      // Connect client and subscribe
      await client.connect();
      await s1.subscribe();

      final message = utf8.encode('hello world');

      // Publish messages
      await s1.publish(message);
      await s1.publish(message);

      // Wait for messages
      await Future.delayed(Duration(seconds: 2));

      // Assertions
      expect(received.length, 2);
      for (var event in received) {
        expect(event.data, message);
      }

      // Cleanup
      await sub.cancel();
      await client.removeSubscription(s1);
      expect(client.getSubscription(channel), isNull);
      await client.disconnect();
    });
  });
}
