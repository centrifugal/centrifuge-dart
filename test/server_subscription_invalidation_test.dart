import 'dart:async';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:centrifuge/src/proto/client.pb.dart' as protocol;
import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';

import 'fake_server.dart';

// Regression test: on disconnect code 3014 ("state invalidated"), the client
// resets each CLIENT-SIDE subscription's cached recovery position (offset 0,
// epoch "_") so the next resubscribe can't recover from now-invalid state.
// SERVER-SIDE subscriptions (pushed by the server via the Connect reply's
// `subs` field) must get the same treatment — otherwise the connect request
// keeps asking the server to recover from the stale pre-invalidation offset
// and epoch on every reconnect, defeating the point of state invalidation.
// Mirrors centrifugal/centrifuge-swift#135 and centrifugal/centrifuge-js#385.
//
// This uses the in-process FakeCentrifugoServer (rather than the docker-compose
// OSS server used by client_test.dart) so the test can inspect the raw Connect
// command the client sends on reconnect — including the offset/epoch it
// carries for the server-side sub — which isn't observable via the public API.

Future<T> _waitForEvent<T>(Stream<T> stream, {Duration timeout = const Duration(seconds: 5)}) {
  return stream.first.timeout(timeout);
}

void main() {
  group('Server-side subscription state invalidation', () {
    late FakeCentrifugoServer server;
    late centrifuge.Client client;

    setUp(() async {
      server = FakeCentrifugoServer();
      await server.start();
      server.connectResult = protocol.ConnectResult()
        ..client = 'fake-client'
        ..version = '0.0.0'
        ..ping = 25
        ..subs['news'] = (protocol.SubscribeResult()
          ..recoverable = true
          ..offset = Int64(42)
          ..epoch = 'epoch1');
      client = centrifuge.createClient(
        server.url,
        centrifuge.ClientConfig(minReconnectDelay: const Duration(milliseconds: 1)),
      );
    });

    tearDown(() async {
      await client.close();
      await server.stop();
    });

    test('3014 disconnect resets cached offset/epoch but keeps recoverable', () async {
      final firstSubscribed = _waitForEvent<centrifuge.ServerSubscribedEvent>(client.subscribed);
      await client.connect();
      final subscribedEvent = await firstSubscribed;
      expect(subscribedEvent.channel, 'news');
      expect(subscribedEvent.recoverable, isTrue);
      expect(subscribedEvent.streamPosition?.offset, Int64(42));
      expect(subscribedEvent.streamPosition?.epoch, 'epoch1');

      // Only one Connect so far, and it carries no subs (nothing cached yet
      // on the very first connect).
      final firstConnect = server.received.singleWhere((cmd) => cmd.hasConnect()).connect;
      expect(firstConnect.subs.containsKey('news'), isFalse);

      // Server-initiated disconnect with code 3014 forces an automatic
      // reconnect (3014 < 3500).
      final reconnected = _waitForEvent<centrifuge.ConnectedEvent>(client.connected);
      server.disconnect(3014, 'invalidated');
      await reconnected;

      // The reconnect's Connect command must carry the server-side sub's
      // recovery params reset to the sentinel — not the stale offset=42,
      // epoch='epoch1' cached from before invalidation.
      final connectCommands = server.received.where((cmd) => cmd.hasConnect()).toList();
      expect(connectCommands, hasLength(2),
          reason: 'expected exactly one reconnect after the 3014 kick');
      final secondConnect = connectCommands[1].connect;
      expect(secondConnect.subs.containsKey('news'), isTrue);
      final resent = secondConnect.subs['news']!;
      expect(resent.offset, Int64(0),
          reason: 'offset must be reset to the unrecoverable sentinel after state invalidation');
      expect(resent.epoch, '_',
          reason: 'epoch must be reset to the unrecoverable sentinel after state invalidation');
      expect(resent.recover, isTrue,
          reason: 'the recoverable flag itself must be left untouched');
    });
  });
}
