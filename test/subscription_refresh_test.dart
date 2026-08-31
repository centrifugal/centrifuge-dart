import 'dart:async';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:centrifuge/src/proto/client.pb.dart' as protocol;
import 'package:test/test.dart';

import 'fake_server.dart';

// Regression test: a subscription can be marked as `expires` by the server
// without the app ever configuring a `SubscriptionConfig.getToken` callback
// (e.g. a static, non-expiring subscription token combined with a server
// that still reports a TTL). The refresh timer must not attempt to call a
// missing callback.

void main() {
  group('Subscription token refresh without getToken callback', () {
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

    test('refresh timer does not crash or emit errors when getToken is unset', () async {
      await client.connect();

      final sub = client.newSubscription('news');
      final errors = <centrifuge.SubscriptionErrorEvent>[];
      final errorSubscription = sub.error.listen(errors.add);
      addTearDown(() => errorSubscription.cancel());

      await sub.subscribe();

      // Wait past the 1-second TTL for the refresh timer to fire.
      await Future<void>.delayed(const Duration(milliseconds: 1300));

      expect(errors, isEmpty);
      expect(sub.state, centrifuge.SubscriptionState.subscribed);
      expect(server.received.any((cmd) => cmd.hasSubRefresh()), isFalse);
    });
  });
}
