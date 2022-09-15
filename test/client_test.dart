import 'dart:convert';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:test/test.dart';

void main() {
  final url = 'ws://localhost:8000/connection/websocket?cf_protocol_version=v2';

  setUp(() {});

  group('Client', () {
    test('client starts in disconnected state', () async {
      final client = centrifuge.createClient(
        url,
        centrifuge.ClientConfig(token: "test", data: utf8.encode('test connect data')),
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
  });
}
