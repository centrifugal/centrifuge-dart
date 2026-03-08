import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

const url = 'ws://localhost:8000/connection/websocket';
const apiBase = 'http://localhost:8000/api';
const apiKey = 'test-api-key';

int _testCounter = 0;

String uniqueChannel(String ns) {
  _testCounter++;
  return '$ns:test_${DateTime.now().millisecondsSinceEpoch}_$_testCounter';
}

String randomChannel(String base) {
  final rand = Random();
  final suffix =
      List.generate(8, (_) => rand.nextInt(36).toRadixString(36)).join();
  return '${base}_$suffix';
}

Future<void> apiPublish(String channel, Map<String, dynamic> data) async {
  final resp = await http.post(
    Uri.parse('$apiBase/publish'),
    headers: {
      'Content-Type': 'application/json',
      'X-API-Key': apiKey,
    },
    body: jsonEncode({'channel': channel, 'data': data}),
  );
  if (resp.statusCode != 200) {
    throw Exception('publish failed: ${resp.statusCode} ${resp.body}');
  }
}

centrifuge.Client createClient([centrifuge.ClientConfig? config]) {
  return centrifuge.createClient(url, config ?? centrifuge.ClientConfig());
}

Future<T> waitForEvent<T>(Stream<T> stream, {Duration timeout = const Duration(seconds: 5)}) {
  final completer = Completer<T>();
  late StreamSubscription<T> sub;
  final timer = Timer(timeout, () {
    sub.cancel();
    if (!completer.isCompleted) {
      completer.completeError(TimeoutException('timeout waiting for event'));
    }
  });
  sub = stream.listen((event) {
    timer.cancel();
    sub.cancel();
    if (!completer.isCompleted) {
      completer.complete(event);
    }
  });
  return completer.future;
}

Future<List<T>> collectEvents<T>(Stream<T> stream, int count,
    {Duration timeout = const Duration(seconds: 5)}) {
  final completer = Completer<List<T>>();
  final collected = <T>[];
  late StreamSubscription<T> sub;
  final timer = Timer(timeout, () {
    sub.cancel();
    if (!completer.isCompleted) {
      completer.completeError(TimeoutException(
          'timeout collecting $count events (got ${collected.length})'));
    }
  });
  sub = stream.listen((event) {
    collected.add(event);
    if (collected.length >= count) {
      timer.cancel();
      sub.cancel();
      if (!completer.isCompleted) {
        completer.complete(collected);
      }
    }
  });
  return completer.future;
}

void main() {
  group('Client', () {
    test('client starts in disconnected state', () {
      final client = createClient(
        centrifuge.ClientConfig(
            token: "test", data: utf8.encode('test connect data')),
      );
      expect(client.state, centrifuge.State.disconnected);
    });

    test('connect emits error event when url invalid', () async {
      final client = centrifuge.createClient(
        "invalid",
        centrifuge.ClientConfig(data: utf8.encode('test connect data')),
      );
      final errorFinish = client.error.first;
      client.connect();
      final event = await errorFinish;
      expect(event.error.toString().contains('Unsupported URL scheme'), true);
    });

    test('invalid token - disconnect code received', () async {
      final client = createClient(centrifuge.ClientConfig(token: "invalid"));
      final disconnectFinish = client.disconnected.first;
      client.connect();
      final disconnect = await disconnectFinish;
      expect(client.state, centrifuge.State.disconnected);
      expect(disconnect.code, 3500);
    });

    test('can connect and disconnect', () async {
      final client = createClient(
        centrifuge.ClientConfig(data: utf8.encode('test connect data')),
      );
      final connectFinish = client.connected.first;
      client.connect();
      final event = await connectFinish;
      expect(event.client != "", true);
      expect(client.state, centrifuge.State.connected);

      final disconnectFinish = client.disconnected.first;
      client.disconnect();
      await disconnectFinish;
      expect(client.state, centrifuge.State.disconnected);
    });

    test('connect disconnect loop', () async {
      final client = createClient();
      final disconnectedFuture = client.disconnected.first;
      for (var i = 0; i < 10; i++) {
        client.connect();
        client.disconnect();
      }
      expect(client.state, centrifuge.State.disconnected);
      await disconnectedFuture;
    });

    test('rpc returns error for unknown method', () async {
      final client = createClient();
      await client.connect();
      // RPC method does not exist on server, so we expect an error code 108 (not available).
      try {
        await client.rpc('method', utf8.encode('{}'));
        fail('expected error');
      } catch (e) {
        expect(e, isA<centrifuge.Error>());
        expect((e as centrifuge.Error).code, 108);
      }
      await client.disconnect();
    });
  });

  group('Subscription', () {
    test('newSubscription/removeSubscription work correctly', () async {
      final client = createClient();
      final s1 = client.newSubscription('some_channel');
      expect(client.getSubscription(s1.channel) != null, true);
      expect(client.subscriptions().isNotEmpty, true);
      await client.removeSubscription(s1);
      expect(client.getSubscription(s1.channel) != null, false);
    });

    test('newSubscription throws duplicate', () {
      final client = createClient();
      client.newSubscription('channel');
      expect(() => client.newSubscription('channel'), throwsException);
    });

    test('subscribe and unsubscribe', () async {
      final client = createClient();
      await client.connect();

      final channel = randomChannel('test');
      final sub = client.newSubscription(channel);

      final unsubFuture = waitForEvent(sub.unsubscribed);

      await sub.subscribe();
      expect(sub.state, centrifuge.SubscriptionState.subscribed);
      expect(client.state, centrifuge.State.connected);

      await sub.unsubscribe();
      await client.disconnect();

      final ctx = await unsubFuture;
      expect(sub.state, centrifuge.SubscriptionState.unsubscribed);
      expect(client.state, centrifuge.State.disconnected);
      expect(ctx.code, 0); // unsubscribeCalled
    });

    test('publish and receive message', () async {
      final client = createClient();
      await client.connect();

      final channel = randomChannel('test');
      final sub = client.newSubscription(channel);

      final pubFuture = waitForEvent<centrifuge.PublicationEvent>(sub.publication);
      await sub.subscribe();

      final message = utf8.encode(jsonEncode({"my": "data"}));
      await sub.publish(message);

      final ctx = await pubFuture;
      expect(jsonDecode(utf8.decode(ctx.data)), {"my": "data"});

      await client.disconnect();
    });

    test('subscribe and unsubscribe loop', () async {
      final client = createClient();
      await client.connect();

      final sub = client.newSubscription(randomChannel('test'));

      final unsubFuture = waitForEvent(sub.unsubscribed);

      for (var i = 0; i < 10; i++) {
        sub.subscribe();
        sub.unsubscribe();
      }
      expect(sub.state, centrifuge.SubscriptionState.unsubscribed);
      await unsubFuture;

      await client.disconnect();
    });

    test('subscribes with fossil and receives published messages', () async {
      final client = createClient();

      final channel = randomChannel('some_channel');
      final s1 = client.newSubscription(
          channel,
          centrifuge.SubscriptionConfig(
            delta: centrifuge.DeltaType.fossil,
          ));

      final received = <centrifuge.PublicationEvent>[];
      final sub = s1.publication.listen((event) {
        received.add(event);
      });

      await client.connect();
      await s1.subscribe();

      final message = utf8.encode('hello world');

      await s1.publish(message);
      await s1.publish(message);

      await Future.delayed(Duration(seconds: 2));

      expect(received.length, 2);
      for (var event in received) {
        expect(event.data, message);
      }

      await sub.cancel();
      await client.removeSubscription(s1);
      expect(client.getSubscription(channel), isNull);
      await client.disconnect();
    });
  });

  group('Presence', () {
    test('subscribe and presence', () async {
      final client = createClient();
      await client.connect();

      final channel = randomChannel('test');
      final sub = client.newSubscription(channel);
      await sub.subscribe();

      final presence = await sub.presence();
      expect(presence.clients.length, greaterThan(0));

      final presenceStats = await sub.presenceStats();
      expect(presenceStats.numClients, greaterThan(0));
      expect(presenceStats.numUsers, greaterThan(0));

      await client.disconnect();
    });
  });

  group('History', () {
    test('history after publish', () async {
      final client = createClient();
      await client.connect();

      final channel = randomChannel('test');
      final sub = client.newSubscription(channel);
      await sub.subscribe();

      await sub.publish(utf8.encode(jsonEncode({'seq': 1})));
      await sub.publish(utf8.encode(jsonEncode({'seq': 2})));

      // Allow messages to propagate.
      await Future.delayed(Duration(milliseconds: 500));

      final history = await sub.history(limit: 10);
      expect(history.publications.length, 2);

      await client.disconnect();
    });
  });

  group('Recovery', () {
    test('stream: recovery after disconnect delivers missed publications',
        () async {
      final client = createClient();
      await client.connect();

      final ch = uniqueChannel('recovery');
      final sub = client.newSubscription(ch);

      final firstPubFuture =
          waitForEvent<centrifuge.PublicationEvent>(sub.publication);

      await sub.subscribe();

      // Publish first message and confirm live delivery.
      await apiPublish(ch, {'seq': 1, 'msg': 'before disconnect'});
      final first = await firstPubFuture;
      expect(jsonDecode(utf8.decode(first.data)),
          {'seq': 1, 'msg': 'before disconnect'});

      // Disconnect.
      await client.disconnect();

      // Publish while disconnected - these should be recovered.
      await apiPublish(ch, {'seq': 2, 'msg': 'missed one'});
      await apiPublish(ch, {'seq': 3, 'msg': 'missed two'});
      await apiPublish(ch, {'seq': 4, 'msg': 'missed three'});

      // Set up listeners before reconnect.
      final resubFuture =
          waitForEvent<centrifuge.SubscribedEvent>(sub.subscribed);
      final recoveredPubs =
          collectEvents<centrifuge.PublicationEvent>(sub.publication, 3);

      await client.connect();

      final resubCtx = await resubFuture;
      expect(resubCtx.recovered, true);
      expect(resubCtx.wasRecovering, true);

      final pubs = await recoveredPubs;
      expect(jsonDecode(utf8.decode(pubs[0].data)),
          {'seq': 2, 'msg': 'missed one'});
      expect(jsonDecode(utf8.decode(pubs[1].data)),
          {'seq': 3, 'msg': 'missed two'});
      expect(jsonDecode(utf8.decode(pubs[2].data)),
          {'seq': 4, 'msg': 'missed three'});

      // Verify live delivery still works after recovery.
      final livePubFuture =
          waitForEvent<centrifuge.PublicationEvent>(sub.publication);
      await apiPublish(ch, {'seq': 5, 'msg': 'after recovery'});
      final live = await livePubFuture;
      expect(jsonDecode(utf8.decode(live.data)),
          {'seq': 5, 'msg': 'after recovery'});

      await client.disconnect();
    });

    test('stream: recovery after unsubscribe/resubscribe', () async {
      final client = createClient();
      await client.connect();

      final ch = uniqueChannel('recovery');
      final sub = client.newSubscription(ch);

      final firstPubFuture =
          waitForEvent<centrifuge.PublicationEvent>(sub.publication);

      await sub.subscribe();

      await apiPublish(ch, {'seq': 1, 'msg': 'initial'});
      await firstPubFuture;

      // Unsubscribe - position is saved internally.
      await sub.unsubscribe();

      // Publish while unsubscribed.
      await apiPublish(ch, {'seq': 2, 'msg': 'while away'});
      await apiPublish(ch, {'seq': 3, 'msg': 'still away'});

      final resubFuture =
          waitForEvent<centrifuge.SubscribedEvent>(sub.subscribed);
      final recoveredPubs =
          collectEvents<centrifuge.PublicationEvent>(sub.publication, 2);

      await sub.subscribe();

      final resubCtx = await resubFuture;
      expect(resubCtx.recovered, true);

      final pubs = await recoveredPubs;
      expect(jsonDecode(utf8.decode(pubs[0].data)),
          {'seq': 2, 'msg': 'while away'});
      expect(jsonDecode(utf8.decode(pubs[1].data)),
          {'seq': 3, 'msg': 'still away'});

      await client.disconnect();
    });

    test('stream: unrecoverable position resubscribes without recovery',
        () async {
      final client = createClient();
      await client.connect();

      final ch = uniqueChannel('smallhistory');
      final sub = client.newSubscription(ch);

      final firstPubFuture =
          waitForEvent<centrifuge.PublicationEvent>(sub.publication);

      await sub.subscribe();

      // Publish first message to establish position.
      await apiPublish(ch, {'seq': 1});
      await firstPubFuture;

      // Unsubscribe.
      await sub.unsubscribe();

      // Publish enough to overflow history (size=2).
      await apiPublish(ch, {'seq': 2});
      await apiPublish(ch, {'seq': 3});
      await apiPublish(ch, {'seq': 4});
      await apiPublish(ch, {'seq': 5});

      // Resubscribe - recovery should fail because position is lost.
      final resubFuture =
          waitForEvent<centrifuge.SubscribedEvent>(sub.subscribed);

      await sub.subscribe();

      final resubCtx = await resubFuture;
      expect(resubCtx.wasRecovering, true);
      expect(resubCtx.recovered, false);

      // Verify live delivery still works after failed recovery.
      final livePubFuture =
          waitForEvent<centrifuge.PublicationEvent>(sub.publication);
      await apiPublish(ch, {'seq': 6});
      final live = await livePubFuture;
      expect(jsonDecode(utf8.decode(live.data)), {'seq': 6});

      await client.disconnect();
    });
  });

  group('Delta', () {
    test('stream delta: successive publications decoded correctly', () async {
      final client = createClient();
      await client.connect();

      final ch = uniqueChannel('delta');
      final sub = client.newSubscription(
          ch, centrifuge.SubscriptionConfig(delta: centrifuge.DeltaType.fossil));

      final pubs =
          collectEvents<centrifuge.PublicationEvent>(sub.publication, 3);

      await sub.subscribe();

      // Publish 3 messages with similar structure — delta should kick in after first.
      final payload = 'a' * 500;
      await apiPublish(ch, {'counter': 1, 'payload': payload});
      await apiPublish(ch, {'counter': 2, 'payload': payload});
      await apiPublish(
          ch, {'counter': 3, 'payload': '${payload.substring(0, 499)}b'});

      final received = await pubs;
      expect(jsonDecode(utf8.decode(received[0].data)),
          {'counter': 1, 'payload': payload});
      expect(jsonDecode(utf8.decode(received[1].data)),
          {'counter': 2, 'payload': payload});
      expect(jsonDecode(utf8.decode(received[2].data)),
          {'counter': 3, 'payload': '${payload.substring(0, 499)}b'});

      await client.disconnect();
    });

    test('stream delta: recovery after disconnect', () async {
      final client = createClient();
      await client.connect();

      final ch = uniqueChannel('delta');
      final sub = client.newSubscription(
          ch, centrifuge.SubscriptionConfig(delta: centrifuge.DeltaType.fossil));

      final firstPubFuture =
          waitForEvent<centrifuge.PublicationEvent>(sub.publication);

      await sub.subscribe();

      // Publish first message and wait to confirm live.
      await apiPublish(ch, {'step': 1, 'value': 'hello world'});
      final first = await firstPubFuture;
      expect(jsonDecode(utf8.decode(first.data)),
          {'step': 1, 'value': 'hello world'});

      // Disconnect.
      await client.disconnect();

      // Publish while disconnected — these will be recovered.
      await apiPublish(ch, {'step': 2, 'value': 'hello world!'});
      await apiPublish(ch, {'step': 3, 'value': 'hello earth!'});

      // Reconnect with recovery.
      final resubFuture =
          waitForEvent<centrifuge.SubscribedEvent>(sub.subscribed);
      final recoveredPubs =
          collectEvents<centrifuge.PublicationEvent>(sub.publication, 2);

      await client.connect();

      final resubCtx = await resubFuture;
      expect(resubCtx.recovered, true);

      final receivedPubs = await recoveredPubs;
      expect(jsonDecode(utf8.decode(receivedPubs[0].data)),
          {'step': 2, 'value': 'hello world!'});
      expect(jsonDecode(utf8.decode(receivedPubs[1].data)),
          {'step': 3, 'value': 'hello earth!'});

      await client.disconnect();
    });

    test('stream delta: recovery after unsubscribe/resubscribe', () async {
      final client = createClient();
      await client.connect();

      final ch = uniqueChannel('delta');
      final sub = client.newSubscription(
          ch, centrifuge.SubscriptionConfig(delta: centrifuge.DeltaType.fossil));

      final firstPubFuture =
          waitForEvent<centrifuge.PublicationEvent>(sub.publication);

      await sub.subscribe();

      await apiPublish(ch, {'n': 1, 'text': 'base message content'});
      await firstPubFuture;

      await sub.unsubscribe();

      // Publish while unsubscribed.
      await apiPublish(ch, {'n': 2, 'text': 'base message content updated'});
      await apiPublish(
          ch, {'n': 3, 'text': 'base message content updated again'});

      final resubFuture =
          waitForEvent<centrifuge.SubscribedEvent>(sub.subscribed);
      final recoveredPubs =
          collectEvents<centrifuge.PublicationEvent>(sub.publication, 2);

      await sub.subscribe();

      final resubCtx = await resubFuture;
      expect(resubCtx.recovered, true);

      final receivedPubs = await recoveredPubs;
      expect(jsonDecode(utf8.decode(receivedPubs[0].data)),
          {'n': 2, 'text': 'base message content updated'});
      expect(jsonDecode(utf8.decode(receivedPubs[1].data)),
          {'n': 3, 'text': 'base message content updated again'});

      await client.disconnect();
    });

    test('stream delta: many publications with small diffs', () async {
      final client = createClient();
      await client.connect();

      final ch = uniqueChannel('delta');
      final sub = client.newSubscription(
          ch, centrifuge.SubscriptionConfig(delta: centrifuge.DeltaType.fossil));

      const count = 10;
      final allPubs =
          collectEvents<centrifuge.PublicationEvent>(sub.publication, count,
              timeout: Duration(seconds: 15));

      await sub.subscribe();

      for (var i = 0; i < count; i++) {
        await apiPublish(ch, {'index': i, 'padding': 'x' * 500});
      }

      final received = await allPubs;
      for (var i = 0; i < count; i++) {
        expect(jsonDecode(utf8.decode(received[i].data)),
            {'index': i, 'padding': 'x' * 500});
      }

      await client.disconnect();
    }, timeout: Timeout(Duration(seconds: 20)));
  });

  group('Token auth', () {
    // Connection token for anonymous user without ttl.
    // Using HMAC secret key "secret".
    const connectToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3MzgwNzg4MjR9.MTb3higWfFW04E9-8wmTFOcf4MEm-rMDQaNKJ1VU_n4';

    test('connects with token', () async {
      final client = createClient(centrifuge.ClientConfig(token: connectToken));
      await client.connect();
      expect(client.state, centrifuge.State.connected);
      await client.disconnect();
    });

    test('connects with getToken callback', () async {
      var numTokenCalls = 0;
      final client = createClient(centrifuge.ClientConfig(
        getToken: (_) async {
          numTokenCalls++;
          return connectToken;
        },
      ));
      await client.connect();
      expect(client.state, centrifuge.State.connected);
      expect(numTokenCalls, 1);
      await client.disconnect();
    });

    test('disconnected with unauthorized', () async {
      final client = createClient(centrifuge.ClientConfig(
        getToken: (_) async {
          throw centrifuge.UnauthorizedException();
        },
      ));

      final disconnectFuture = waitForEvent<centrifuge.DisconnectedEvent>(
          client.disconnected);

      client.connect();

      final ctx = await disconnectFuture;
      expect(client.state, centrifuge.State.disconnected);
      expect(ctx.code, 1); // unauthorized
    });
  });

  group('Multiple subscriptions', () {
    test('subscribes and unsubscribes from many subs', () async {
      final client = createClient();
      await client.connect();

      final channels = ['test1', 'test2', 'test3', 'test4', 'test5']
          .map(randomChannel)
          .toList();
      final subs = <centrifuge.Subscription>[];

      for (final ch in channels) {
        final sub = client.newSubscription(ch);
        await sub.subscribe();
        expect(sub.state, centrifuge.SubscriptionState.subscribed);
        subs.add(sub);
      }

      expect(client.state, centrifuge.State.connected);

      for (final sub in subs) {
        await sub.unsubscribe();
        expect(sub.state, centrifuge.SubscriptionState.unsubscribed);
      }

      await client.disconnect();
      expect(client.state, centrifuge.State.disconnected);
    });
  });
}
