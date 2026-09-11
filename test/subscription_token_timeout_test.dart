import 'dart:async';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:test/test.dart';

import 'fake_server.dart';

void main() {
  group('Subscription getToken throwing TimeoutException', () {
    late FakeCentrifugoServer server;
    late centrifuge.Client client;

    setUp(() async {
      server = FakeCentrifugoServer();
      await server.start();
    });

    tearDown(() async {
      await client.close();
      await server.stop();
    });

    test('is a subscription error, not a subscribe timeout that reconnects the client', () async {
      client = centrifuge.createClient(server.url);
      var getTokenCalls = 0;
      final sub = client.newSubscription(
        'news',
        centrifuge.SubscriptionConfig(
          minResubscribeDelay: const Duration(milliseconds: 50),
          maxResubscribeDelay: const Duration(milliseconds: 100),
          getToken: (event) async {
            getTokenCalls++;
            if (getTokenCalls == 1) {
              // e.g. an HTTP token request wrapped in .timeout().
              throw TimeoutException('token request timed out');
            }
            return 'token';
          },
        ),
      );

      final connectingEvents = <centrifuge.ConnectingEvent>[];
      final errors = <centrifuge.SubscriptionErrorEvent>[];
      final connectingSubscription = client.connecting.listen(connectingEvents.add);
      final errorSubscription = sub.error.listen(errors.add);
      addTearDown(() => connectingSubscription.cancel());
      addTearDown(() => errorSubscription.cancel());

      await client.connect();
      connectingEvents.clear();

      final subscribed = sub.subscribed.first;
      unawaited(sub.subscribe());
      await subscribed.timeout(const Duration(seconds: 5));

      expect(getTokenCalls, 2);
      expect(errors, hasLength(1));
      expect(errors.single.error, isA<centrifuge.SubscriptionSubscribeError>());
      expect(connectingEvents, isEmpty);
      expect(client.state, centrifuge.State.connected);
    });

    test('does not cancel the pending reconnect when the connection dropped meanwhile', () async {
      client = centrifuge.createClient(
        server.url,
        centrifuge.ClientConfig(
          minReconnectDelay: const Duration(milliseconds: 100),
          maxReconnectDelay: const Duration(milliseconds: 200),
        ),
      );
      final firstTokenRequested = Completer<void>();
      final firstToken = Completer<String>();
      var getTokenCalls = 0;
      final sub = client.newSubscription(
        'news',
        centrifuge.SubscriptionConfig(getToken: (event) {
          getTokenCalls++;
          if (getTokenCalls == 1) {
            firstTokenRequested.complete();
            return firstToken.future;
          }
          return Future.value('token');
        }),
      );

      await client.connect();
      unawaited(sub.subscribe());
      await firstTokenRequested.future.timeout(const Duration(seconds: 5));

      // Drop the connection while the token request is still pending: the
      // client moves to connecting and schedules a reconnect.
      final connecting = client.connecting.first;
      await server.closeConnection();
      await connecting.timeout(const Duration(seconds: 5));

      final reconnected = client.connected.first;
      final subscribed = sub.subscribed.first;
      firstToken.completeError(TimeoutException('token request timed out'));

      await reconnected.timeout(const Duration(seconds: 5));
      await subscribed.timeout(const Duration(seconds: 5));
      expect(client.state, centrifuge.State.connected);
      expect(sub.state, centrifuge.SubscriptionState.subscribed);
    });
  });
}
