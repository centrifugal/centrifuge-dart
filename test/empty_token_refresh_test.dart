import 'dart:async';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:centrifuge/src/proto/client.pb.dart' as protocol;
import 'package:test/test.dart';

import 'fake_server.dart';

// An empty string returned by a getToken callback during a *refresh* is the
// documented way for an app to say "this user is not allowed here anymore"
// (see https://centrifugal.dev/docs/transports/client_api). The SDK must then
// unsubscribe / disconnect with the unauthorized code instead of sending a
// token-less Refresh / SubRefresh command to the server.
//
// Note this only applies to refreshes: an empty token on the *initial* connect
// still means "connect as an anonymous user".

void main() {
  group('Subscription token refresh returning an empty token', () {
    late FakeCentrifugoServer server;
    late centrifuge.Client client;

    setUp(() async {
      server = FakeCentrifugoServer();
      await server.start();
      server.onSubscribe = (channel, req) => protocol.SubscribeResult()
        ..expires = true
        ..ttl = 1;
      client = centrifuge.createClient(server.url, centrifuge.ClientConfig());
    });

    tearDown(() async {
      await client.close();
      await server.stop();
    });

    test('unsubscribes with the unauthorized code instead of sending SubRefresh', () async {
      await client.connect();

      var getTokenCalls = 0;
      final sub = client.newSubscription(
        'news',
        centrifuge.SubscriptionConfig(getToken: (event) async {
          getTokenCalls++;
          // Real token for the initial subscribe, empty one on refresh.
          return getTokenCalls == 1 ? 'sub-token' : '';
        }),
      );

      final unsubscribes = <centrifuge.UnsubscribedEvent>[];
      final unsubscribedSubscription = sub.unsubscribed.listen(unsubscribes.add);
      addTearDown(() => unsubscribedSubscription.cancel());

      await sub.subscribe();
      expect(sub.state, centrifuge.SubscriptionState.subscribed);

      // Wait past the 1-second TTL for the refresh timer to fire.
      await Future<void>.delayed(const Duration(milliseconds: 1300));

      expect(getTokenCalls, 2);
      expect(sub.state, centrifuge.SubscriptionState.unsubscribed);
      expect(unsubscribes, hasLength(1));
      expect(unsubscribes.single.code, 1); // unsubscribedCodeUnauthorized
      expect(unsubscribes.single.reason, 'unauthorized');
      expect(server.received.any((cmd) => cmd.hasSubRefresh()), isFalse);
    });
  });

  group('Connection token refresh returning an empty token', () {
    late FakeCentrifugoServer server;
    late centrifuge.Client client;

    setUp(() async {
      server = FakeCentrifugoServer();
      await server.start();
      server.connectResult = protocol.ConnectResult()
        ..client = 'fake-client'
        ..version = '0.0.0'
        ..ping = 25
        ..expires = true
        ..ttl = 1;
    });

    tearDown(() async {
      await client.close();
      await server.stop();
    });

    test('disconnects with the unauthorized code instead of sending Refresh', () async {
      var getTokenCalls = 0;
      client = centrifuge.createClient(
        server.url,
        // Initial token is set, so getToken is only called by the refresh timer.
        centrifuge.ClientConfig(
          token: 'initial-token',
          getToken: (event) async {
            getTokenCalls++;
            return '';
          },
        ),
      );

      final disconnects = <centrifuge.DisconnectedEvent>[];
      final disconnectedSubscription = client.disconnected.listen(disconnects.add);
      addTearDown(() => disconnectedSubscription.cancel());

      await client.connect();
      expect(client.state, centrifuge.State.connected);

      // Wait past the 1-second TTL for the refresh timer to fire.
      await Future<void>.delayed(const Duration(milliseconds: 1300));

      expect(getTokenCalls, 1);
      expect(client.state, centrifuge.State.disconnected);
      expect(disconnects, hasLength(1));
      expect(disconnects.single.code, 1); // disconnectedCodeUnauthorized
      expect(disconnects.single.reason, 'unauthorized');
      expect(server.received.any((cmd) => cmd.hasRefresh()), isFalse);
    });
  });
}
