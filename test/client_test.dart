import 'dart:async';
import 'dart:convert';

import 'package:centrifuge/centrifuge.dart';
import 'package:centrifuge/src/client.dart';
import 'package:centrifuge/src/proto/client.pb.dart' as protocol;
import 'package:test/test.dart';

void main() {
  final url = 'ws://localhost:8000/connection/websocket?cf_protocol_version=v2';

  late Client client;

  setUp(() {
    client = createClient(
      url,
      ClientConfig(token: "test", data: utf8.encode('test connect data')),
    );
  });

  group('Connection', () {
    test('connect sends request and emits connect event', () async {
      final eventFuture = client.connected.first;
      final connectFinish = client.connected.first;
      client.connect();
      await connectFinish;
      final event = await eventFuture;
      expect(true, event.client != "");
      expect(State.connected, client.state);

      final disconnectFinish = client.disconnected.first;
      client.disconnect();
      await disconnectFinish;
      expect(State.disconnected, client.state);
    });
  });

  group('Subscription', () {
    test('newSubscription/removeSubscription work correctly', () {
      final s1 = client.newSubscription('some_channel');
      expect(true, client.getSubscription(s1.channel) != null);
      expect(true, client.subscriptions().isNotEmpty);
      client.removeSubscription(s1);
      expect(false, client.getSubscription(s1.channel) != null);
    });
  });
}
