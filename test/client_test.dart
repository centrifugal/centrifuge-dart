import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:fixnum/fixnum.dart';
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

Future<void> apiPost(String path, Map<String, dynamic> body) async {
  final resp = await http.post(
    Uri.parse('$apiBase/$path'),
    headers: {
      'Content-Type': 'application/json',
      'X-API-Key': apiKey,
    },
    body: jsonEncode(body),
  );
  if (resp.statusCode != 200) {
    throw Exception('$path failed: ${resp.statusCode} ${resp.body}');
  }
  final decoded = jsonDecode(resp.body) as Map<String, dynamic>;
  if (decoded.containsKey('error')) {
    throw Exception('$path error: ${decoded['error']}');
  }
}

/// Force-disconnect a specific client from the server.
/// If [code]/[reason] are provided, the server emits that disconnect frame.
Future<void> apiDisconnectClient(String clientId, {int? code, String? reason}) {
  final body = <String, dynamic>{'client': clientId};
  if (code != null || reason != null) {
    body['disconnect'] = {
      if (code != null) 'code': code,
      if (reason != null) 'reason': reason,
    };
  }
  return apiPost('disconnect', body);
}

/// Force-unsubscribe a client from a single channel without disconnecting it.
Future<void> apiUnsubscribeClient(String clientId, String channel) {
  return apiPost('unsubscribe', {'client': clientId, 'channel': channel});
}

/// Read the current stream top position of a channel via the server API.
Future<centrifuge.StreamPosition> apiHistory(String channel) async {
  final resp = await http.post(
    Uri.parse('$apiBase/history'),
    headers: {
      'Content-Type': 'application/json',
      'X-API-Key': apiKey,
    },
    body: jsonEncode({'channel': channel, 'limit': 0}),
  );
  if (resp.statusCode != 200) {
    throw Exception('history failed: ${resp.statusCode} ${resp.body}');
  }
  final decoded = jsonDecode(resp.body) as Map<String, dynamic>;
  if (decoded.containsKey('error')) {
    throw Exception('history error: ${decoded['error']}');
  }
  final result = decoded['result'] as Map<String, dynamic>;
  return centrifuge.StreamPosition(
      Int64(result['offset'] as int? ?? 0), result['epoch'] as String? ?? '');
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

  group('Pre-connect buffering and retries', () {
    // Ports of equivalent tests from centrifuge-js: pre-connect buffering and
    // getToken/getData error retry semantics that this client is expected to
    // share with the JS reference implementation.

    test('rpc issued during connecting state queues until connected',
        () async {
      // The dart client throws ClientDisconnectedError when ready() is called
      // from disconnected state — operations issued *before* connect() are
      // not queued (this differs from centrifuge-js). Once we're already in
      // the `connecting` state though, pending operations must hold until the
      // connection settles. Synchronously calling connect() then rpc() keeps
      // us in connecting between the two.
      final client = createClient();
      // ignore: unawaited_futures
      client.connect();
      // State is now `connecting` (set synchronously inside connect()).
      expect(client.state, centrifuge.State.connecting);
      try {
        await client.rpc('method', utf8.encode('{}'));
        fail('expected centrifuge.Error 108');
      } on centrifuge.Error catch (e) {
        // Round-trip happened, server returned 108 for unknown method.
        expect(e.code, 108);
      }
      await client.disconnect();
    });

    test('publish issued during connecting state queues until connected',
        () async {
      final client = createClient();
      final ch = randomChannel('buf');
      // ignore: unawaited_futures
      client.connect();
      expect(client.state, centrifuge.State.connecting);
      // Publish has to wait for the connection but should resolve OK.
      await client.publish(ch, utf8.encode('hello'));
      await client.disconnect();
    });

    test('retries connection getToken transient error', () async {
      // First call to getToken throws — client must retry instead of giving
      // up. Eventually the connection should be established with the second
      // (successful) token.
      // Pre-signed JWT (HS256, secret="secret"), iat only, no expiry.
      const validToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3MzgwNzg4MjR9.MTb3higWfFW04E9-8wmTFOcf4MEm-rMDQaNKJ1VU_n4';
      var calls = 0;
      final client = centrifuge.createClient(
        url,
        centrifuge.ClientConfig(
          minReconnectDelay: const Duration(milliseconds: 1),
          getToken: (centrifuge.ConnectionTokenEvent _) async {
            calls++;
            if (calls == 1) {
              throw Exception('transient getToken error');
            }
            return validToken;
          },
        ),
      );

      // Listen for the error event the client emits on the failed attempt;
      // it must NOT cause the disconnected state.
      final errors = <centrifuge.ErrorEvent>[];
      final errSub = client.error.listen(errors.add);
      addTearDown(() => errSub.cancel());

      // First call to connect() returns once the *initial* attempt is done —
      // including the failed-getToken path that schedules a reconnect. Wait
      // for the actual `connected` event before asserting.
      final connectedFuture =
          waitForEvent<centrifuge.ConnectedEvent>(client.connected);
      // ignore: unawaited_futures
      client.connect();
      await connectedFuture.timeout(const Duration(seconds: 5));
      expect(client.state, centrifuge.State.connected);
      expect(calls, 2, reason: 'getToken should be retried exactly once');
      expect(errors.length >= 1, true,
          reason: 'an error event should fire for the failing call');
      expect(errors.first.error, isA<centrifuge.RefreshError>());
      await client.disconnect();
    });

    test('retries subscription getToken transient error', () async {
      // Subscription-level getToken throws on first call but succeeds on
      // second; client must retry until the subscription is established.
      // Uses the same pre-signed JWT as centrifuge-js's recovery test —
      // signed for channel "test1" with HS256 secret "secret" (matches our
      // docker-compose).
      const test1SubToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3Mzc1MzIzNDgsImNoYW5uZWwiOiJ0ZXN0MSJ9.eqPQxbBtyYxL8Hvbkm-P6aH7chUsSG_EMWe-rTwF_HI';
      final client = createClient();
      await client.connect();
      var calls = 0;
      final sub = client.newSubscription(
        'test1',
        centrifuge.SubscriptionConfig(
          minResubscribeDelay: const Duration(milliseconds: 1),
          getToken: (centrifuge.SubscriptionTokenEvent _) async {
            calls++;
            if (calls == 1) {
              throw Exception('transient sub getToken error');
            }
            return test1SubToken;
          },
        ),
      );

      final subErrors = <centrifuge.SubscriptionErrorEvent>[];
      final errSub = sub.error.listen(subErrors.add);
      addTearDown(() => errSub.cancel());

      // Listen for the eventual subscribed event before kicking subscribe()
      // so the retry result isn't missed.
      final subscribedFuture =
          waitForEvent<centrifuge.SubscribedEvent>(sub.subscribed);
      // ignore: unawaited_futures
      sub.subscribe();
      await subscribedFuture.timeout(const Duration(seconds: 5));
      expect(sub.state, centrifuge.SubscriptionState.subscribed);
      expect(calls, 2, reason: 'sub getToken should be retried exactly once');
      expect(subErrors.length >= 1, true,
          reason: 'subscription error event should have fired for first call');

      await client.disconnect();
    });

    test('subscription unauthorized: sub unsubscribed, client stays connected',
        () async {
      // Throwing UnauthorizedException from the subscription's getToken
      // should put just the subscription into the unsubscribed state with
      // code 1 (unauthorized) — the client itself must remain connected so
      // other subscriptions are unaffected.
      final client = createClient();
      await client.connect();

      final ch = randomChannel('sub-unauth');
      final sub = client.newSubscription(
        ch,
        centrifuge.SubscriptionConfig(
          getToken: (centrifuge.SubscriptionTokenEvent _) async {
            throw centrifuge.UnauthorizedException();
          },
        ),
      );

      final unsubscribed =
          waitForEvent<centrifuge.UnsubscribedEvent>(sub.unsubscribed);
      await sub.subscribe();

      final ctx = await unsubscribed.timeout(const Duration(seconds: 5));
      expect(ctx.code, 1, reason: 'unsubscribedCodeUnauthorized');
      expect(sub.state, centrifuge.SubscriptionState.unsubscribed);
      // Client remains healthy.
      expect(client.state, centrifuge.State.connected);

      // A separate subscription on the same client still works.
      final ok = client.newSubscription(randomChannel('sub-ok'));
      await ok.subscribe();
      expect(ok.state, centrifuge.SubscriptionState.subscribed);

      await client.disconnect();
    });

    test('3014 disconnect: connection token cleared, getToken called again',
        () async {
      // Server-initiated disconnect with code 3014 ("state invalidated") must
      // force the client to refetch the connection token via getToken on the
      // automatic reconnect, AND wipe stream subscription positions so the
      // resubscribe does a full re-sync. Mirrors centrifuge-js behaviour.
      const validToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3MzgwNzg4MjR9.MTb3higWfFW04E9-8wmTFOcf4MEm-rMDQaNKJ1VU_n4';
      var calls = 0;
      final client = centrifuge.createClient(
        url,
        centrifuge.ClientConfig(
          minReconnectDelay: const Duration(milliseconds: 1),
          getToken: (centrifuge.ConnectionTokenEvent _) async {
            calls++;
            return validToken;
          },
        ),
      );

      // Capture the assigned client id for targeting the kick.
      String clientId = '';
      final connectedListener =
          client.connected.listen((e) => clientId = e.client);
      addTearDown(() => connectedListener.cancel());

      await client.connect();
      expect(calls, 1);
      expect(client.state, centrifuge.State.connected);

      // Wait for the next `connected` after the 3014 kick. Set the listener
      // up first; broadcast streams don't replay past events.
      final reconnected =
          waitForEvent<centrifuge.ConnectedEvent>(client.connected);
      await apiDisconnectClient(clientId, code: 3014, reason: 'invalidated');

      await reconnected.timeout(const Duration(seconds: 5));
      expect(client.state, centrifuge.State.connected);
      expect(calls, 2,
          reason:
              'getToken must be called again after 3014 — state was invalidated');

      await client.disconnect();
    });

    test('unsubscribe while Subscribe in flight cleans up server-side sub',
        () async {
      // Race: subscribe() puts a SubscribeRequest on the wire (state=
      // Subscribing, _inflight=true) and the test calls unsubscribe()
      // before the SubscribeResult arrives. The server has likely created a
      // subscription from our request — without a cleanup Unsubscribe the
      // server keeps pushing publications to a sub the client already
      // cancelled. We verify the cleanup by querying the channel presence:
      // our client id must not appear there once the dust settles.
      final client = createClient();
      String clientId = '';
      final connectedListener =
          client.connected.listen((e) => clientId = e.client);
      addTearDown(() => connectedListener.cancel());

      await client.connect();
      expect(client.state, centrifuge.State.connected);

      final ch = randomChannel('inflight-cancel');
      final sub = client.newSubscription(ch);

      // Catch any spurious publications fired after unsubscribe.
      final latePubs = <centrifuge.PublicationEvent>[];
      final pubListener = sub.publication.listen(latePubs.add);
      addTearDown(() => pubListener.cancel());

      // Trigger the race: subscribe then unsubscribe synchronously, before
      // the SubscribeResult can arrive.
      // ignore: unawaited_futures
      sub.subscribe();
      expect(sub.state, centrifuge.SubscriptionState.subscribing);
      final unsubscribed =
          waitForEvent<centrifuge.UnsubscribedEvent>(sub.unsubscribed);
      // ignore: unawaited_futures
      sub.unsubscribe();
      expect(sub.state, centrifuge.SubscriptionState.unsubscribed);

      await unsubscribed.timeout(const Duration(seconds: 5));
      // Give the in-flight Subscribe + cleanup Unsubscribe a moment to
      // round-trip to the server. The grace window is short — both messages
      // are sent on the same connection so the server processes them in
      // order.
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Server-side ground truth: the channel presence for `ch` must not
      // contain our client id. If the cleanup Unsubscribe was missing, the
      // server-side sub would still be active and the client id would show
      // up here.
      final presenceResp = await http.post(
        Uri.parse('$apiBase/presence'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': apiKey,
        },
        body: jsonEncode({'channel': ch}),
      );
      expect(presenceResp.statusCode, 200);
      final body = jsonDecode(presenceResp.body) as Map<String, dynamic>;
      final result = (body['result'] as Map?) ?? const {};
      final presence = (result['presence'] as Map?) ?? const {};
      expect(presence.containsKey(clientId), false,
          reason:
              'after subscribe/unsubscribe race, server-side presence must not '
              'list this client on the channel — got: ${presence.keys}');

      // Publish to the channel — no PublicationEvent should reach the local
      // (already-unsubscribed) subscription.
      await apiPublish(ch, {'after': 'unsubscribe'});
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(latePubs, isEmpty,
          reason:
              'publications must not be delivered to a subscription cancelled '
              'mid-Subscribe');

      await client.disconnect();
    });

    test('unsubscribe right after connect: race resolves cleanly', () async {
      // Mirrors the JS test: subscribe → disconnect → connect → unsubscribe
      // all called synchronously without awaits. Eventually the sub must end
      // up unsubscribed and a fresh subscribe must succeed.
      final client = createClient();
      await client.connect();
      final sub = client.newSubscription(randomChannel('race'));

      // ignore: unawaited_futures
      sub.subscribe();
      // ignore: unawaited_futures
      client.disconnect();
      // ignore: unawaited_futures
      client.connect();

      final unsubscribed =
          waitForEvent<centrifuge.UnsubscribedEvent>(sub.unsubscribed);
      // ignore: unawaited_futures
      sub.unsubscribe();

      // Sub state should be unsubscribed (sync state set inside unsubscribe).
      expect(sub.state, centrifuge.SubscriptionState.unsubscribed);
      await unsubscribed.timeout(const Duration(seconds: 5));

      // Client should eventually settle to connected.
      final deadline = DateTime.now().add(const Duration(seconds: 5));
      while (client.state != centrifuge.State.connected &&
          DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      expect(client.state, centrifuge.State.connected);

      // Fresh subscribe must work after the churn.
      final subscribed =
          waitForEvent<centrifuge.SubscribedEvent>(sub.subscribed);
      await sub.subscribe();
      await subscribed.timeout(const Duration(seconds: 5));
      expect(sub.state, centrifuge.SubscriptionState.subscribed);

      await client.disconnect();
    });
  });

  group('Lifecycle ordering', () {
    test('disconnect future resolves only after transport close completes', () async {
      // Awaiting disconnect() must not return until _processDisconnect has
      // closed the transport — guards against the previous fire-and-forget
      // pattern in processDisconnect / _failUnauthorized that returned early.
      final client = createClient();
      await client.connect();
      expect(client.state, centrifuge.State.connected);

      final disconnectEventFuture = client.disconnected.first;
      await client.disconnect();
      // Event must have already been delivered by the time disconnect() resolves.
      expect(client.state, centrifuge.State.disconnected);
      // And awaiting the event future is now instant — it already fired.
      await disconnectEventFuture.timeout(const Duration(milliseconds: 100));
    });

    test('reconnect from inside disconnected handler succeeds', () async {
      // Triggers the _inConnect / state interaction: a sync stream listener
      // calling connect() while still inside _processDisconnect.
      final client = createClient();
      await client.connect();

      final reconnected = Completer<void>();
      late StreamSubscription<centrifuge.DisconnectedEvent> sub;
      sub = client.disconnected.listen((_) async {
        sub.cancel();
        try {
          await client.connect();
          if (!reconnected.isCompleted) reconnected.complete();
        } catch (e) {
          if (!reconnected.isCompleted) reconnected.completeError(e);
        }
      });

      await client.disconnect();
      await reconnected.future.timeout(const Duration(seconds: 5));
      expect(client.state, centrifuge.State.connected);
      await client.disconnect();
    });

    test('close makes client unusable and closes streams', () async {
      final client = createClient();
      await client.connect();
      final disconnectedDone = client.disconnected.toList();

      await client.close();
      expect(client.state, centrifuge.State.disconnected);

      // Streams are closed — toList resolves on stream close.
      final events = await disconnectedDone.timeout(const Duration(seconds: 2));
      expect(events.length, 1);
      expect(events.first.code, 4); // disconnectedCodeClientClosed

      // All public methods now throw ClientClosedError.
      expect(() => client.connect(), throwsA(isA<centrifuge.ClientClosedError>()));
      expect(() => client.disconnect(), throwsA(isA<centrifuge.ClientClosedError>()));
      expect(() => client.ready(), throwsA(isA<centrifuge.ClientClosedError>()));
      expect(() => client.newSubscription('x'),
          throwsA(isA<centrifuge.ClientClosedError>()));

      // close() is idempotent.
      await client.close();
    });

    test('close while connecting cleans up and disables client', () async {
      final client = createClient();
      // Kick off connect but don't await — close() should interrupt cleanly.
      // ignore: unawaited_futures
      client.connect();
      await client.close();
      expect(client.state, centrifuge.State.disconnected);
      expect(() => client.connect(), throwsA(isA<centrifuge.ClientClosedError>()));
    });

    test('close errors pending ready() futures instead of leaking them', () async {
      // Don't connect — subscription stays in subscribing indefinitely so
      // there is no race between "subscribe completes" and "close() fires".
      final client = createClient();

      final sub = client.newSubscription(uniqueChannel('default'));
      await sub.subscribe(); // moves to subscribing; no request sent (client not connected)

      // Attach listener before close() so the error is never unhandled.
      final readyDone = expectLater(
          sub.ready(), throwsA(isA<centrifuge.SubscriptionUnsubscribedError>()));

      await client.close(); // subscription.close() must error the pending ready()
      await readyDone;
    });

    test('removeSubscription after close does not throw StateError', () async {
      final client = createClient();
      await client.connect();

      final sub = client.newSubscription(uniqueChannel('default'));
      await sub.subscribe();
      await client.close();

      // Before the fix, subscription.close() left state=subscribing with closed
      // stream controllers. removeSubscription then called moveToUnsubscribed,
      // which tried to emit on a closed controller → unhandled StateError.
      await expectLater(client.removeSubscription(sub), completes);
    });

    test('unsubscribe during getToken does not create a server-side subscription', () async {
      final client = createClient();
      await client.connect();

      final channel = uniqueChannel('default');

      // Block getToken until we explicitly release it so we can call
      // unsubscribe() while the token fetch is in progress.
      final tokenCompleter = Completer<String>();

      final sub = client.newSubscription(
          channel,
          centrifuge.SubscriptionConfig(
            getToken: (_) => tokenCompleter.future,
          ));

      final publications = <centrifuge.PublicationEvent>[];
      sub.publication.listen((p) => publications.add(p));

      // Start subscribing — will block inside getToken.
      // ignore: unawaited_futures
      sub.subscribe();

      // Unsubscribe while getToken is still pending.
      await sub.unsubscribe();
      expect(sub.state, centrifuge.SubscriptionState.unsubscribed);

      // Release the token. Without the fix, _resubscribe() proceeds past the
      // token block and sends a SubscribeRequest despite state=unsubscribed,
      // leaving a server-side subscription that delivers publications.
      tokenCompleter.complete('any-token');

      // Give everything time to settle.
      await Future<void>.delayed(Duration(milliseconds: 200));

      // Publish to the channel from the server side.
      await apiPublish(channel, {'msg': 'should-not-arrive'});
      await Future<void>.delayed(Duration(milliseconds: 100));

      // The subscription must still be unsubscribed and must not have received
      // any publications from the spurious server-side subscription.
      expect(sub.state, centrifuge.SubscriptionState.unsubscribed);
      expect(publications, isEmpty);

      await client.close();
    });

    test('subscribe() on a closed subscription throws SubscriptionUnsubscribedError',
        () async {
      final client = createClient();
      await client.connect();

      final sub = client.newSubscription(uniqueChannel('default'));
      await sub.subscribe();
      await client.close();

      // After close(), the subscription is closed. subscribe() must throw a
      // meaningful error rather than a StateError on a closed stream controller.
      expect(
          sub.subscribe(),
          throwsA(isA<centrifuge.ClientClosedError>()));
    });
  });

  group('Stream recovery (extended)', () {
    test('out-of-band recovery via SubscriptionConfig.since', () async {
      // Establish position with one subscription, capture its stream position,
      // tear it down, publish more, then re-subscribe with `since` set to the
      // captured position — server must replay the publications since then.
      final client = createClient();
      await client.connect();

      final ch = uniqueChannel('recovery');
      final firstSub = client.newSubscription(ch);
      final firstSubscribed =
          waitForEvent<centrifuge.SubscribedEvent>(firstSub.subscribed);
      final firstPub =
          waitForEvent<centrifuge.PublicationEvent>(firstSub.publication);
      await firstSub.subscribe();
      await firstSubscribed;
      await apiPublish(ch, {'seq': 1});
      final firstPubEvent = await firstPub;
      // Position after seeing pub#1 — comes from the pub itself.
      final positionAfterFirst = centrifuge.StreamPosition(
          firstPubEvent.offset, (await firstSubscribed).streamPosition!.epoch);

      // Drop the original subscription entirely (simulates app restart).
      await client.removeSubscription(firstSub);

      // Publish while we have no subscription.
      await apiPublish(ch, {'seq': 2});
      await apiPublish(ch, {'seq': 3});

      // New subscription pinned to the recorded position.
      final newSub = client.newSubscription(
          ch,
          centrifuge.SubscriptionConfig(
              recoverable: true, since: positionAfterFirst));
      final newSubscribed =
          waitForEvent<centrifuge.SubscribedEvent>(newSub.subscribed);
      final recoveredPubs =
          collectEvents<centrifuge.PublicationEvent>(newSub.publication, 2);
      await newSub.subscribe();

      final newCtx = await newSubscribed;
      expect(newCtx.wasRecovering, true,
          reason: 'config.since should drive a recovering subscribe');
      expect(newCtx.recovered, true);

      final pubs = await recoveredPubs;
      expect(jsonDecode(utf8.decode(pubs[0].data)), {'seq': 2});
      expect(jsonDecode(utf8.decode(pubs[1].data)), {'seq': 3});

      await client.disconnect();
    });

    test('many missed publications recovered in order', () async {
      // Stress: publish a sizeable batch of messages while the client is
      // disconnected, then verify all are delivered in correct order on
      // reconnect — this guards against offset drift and re-ordering.
      final client = createClient();
      final ch = uniqueChannel('recovery');
      final sub = client.newSubscription(ch);

      // Listen up-front so the SubscribedEvent and recovered pubs are not
      // missed.
      final allPublications = <centrifuge.PublicationEvent>[];
      final pubSubscription = sub.publication.listen(allPublications.add);
      addTearDown(() => pubSubscription.cancel());

      await client.connect();
      await sub.subscribe();
      await apiPublish(ch, {'seq': 0});
      // Wait for live delivery of the priming pub.
      while (allPublications.length < 1) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }

      await client.disconnect();

      const total = 30;
      for (var i = 1; i <= total; i++) {
        await apiPublish(ch, {'seq': i});
      }

      await client.connect();

      final deadline = DateTime.now().add(const Duration(seconds: 10));
      while (allPublications.length < 1 + total &&
          DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      expect(allPublications.length, 1 + total,
          reason: 'expected priming pub + $total recovered pubs');
      // Validate ordering — every seq matches its index.
      for (var i = 0; i <= total; i++) {
        final got = jsonDecode(utf8.decode(allPublications[i].data));
        expect(got, {'seq': i},
            reason: 'pub at index $i out of order: $got');
      }

      await client.disconnect();
    });

    test('multiple subscriptions recover independent positions', () async {
      // Each channel keeps its own offset; reconnect must restore every
      // sub from where it left off, not from a shared cursor.
      final client = createClient();
      final channels = List.generate(3, (_) => uniqueChannel('recovery'));
      final subs = channels.map(client.newSubscription).toList();
      final pubLists = subs
          .map<List<centrifuge.PublicationEvent>>((_) => [])
          .toList(growable: false);
      final subscriptions = <StreamSubscription<centrifuge.PublicationEvent>>[];
      for (var i = 0; i < subs.length; i++) {
        subscriptions.add(subs[i].publication.listen(pubLists[i].add));
      }
      addTearDown(() async {
        for (final s in subscriptions) {
          await s.cancel();
        }
      });

      await client.connect();
      for (final s in subs) {
        await s.subscribe();
      }

      // Push a different number of priming pubs to each channel.
      const primingCounts = [1, 2, 3];
      for (var i = 0; i < channels.length; i++) {
        for (var j = 0; j < primingCounts[i]; j++) {
          await apiPublish(channels[i], {'ch': i, 'seq': j});
        }
      }
      // Wait for all priming pubs.
      final primingTotal = primingCounts.reduce((a, b) => a + b);
      final primingDeadline =
          DateTime.now().add(const Duration(seconds: 5));
      while (DateTime.now().isBefore(primingDeadline) &&
          pubLists.fold<int>(0, (acc, l) => acc + l.length) < primingTotal) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      expect(pubLists.map((l) => l.length).toList(), primingCounts);

      // Disconnect and publish a different fan-out per channel.
      await client.disconnect();
      const missedCounts = [4, 1, 2];
      for (var i = 0; i < channels.length; i++) {
        for (var j = 0; j < missedCounts[i]; j++) {
          await apiPublish(channels[i],
              {'ch': i, 'seq': primingCounts[i] + j});
        }
      }

      await client.connect();

      final expectedTotals = [
        for (var i = 0; i < channels.length; i++)
          primingCounts[i] + missedCounts[i]
      ];
      final deadline = DateTime.now().add(const Duration(seconds: 10));
      while (DateTime.now().isBefore(deadline) &&
          [for (var i = 0; i < subs.length; i++) pubLists[i].length] !=
              expectedTotals) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      expect([for (var i = 0; i < subs.length; i++) pubLists[i].length],
          expectedTotals);

      // Each per-channel list is monotonic in seq, indexed from 0.
      for (var i = 0; i < channels.length; i++) {
        for (var j = 0; j < pubLists[i].length; j++) {
          expect(jsonDecode(utf8.decode(pubLists[i][j].data)),
              {'ch': i, 'seq': j},
              reason: 'channel $i slot $j out of order');
        }
      }

      await client.disconnect();
    });

    test('subscription offset advances monotonically across reconnects',
        () async {
      // Walk through three connect/disconnect cycles and check that the
      // streamPosition.offset reported on each successful (re)subscribe
      // strictly increases as new publications land.
      final client = createClient();
      final ch = uniqueChannel('recovery');
      final sub = client.newSubscription(ch);
      final subscribedEvents = <centrifuge.SubscribedEvent>[];
      final subListener = sub.subscribed.listen(subscribedEvents.add);
      final pubs = <centrifuge.PublicationEvent>[];
      final pubListener = sub.publication.listen(pubs.add);
      addTearDown(() async {
        await subListener.cancel();
        await pubListener.cancel();
      });

      await client.connect();
      await sub.subscribe();

      var sentTotal = 0;
      Future<void> roundTrip(int batchSize) async {
        await client.disconnect();
        for (var i = 0; i < batchSize; i++) {
          await apiPublish(ch, {'idx': sentTotal + i});
        }
        sentTotal += batchSize;
        await client.connect();
        // Wait until all pubs are delivered.
        final deadline = DateTime.now().add(const Duration(seconds: 5));
        while (pubs.length < sentTotal && DateTime.now().isBefore(deadline)) {
          await Future<void>.delayed(const Duration(milliseconds: 20));
        }
      }

      await roundTrip(2);
      await roundTrip(3);
      await roundTrip(1);

      // 1 initial subscribed + 3 resubscribes = 4 events.
      expect(subscribedEvents.length, 4);
      // The first event has a baseline streamPosition; after each round-trip
      // the resubscribe's streamPosition.offset must be >= previous.
      var prev = subscribedEvents.first.streamPosition!.offset;
      for (final e in subscribedEvents.skip(1)) {
        final cur = e.streamPosition!.offset;
        expect(cur >= prev, true,
            reason: 'offset went backwards: $prev -> $cur');
        prev = cur;
      }
      // All publications were eventually delivered, in insertion order.
      expect(pubs.length, sentTotal);
      for (var i = 0; i < pubs.length; i++) {
        expect(jsonDecode(utf8.decode(pubs[i].data)), {'idx': i});
      }

      await client.disconnect();
    });

    test('empty recovery: reconnect with no missed pubs is a no-op',
        () async {
      // No missed publications: resubscribe should still report
      // wasRecovering=true and recovered=true (history is empty up to current
      // position) and live delivery must continue working.
      final client = createClient();
      final ch = uniqueChannel('recovery');
      final sub = client.newSubscription(ch);
      final subscribedEvents = <centrifuge.SubscribedEvent>[];
      final subListener = sub.subscribed.listen(subscribedEvents.add);
      addTearDown(() => subListener.cancel());

      await client.connect();
      await sub.subscribe();

      await client.disconnect();
      await client.connect();
      // Wait for second subscribed event.
      final deadline = DateTime.now().add(const Duration(seconds: 5));
      while (subscribedEvents.length < 2 && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      expect(subscribedEvents.length, 2);
      final resub = subscribedEvents[1];
      expect(resub.wasRecovering, true);
      expect(resub.recovered, true);

      // Live delivery still works.
      final livePub =
          waitForEvent<centrifuge.PublicationEvent>(sub.publication);
      await apiPublish(ch, {'live': 'after empty recovery'});
      final got = await livePub;
      expect(jsonDecode(utf8.decode(got.data)),
          {'live': 'after empty recovery'});

      await client.disconnect();
    });

    test('delta + server disconnect: missed publications still decoded',
        () async {
      // Combines fossil delta encoding and a server-initiated retryable
      // disconnect: the recovered publications must be applied against the
      // pre-disconnect prevData buffer correctly.
      final client = createClient();
      final ch = uniqueChannel('delta');
      final sub = client.newSubscription(
          ch, centrifuge.SubscriptionConfig(delta: centrifuge.DeltaType.fossil));

      final allPubs = <centrifuge.PublicationEvent>[];
      final pubListener = sub.publication.listen(allPubs.add);
      final subscribedEvents = <centrifuge.SubscribedEvent>[];
      final subListener = sub.subscribed.listen(subscribedEvents.add);
      addTearDown(() async {
        await pubListener.cancel();
        await subListener.cancel();
      });

      // Capture connection client id so we can target the kick.
      final connectedFuture = client.connected.first;
      await client.connect();
      final clientId = (await connectedFuture).client;
      await sub.subscribe();

      // Establish prevData with a baseline publication.
      const baseline =
          'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
      await apiPublish(ch, {'body': baseline});
      while (allPubs.length < 1) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      expect(jsonDecode(utf8.decode(allPubs[0].data)), {'body': baseline});

      // Kick via the server with a retryable code, then push two messages
      // that differ only by a small suffix — the server should encode them
      // as deltas against the previous publication.
      final connectingFuture =
          waitForEvent<centrifuge.ConnectingEvent>(client.connecting);
      await apiDisconnectClient(clientId, code: 3001);
      await connectingFuture.timeout(const Duration(seconds: 5));

      await apiPublish(ch, {'body': baseline + 'X'});
      await apiPublish(ch, {'body': baseline + 'XY'});

      // Wait for resubscribe + 2 recovered pubs.
      final deadline = DateTime.now().add(const Duration(seconds: 10));
      while ((subscribedEvents.length < 2 || allPubs.length < 3) &&
          DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      expect(subscribedEvents.length, 2);
      expect(subscribedEvents[1].recovered, true);
      expect(allPubs.length, 3);
      expect(jsonDecode(utf8.decode(allPubs[1].data)),
          {'body': baseline + 'X'});
      expect(jsonDecode(utf8.decode(allPubs[2].data)),
          {'body': baseline + 'XY'});

      await client.disconnect();
    });

    test('repeated server kicks: every missed pub recovered in order',
        () async {
      // Stress: 3 server-initiated retryable disconnects, with a publication
      // landing in each "down" window. Final publication list must contain
      // every message in order with no duplicates or losses.
      final client = createClient();
      final ch = uniqueChannel('recovery');
      final sub = client.newSubscription(ch);

      final pubs = <centrifuge.PublicationEvent>[];
      final pubListener = sub.publication.listen(pubs.add);
      addTearDown(() => pubListener.cancel());

      // Capture initial id; we re-capture after each reconnect.
      var clientId = '';
      final idListener = client.connected.listen((e) => clientId = e.client);
      addTearDown(() => idListener.cancel());

      await client.connect();
      await sub.subscribe();

      var seq = 0;
      Future<void> publish(int n) async {
        for (var i = 0; i < n; i++) {
          await apiPublish(ch, {'n': seq++});
        }
      }

      await publish(1); // priming — live
      // Allow the priming pub to arrive before kicking; otherwise it could
      // be racing with the disconnect frame.
      while (pubs.length < seq) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }

      const kicks = 3;
      for (var i = 0; i < kicks; i++) {
        final id = clientId;
        final connectingFuture =
            waitForEvent<centrifuge.ConnectingEvent>(client.connecting);
        await apiDisconnectClient(id, code: 3001);
        await connectingFuture.timeout(const Duration(seconds: 5));
        await publish(2); // 2 pubs while reconnecting
        // Wait until the client is connected again before the next kick.
        final deadline = DateTime.now().add(const Duration(seconds: 5));
        while (client.state != centrifuge.State.connected &&
            DateTime.now().isBefore(deadline)) {
          await Future<void>.delayed(const Duration(milliseconds: 20));
        }
        expect(client.state, centrifuge.State.connected);
      }

      // 1 priming + (3 kicks * 2 pubs) = 7 publications total.
      final deadline = DateTime.now().add(const Duration(seconds: 10));
      while (pubs.length < seq && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      expect(pubs.length, seq);
      for (var i = 0; i < pubs.length; i++) {
        expect(jsonDecode(utf8.decode(pubs[i].data)), {'n': i},
            reason: 'pub $i out of order: ${utf8.decode(pubs[i].data)}');
      }

      await client.disconnect();
    });
  });

  group('Server-initiated reconnection', () {
    // Centrifugo's default /api/disconnect uses terminal code 3503 ("force
    // disconnect"). To exercise auto-reconnect we send a code in the retryable
    // range; 3001 sits in the protocol-level retryable band [3000, 3500).
    const retryableCode = 3001;
    const terminalCode = 3501;

    /// Capture the client id from the (sync) connected stream before connect
    /// is awaited, so the test can target it via the server API even after
    /// connect() has resolved.
    Future<String> connectAndCaptureId(centrifuge.Client client) async {
      final completer = Completer<String>();
      late StreamSubscription<centrifuge.ConnectedEvent> sub;
      sub = client.connected.listen((e) {
        if (!completer.isCompleted) completer.complete(e.client);
        sub.cancel();
      });
      await client.connect();
      return completer.future.timeout(const Duration(seconds: 5));
    }

    test('retryable server disconnect: client reconnects with new id', () async {
      final client = createClient();
      // Listen to events BEFORE connect so we don't miss anything.
      final connectedEvents =
          collectEvents<centrifuge.ConnectedEvent>(client.connected, 2);
      final firstId = await connectAndCaptureId(client);

      await apiDisconnectClient(firstId,
          code: retryableCode, reason: 'retryable test');

      final ids =
          (await connectedEvents.timeout(const Duration(seconds: 10)))
              .map((e) => e.client)
              .toList();
      expect(ids[0], firstId);
      expect(ids[1], isNot(firstId), reason: 'reconnect should yield new id');
      expect(client.state, centrifuge.State.connected);

      await client.disconnect();
    });

    test('terminal server disconnect: client stays disconnected', () async {
      final client = createClient();
      final disconnectedFuture =
          waitForEvent<centrifuge.DisconnectedEvent>(client.disconnected);
      // Anything in [3500,4000) is terminal per the protocol code rule.
      final id = await connectAndCaptureId(client);
      await apiDisconnectClient(id,
          code: terminalCode, reason: 'terminal test');

      final disc = await disconnectedFuture;
      expect(disc.code, terminalCode);
      expect(client.state, centrifuge.State.disconnected);

      // Verify no reconnect attempt happens within a meaningful window. The
      // default minReconnectDelay is small, so 1.5s comfortably covers a stray
      // reconnect schedule.
      var sawConnecting = false;
      final probe = client.connecting.listen((_) => sawConnecting = true);
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      await probe.cancel();
      expect(sawConnecting, false);
      expect(client.state, centrifuge.State.disconnected);
    });

    test('subscriptions auto-resubscribe after retryable server disconnect',
        () async {
      final client = createClient();
      final ch = randomChannel('reconn');
      final sub = client.newSubscription(ch);

      final subStates =
          collectEvents<centrifuge.SubscribedEvent>(sub.subscribed, 2);

      final id = await connectAndCaptureId(client);
      await sub.subscribe();
      expect(sub.state, centrifuge.SubscriptionState.subscribed);

      await apiDisconnectClient(id, code: retryableCode);

      // Two SubscribedEvents: original + after auto-resubscribe.
      await subStates.timeout(const Duration(seconds: 10));
      expect(sub.state, centrifuge.SubscriptionState.subscribed);
      expect(client.state, centrifuge.State.connected);

      // Live publication still flows on the resubscribed sub.
      final livePub =
          waitForEvent<centrifuge.PublicationEvent>(sub.publication);
      await apiPublish(ch, {'msg': 'after-server-reconnect'});
      final pub = await livePub;
      expect(jsonDecode(utf8.decode(pub.data)),
          {'msg': 'after-server-reconnect'});

      await client.disconnect();
    });

    test('many subscriptions all resubscribe after server disconnect',
        () async {
      final client = createClient();
      final channels = List.generate(5, (_) => randomChannel('reconn'));

      // Capture per-sub second-Subscribed-event futures upfront. Each
      // subscription will fire once on initial subscribe and once on auto
      // resubscribe.
      final subs = <centrifuge.Subscription>[];
      final secondSubscribed = <Future<centrifuge.SubscribedEvent>>[];
      for (final ch in channels) {
        final s = client.newSubscription(ch);
        subs.add(s);
        secondSubscribed.add(collectEvents<centrifuge.SubscribedEvent>(
                s.subscribed, 2)
            .then((events) => events.last));
      }

      final id = await connectAndCaptureId(client);
      for (final s in subs) {
        await s.subscribe();
      }
      for (final s in subs) {
        expect(s.state, centrifuge.SubscriptionState.subscribed);
      }

      await apiDisconnectClient(id, code: retryableCode);

      await Future.wait(secondSubscribed)
          .timeout(const Duration(seconds: 10));
      for (final s in subs) {
        expect(s.state, centrifuge.SubscriptionState.subscribed,
            reason: 'sub ${s.channel} should be re-subscribed');
      }
      expect(client.state, centrifuge.State.connected);

      // Cross-check live delivery on each channel post-reconnect.
      for (var i = 0; i < channels.length; i++) {
        final pubFuture =
            waitForEvent<centrifuge.PublicationEvent>(subs[i].publication);
        await apiPublish(channels[i], {'idx': i});
        final got = await pubFuture;
        expect(jsonDecode(utf8.decode(got.data)), {'idx': i});
      }

      await client.disconnect();
    });

    test('repeated server disconnects: client remains stable', () async {
      // Stress test: many server-initiated retryable disconnects in a row
      // must leave the client+subscription in a healthy state without state
      // drift, leaked timers or stuck _inConnect.
      final client = createClient();
      final ch = randomChannel('reconn');
      final sub = client.newSubscription(ch);

      // 1 initial subscribe + 5 resubscribes = 6 SubscribedEvents.
      const cycles = 5;
      final allSubscribed =
          collectEvents<centrifuge.SubscribedEvent>(sub.subscribed, 1 + cycles);

      var id = await connectAndCaptureId(client);
      await sub.subscribe();

      for (var i = 0; i < cycles; i++) {
        // Capture next id before kicking, so we have a fresh target for the
        // following iteration.
        final nextId =
            collectEvents<centrifuge.ConnectedEvent>(client.connected, 1)
                .then((evts) => evts.first.client);
        await apiDisconnectClient(id, code: retryableCode);
        id = await nextId.timeout(const Duration(seconds: 10));
      }

      await allSubscribed.timeout(const Duration(seconds: 30));
      expect(sub.state, centrifuge.SubscriptionState.subscribed);
      expect(client.state, centrifuge.State.connected);

      // Sanity: a live publish is still delivered after all the churn.
      final livePub =
          waitForEvent<centrifuge.PublicationEvent>(sub.publication);
      await apiPublish(ch, {'final': true});
      final got = await livePub;
      expect(jsonDecode(utf8.decode(got.data)), {'final': true});

      await client.disconnect();
    });

    test('recovery delivers missed publications after server disconnect',
        () async {
      // Mirrors the existing client-initiated recovery test but uses a
      // server-initiated retryable disconnect, plus publications during the
      // reconnect window.
      final client = createClient();
      final ch = uniqueChannel('recovery');
      final sub = client.newSubscription(ch);

      // Listen up-front to capture every event the subscription emits
      // throughout its lifecycle. Sync broadcast streams deliver immediately,
      // so attaching here means no event is missed.
      final allSubscribedEvents = <centrifuge.SubscribedEvent>[];
      final subscribedSub =
          sub.subscribed.listen(allSubscribedEvents.add);
      final allPublications = <centrifuge.PublicationEvent>[];
      final pubSub = sub.publication.listen(allPublications.add);
      addTearDown(() async {
        await subscribedSub.cancel();
        await pubSub.cancel();
      });

      final id = await connectAndCaptureId(client);
      await sub.subscribe();

      await apiPublish(ch, {'seq': 1});
      // Wait until the live publication arrives.
      while (allPublications.length < 1) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }

      final connectingFuture =
          waitForEvent<centrifuge.ConnectingEvent>(client.connecting);

      await apiDisconnectClient(id, code: retryableCode);
      await connectingFuture.timeout(const Duration(seconds: 5));

      // Publish missed messages while the client is in connecting state.
      await apiPublish(ch, {'seq': 2});
      await apiPublish(ch, {'seq': 3});

      // Wait for the resubscribe (second SubscribedEvent) + the two recovered
      // publications. Poll because the events accumulate in lists.
      final deadline = DateTime.now().add(const Duration(seconds: 10));
      while (DateTime.now().isBefore(deadline) &&
          (allSubscribedEvents.length < 2 || allPublications.length < 3)) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
      expect(allSubscribedEvents.length, 2,
          reason: 'expected initial + resubscribe SubscribedEvent');
      final resubCtx = allSubscribedEvents[1];
      expect(resubCtx.recovered, true,
          reason: 'subscription should report recovered=true');
      expect(resubCtx.wasRecovering, true);

      expect(allPublications.length, 3,
          reason: 'expected initial seq=1 + recovered seq=2,3');
      expect(jsonDecode(utf8.decode(allPublications[1].data)), {'seq': 2});
      expect(jsonDecode(utf8.decode(allPublications[2].data)), {'seq': 3});

      await client.disconnect();
    });

    test('server-side per-channel unsubscribe: connection survives',
        () async {
      // Server forcibly unsubscribes one channel; the subscription must move
      // to unsubscribed, but the connection and any other subscriptions stay
      // intact.
      final client = createClient();
      final keepCh = randomChannel('reconn');
      final dropCh = randomChannel('reconn');
      final keepSub = client.newSubscription(keepCh);
      final dropSub = client.newSubscription(dropCh);

      final id = await connectAndCaptureId(client);
      await keepSub.subscribe();
      await dropSub.subscribe();

      final dropUnsub =
          waitForEvent<centrifuge.UnsubscribedEvent>(dropSub.unsubscribed);
      // /api/unsubscribe (no code) sends a terminal unsubscribe (code <2500),
      // which the client treats as moveToUnsubscribed.
      await apiUnsubscribeClient(id, dropCh);

      await dropUnsub.timeout(const Duration(seconds: 5));
      expect(dropSub.state, centrifuge.SubscriptionState.unsubscribed);
      expect(keepSub.state, centrifuge.SubscriptionState.subscribed);
      expect(client.state, centrifuge.State.connected);

      // Live publication still works on the surviving subscription.
      final livePub =
          waitForEvent<centrifuge.PublicationEvent>(keepSub.publication);
      await apiPublish(keepCh, {'still': 'alive'});
      final got = await livePub;
      expect(jsonDecode(utf8.decode(got.data)), {'still': 'alive'});

      await client.disconnect();
    });

    test('connect → server-disconnect → disconnect terminates cleanly',
        () async {
      // Pull on the state machine from both sides: the server initiates a
      // retryable disconnect, while the client (mid-reconnect) calls
      // disconnect(). The client must end up disconnected with no lingering
      // reconnect attempts.
      final client = createClient();
      final id = await connectAndCaptureId(client);

      final connectingFuture =
          waitForEvent<centrifuge.ConnectingEvent>(client.connecting);
      await apiDisconnectClient(id, code: retryableCode);
      // Wait until we see the connecting event triggered by the server kick,
      // which means we're in the reconnect window.
      await connectingFuture.timeout(const Duration(seconds: 5));
      expect(client.state, centrifuge.State.connecting);

      await client.disconnect();
      expect(client.state, centrifuge.State.disconnected);

      var sawConnecting = false;
      final probe = client.connecting.listen((_) => sawConnecting = true);
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      await probe.cancel();
      expect(sawConnecting, false,
          reason: 'no reconnect should be scheduled after disconnect()');
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

  group('Reconnect reliability', () {
    // connectAndCaptureId from the Server-initiated reconnection group is
    // duplicated here because groups have independent scopes.
    Future<String> connectAndCaptureId(centrifuge.Client client) async {
      final completer = Completer<String>();
      late StreamSubscription<centrifuge.ConnectedEvent> sub;
      sub = client.connected.listen((e) {
        if (!completer.isCompleted) completer.complete(e.client);
        sub.cancel();
      });
      await client.connect();
      return completer.future.timeout(const Duration(seconds: 5));
    }

    test(
        'unsubscribed event fires even when connection drops during cleanup send',
        () async {
      // Regression test for: when sendUnsubscribe() throws because the
      // transport closed mid-flight, moveToUnsubscribed must still emit
      // UnsubscribedEvent. Previously the early return for the reconnect path
      // skipped _addUnsubscribe, leaving the subscription silently dead.
      //
      // We race unsubscribe() against a server-initiated disconnect. In some
      // runs the sendUnsubscribe reply arrives first (normal path); in others
      // the connection drops before the reply (the previously broken path). In
      // both cases UnsubscribedEvent must fire with code 0 and the subscription
      // must stay unsubscribed after the client auto-reconnects.
      final client = createClient(centrifuge.ClientConfig(
        minReconnectDelay: const Duration(milliseconds: 50),
      ));
      final id = await connectAndCaptureId(client);

      final ch = randomChannel('unsub-race');
      final sub = client.newSubscription(ch);
      await sub.subscribe();

      final unsubFuture =
          waitForEvent<centrifuge.UnsubscribedEvent>(sub.unsubscribed);
      final reconnectedFuture =
          waitForEvent<centrifuge.ConnectedEvent>(client.connected);

      // Fire-and-forget unsubscribe then immediately drop the server
      // connection. This races the sendUnsubscribe reply against the
      // disconnect.
      // ignore: unawaited_futures
      sub.unsubscribe();
      await apiDisconnectClient(id, code: 3001);

      // UnsubscribedEvent must arrive regardless of which race path was taken.
      final ctx =
          await unsubFuture.timeout(const Duration(seconds: 5));
      expect(ctx.code, 0); // unsubscribedCodeUnsubscribeCalled
      expect(sub.state, centrifuge.SubscriptionState.unsubscribed);

      // Client must auto-reconnect (3001 is retryable).
      await reconnectedFuture.timeout(const Duration(seconds: 5));
      expect(client.state, centrifuge.State.connected);

      // Subscription must NOT be auto-resubscribed — the user explicitly
      // called unsubscribe(), so that intent must survive the reconnect.
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(sub.state, centrifuge.SubscriptionState.unsubscribed,
          reason: 'subscription must remain unsubscribed after reconnect');

      await client.disconnect();
    });

    test('zero minReconnectDelay does not crash on retryable disconnect',
        () async {
      // Regression test for backoffDelay() panicking with RangeError when
      // minReconnectDelay is Duration.zero: nextInt(0) is illegal. The guard
      // added to backoffDelay() must return Duration.zero instead of throwing.
      final client = centrifuge.createClient(
        url,
        centrifuge.ClientConfig(
          minReconnectDelay: Duration.zero,
          maxReconnectDelay: const Duration(milliseconds: 200),
        ),
      );
      final id = await connectAndCaptureId(client);

      final reconnected =
          waitForEvent<centrifuge.ConnectedEvent>(client.connected);

      // A retryable server disconnect triggers _scheduleReconnect →
      // backoffDelay(0, Duration.zero, ...). Without the fix this panics.
      await apiDisconnectClient(id, code: 3001);

      await reconnected.timeout(const Duration(seconds: 5));
      expect(client.state, centrifuge.State.connected);

      await client.disconnect();
    });
  });

  group('Stream getState', () {
    test('getState is called on initial subscribe and position is used for recovery',
        () async {
      final client = createClient();
      await client.connect();

      final ch = uniqueChannel('recovery');
      var getStateCalls = 0;

      // Publish 3 messages BEFORE subscribing.
      await apiPublish(ch, {'i': 1});
      await apiPublish(ch, {'i': 2});
      await apiPublish(ch, {'i': 3});

      // getState returns position 0 — recovery delivers all 3 publications.
      final sub = client.newSubscription(
          ch,
          centrifuge.SubscriptionConfig(getState: () async {
            getStateCalls++;
            return centrifuge.StreamPosition(Int64(0), '');
          }));

      final subscribedFuture =
          waitForEvent<centrifuge.SubscribedEvent>(sub.subscribed);
      final recoveredPubs =
          collectEvents<centrifuge.PublicationEvent>(sub.publication, 3);

      await sub.subscribe();

      await subscribedFuture;
      expect(getStateCalls, 1);

      final pubs = await recoveredPubs;
      expect(jsonDecode(utf8.decode(pubs[0].data)), {'i': 1});
      expect(jsonDecode(utf8.decode(pubs[1].data)), {'i': 2});
      expect(jsonDecode(utf8.decode(pubs[2].data)), {'i': 3});

      await client.disconnect();
    });

    test('getState is NOT called on reconnect when recovery succeeds',
        () async {
      final client = createClient();
      await client.connect();

      final ch = uniqueChannel('recovery');
      var getStateCalls = 0;

      final sub = client.newSubscription(
          ch,
          centrifuge.SubscriptionConfig(getState: () async {
            getStateCalls++;
            return centrifuge.StreamPosition(Int64(0), '');
          }));

      final subscribedFuture =
          waitForEvent<centrifuge.SubscribedEvent>(sub.subscribed);
      await sub.subscribe();
      await subscribedFuture;
      expect(getStateCalls, 1); // Called on initial subscribe.

      // Disconnect, publish while away, reconnect — SDK has a saved position
      // and recovery succeeds, so getState must NOT be called again.
      await client.disconnect();

      await apiPublish(ch, {'i': 1});
      await apiPublish(ch, {'i': 2});

      final resubFuture =
          waitForEvent<centrifuge.SubscribedEvent>(sub.subscribed);
      final recoveredPubs =
          collectEvents<centrifuge.PublicationEvent>(sub.publication, 2);

      await client.connect();

      final resubCtx = await resubFuture;
      expect(resubCtx.recovered, true);
      await recoveredPubs;

      expect(getStateCalls, 1,
          reason: 'getState must not be called when recovery succeeds');

      await client.disconnect();
    });

    test('getState error triggers resubscribe with error event', () async {
      final client = createClient();
      await client.connect();

      final ch = uniqueChannel('recovery');
      var getStateCalls = 0;

      final sub = client.newSubscription(
          ch,
          centrifuge.SubscriptionConfig(
              minResubscribeDelay: const Duration(milliseconds: 100),
              maxResubscribeDelay: const Duration(milliseconds: 100),
              getState: () async {
                getStateCalls++;
                if (getStateCalls == 1) {
                  throw Exception('simulated DB failure');
                }
                // Second call succeeds.
                return centrifuge.StreamPosition(Int64(0), '');
              }));

      final errors = <centrifuge.SubscriptionErrorEvent>[];
      final errSubscription = sub.error.listen(errors.add);
      addTearDown(() => errSubscription.cancel());

      final subscribedFuture =
          waitForEvent<centrifuge.SubscribedEvent>(sub.subscribed);

      await sub.subscribe();

      // First getState fails → error emitted → resubscribe scheduled with
      // backoff. Second getState succeeds → subscribe completes.
      await subscribedFuture;

      expect(getStateCalls, greaterThanOrEqualTo(2));
      expect(errors.length, greaterThanOrEqualTo(1));
      expect(errors[0].error, isA<centrifuge.SubscriptionGetStateError>());
      expect(errors[0].error.toString(), contains('simulated DB failure'));

      await client.disconnect();
    });

    test('getState persistent failure keeps retrying without unsubscribing',
        () async {
      final client = createClient();
      await client.connect();

      final ch = uniqueChannel('recovery');
      var getStateCalls = 0;

      final sub = client.newSubscription(
          ch,
          centrifuge.SubscriptionConfig(
              minResubscribeDelay: const Duration(milliseconds: 50),
              maxResubscribeDelay: const Duration(milliseconds: 50),
              getState: () async {
                getStateCalls++;
                throw Exception('always fails');
              }));

      await sub.subscribe();

      // Wait for several retry cycles.
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Should have retried multiple times while staying in subscribing state.
      expect(getStateCalls, greaterThan(2));
      expect(sub.state, centrifuge.SubscriptionState.subscribing);

      await sub.unsubscribe();
      await client.disconnect();
    });

    test('unsubscribe during getState await cancels the subscribe', () async {
      final client = createClient();
      await client.connect();

      final ch = uniqueChannel('recovery');
      var getStateCalls = 0;

      final sub = client.newSubscription(
          ch,
          centrifuge.SubscriptionConfig(getState: () async {
            getStateCalls++;
            await Future<void>.delayed(const Duration(milliseconds: 300));
            return centrifuge.StreamPosition(Int64(0), '');
          }));

      // ignore: unawaited_futures
      sub.subscribe().catchError((_) {});
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // getState is in flight now — cancel the subscription under it.
      await sub.unsubscribe();
      expect(sub.state, centrifuge.SubscriptionState.unsubscribed);

      // Let the pending getState resolve — it must not resurrect the
      // subscription or send a subscribe command.
      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(sub.state, centrifuge.SubscriptionState.unsubscribed);
      expect(getStateCalls, 1);

      await client.disconnect();
    });

    test('getState with real position recovers missed publications', () async {
      final client = createClient();
      await client.connect();

      final ch = uniqueChannel('recovery');

      // First, subscribe normally to get a valid epoch.
      final tempSub = client.newSubscription(ch);
      final tempSubscribed =
          waitForEvent<centrifuge.SubscribedEvent>(tempSub.subscribed);
      await tempSub.subscribe();
      final epoch = (await tempSubscribed).streamPosition?.epoch ?? '';
      await client.removeSubscription(tempSub);

      // Publish 2 messages.
      await apiPublish(ch, {'i': 1});
      await apiPublish(ch, {'i': 2});

      // Subscribe with getState returning the position BEFORE the 2 messages.
      final sub = client.newSubscription(
          ch,
          centrifuge.SubscriptionConfig(getState: () async {
            return centrifuge.StreamPosition(Int64(0), epoch);
          }));

      final recoveredPubs =
          collectEvents<centrifuge.PublicationEvent>(sub.publication, 2);
      await sub.subscribe();

      final pubs = await recoveredPubs;
      expect(jsonDecode(utf8.decode(pubs[0].data)), {'i': 1});
      expect(jsonDecode(utf8.decode(pubs[1].data)), {'i': 2});

      await client.disconnect();
    });

    test('getState is called again when recovery fails (unrecoverable position)',
        () async {
      // Uses "smallhistory" namespace with history_size=2. After publishing
      // enough to evict old entries, reconnecting from an old position
      // triggers error 112 (unrecoverable position) because the subscribe
      // request carries the reject_unrecovered flag. The SDK must then call
      // getState again to reload app state instead of delivering
      // recovered=false on an active subscription.
      final client = createClient();
      await client.connect();

      final ch = uniqueChannel('smallhistory');
      var getStateCalls = 0;

      // Simulate a real app: getState reads current stream position from
      // the backend.
      final sub = client.newSubscription(
          ch,
          centrifuge.SubscriptionConfig(
              minResubscribeDelay: const Duration(milliseconds: 100),
              maxResubscribeDelay: const Duration(milliseconds: 100),
              getState: () async {
                getStateCalls++;
                return apiHistory(ch);
              }));

      final subscribedFuture =
          waitForEvent<centrifuge.SubscribedEvent>(sub.subscribed);
      await sub.subscribe();
      await subscribedFuture;
      expect(getStateCalls, 1);

      // Disconnect, then publish enough messages to push the stream beyond
      // recovery (history_size=2, so 5 messages evict old entries).
      await client.disconnect();

      for (var i = 0; i < 5; i++) {
        await apiPublish(ch, {'i': i});
      }

      // Reconnect — SDK tries to recover from the old position, server
      // returns error 112, SDK resets position and calls getState again.
      final resubFuture =
          waitForEvent<centrifuge.SubscribedEvent>(sub.subscribed);

      await client.connect();

      await resubFuture;
      expect(getStateCalls, 2,
          reason: 'getState must be called again after unrecoverable position');

      // Verify live delivery works after the getState re-sync.
      final livePubFuture =
          waitForEvent<centrifuge.PublicationEvent>(sub.publication);
      await apiPublish(ch, {'live': true});
      final live = await livePubFuture;
      expect(jsonDecode(utf8.decode(live.data)), {'live': true});

      await client.disconnect();
    });
  });
}
