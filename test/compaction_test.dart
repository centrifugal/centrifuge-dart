import 'dart:async';
import 'dart:convert';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:centrifuge/src/proto/client.pb.dart' as protocol;
import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';

import 'fake_server.dart';

// Channel compaction is a Centrifugo PRO feature, so it can't be exercised
// against the docker-compose OSS server — these tests use the in-process
// FakeCentrifugoServer: the subscribe reply negotiates a numeric channel ID and
// subsequent pushes carry the ID instead of the channel name, exactly like the
// real server does when compaction is enabled.

Future<T> _waitForEvent<T>(Stream<T> stream, {Duration timeout = const Duration(seconds: 5)}) {
  return stream.first.timeout(timeout);
}

void main() {
  group('Channel compaction', () {
    late FakeCentrifugoServer server;
    late centrifuge.Client client;
    var channelId = 42;

    setUp(() async {
      // Reset between tests — one of them reassigns the id mid-test.
      channelId = 42;
      server = FakeCentrifugoServer();
      await server.start();
      // Negotiate channel compaction: assign a numeric channel id whenever the
      // client offers the channelCompaction flag (bit 1).
      server.onSubscribe = (channel, req) {
        final result = protocol.SubscribeResult();
        if (req.flag.toInt() & 1 != 0) {
          result.id = Int64(channelId);
        }
        return result;
      };
      client = centrifuge.createClient(server.url, centrifuge.ClientConfig());
    });

    tearDown(() async {
      await client.close();
      await server.stop();
    });

    test('subscribe offers compaction flag and pushes are routed by numeric id', () async {
      await client.connect();

      final sub = client.newSubscription('compacted-channel');
      final pubFuture = _waitForEvent<centrifuge.PublicationEvent>(sub.publication);
      final joinFuture = _waitForEvent<centrifuge.JoinEvent>(sub.join);
      final leaveFuture = _waitForEvent<centrifuge.LeaveEvent>(sub.leave);

      await sub.subscribe();

      // The subscribe request must carry the channelCompaction bit.
      expect(server.lastSubscribe!.flag.toInt() & 1, 1);

      // Publication push with numeric ID only (no channel name).
      server.publish(id: 42, data: utf8.encode('{"compacted":true}'));
      final pub = await pubFuture;
      expect(jsonDecode(utf8.decode(pub.data)), {'compacted': true});

      // Join / leave pushes are compacted the same way.
      server.join(id: 42, client: 'other-client');
      final join = await joinFuture;
      expect(join.client, 'other-client');

      server.leave(id: 42, client: 'other-client');
      final leave = await leaveFuture;
      expect(leave.client, 'other-client');
    });

    test('push with unknown id is dropped without affecting other subscriptions', () async {
      await client.connect();

      final sub = client.newSubscription('compacted-channel');
      await sub.subscribe();

      final received = <centrifuge.PublicationEvent>[];
      final pubSubscription = sub.publication.listen(received.add);
      addTearDown(() => pubSubscription.cancel());

      // Unknown ID — must not be delivered anywhere (and must not crash).
      server.publish(id: 99, data: utf8.encode('{"stray":true}'));
      // Known ID delivered after the stray one proves the client survived it.
      server.publish(id: 42, data: utf8.encode('{"ok":true}'));

      await Future<void>.delayed(Duration.zero);
      while (received.isEmpty) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(received, hasLength(1));
      expect(jsonDecode(utf8.decode(received.first.data)), {'ok': true});
    });

    test('same id is re-registered after disconnect/reconnect', () async {
      // Regression test: the client drops the ID registry on disconnect
      // (IDs are server-session-scoped), and on reconnect the server commonly
      // assigns the SAME ID to the channel again. The subscription must
      // re-register it even though its own remembered ID is unchanged.
      await client.connect();

      final sub = client.newSubscription('compacted-channel');
      await sub.subscribe();

      await client.disconnect();

      final resubscribed = _waitForEvent<centrifuge.SubscribedEvent>(sub.subscribed);
      await client.connect();
      await resubscribed;

      // Same ID 42 as before the reconnect.
      final received = <centrifuge.PublicationEvent>[];
      final pubSubscription = sub.publication.listen(received.add);
      addTearDown(() => pubSubscription.cancel());

      server.publish(id: 42, data: utf8.encode('{"after_reconnect":true}'));
      while (received.isEmpty) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(jsonDecode(utf8.decode(received.first.data)), {'after_reconnect': true});
    });

    test('id mapping is dropped on unsubscribe and refreshed on resubscribe', () async {
      await client.connect();

      final sub = client.newSubscription('compacted-channel');
      await sub.subscribe();

      final received = <centrifuge.PublicationEvent>[];
      final pubSubscription = sub.publication.listen(received.add);
      addTearDown(() => pubSubscription.cancel());

      await sub.unsubscribe();

      // Old ID must no longer route to the unsubscribed subscription.
      server.publish(id: 42, data: utf8.encode('{"stale":true}'));

      // Resubscribe — the server assigns a fresh ID.
      channelId = 43;
      await sub.subscribe();

      server.publish(id: 43, data: utf8.encode('{"fresh":true}'));
      while (received.isEmpty) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(received, hasLength(1));
      expect(jsonDecode(utf8.decode(received.first.data)), {'fresh': true});
    });

    test('id mapping is dropped on temporary server-side unsubscribe', () async {
      // Regression test: a server-initiated unsubscribe with code >= 2500 tears
      // down the server-side subscription and moves the client-side one back to
      // Subscribing while the connection stays up — so, unlike a reconnect, the
      // client does not clear its whole ID registry. The numeric channel ID is
      // scoped to the subscription that just went away and the server is free to
      // hand it to another channel, so it must stop routing to this
      // subscription until a new subscribe reply re-establishes it.
      // Mirrors centrifugal/centrifuge-js#364.
      await client.connect();

      // Keep the subscription in Subscribing after the kick: the resubscribe is
      // answered with a temporary error and the retry is pushed far out, so the
      // stale registration is observable instead of being immediately
      // overwritten by a successful resubscribe reply.
      final sub = client.newSubscription(
        'compacted-channel',
        centrifuge.SubscriptionConfig(
          minResubscribeDelay: const Duration(seconds: 30),
          maxResubscribeDelay: const Duration(seconds: 30),
        ),
      );
      await sub.subscribe();

      final received = <centrifuge.PublicationEvent>[];
      final pubSubscription = sub.publication.listen(received.add);
      addTearDown(() => pubSubscription.cancel());

      server.onCommand = (cmd) {
        if (!cmd.hasSubscribe()) return null;
        return protocol.Reply()
          ..id = cmd.id
          ..error = (protocol.Error()
            ..code = 100
            ..message = 'temporary'
            ..temporary = true);
      };

      final subscribing = _waitForEvent<centrifuge.SubscribingEvent>(sub.subscribing);
      server.unsubscribe('compacted-channel', 2500, 'insufficient state');
      await subscribing;
      expect(sub.state, centrifuge.SubscriptionState.subscribing);

      // A push carrying the now-freed ID must not reach this subscription.
      server.publish(id: 42, data: utf8.encode('{"stale":true}'));
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(received, isEmpty);
    });
  });
}
