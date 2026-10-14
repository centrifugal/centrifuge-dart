import 'dart:async';
import 'dart:convert';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:centrifuge/src/proto/client.pb.dart' as protocol;
import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';

import 'fake_server.dart';

// A publication that can't be decoded is a protocol error: the client stops
// with badProtocol and doesn't reconnect, as centrifuge-js does.

void main() {
  late FakeCentrifugoServer server;
  late centrifuge.Client client;
  late List<Object> uncaught;

  setUp(() async {
    server = FakeCentrifugoServer();
    await server.start();
    uncaught = [];
  });

  tearDown(() async {
    await client.close();
    await server.stop();
  });

  Future<void> guarded(Future<void> Function() body) {
    final done = Completer<void>();
    runZonedGuarded(() async {
      await body();
      done.complete();
    }, (error, _) => uncaught.add(error));
    return done.future;
  }

  protocol.Publication pub(int offset, String data, {bool delta = false}) => protocol.Publication()
    ..offset = Int64(offset)
    ..data = utf8.encode(data)
    ..delta = delta;

  test('a recovered publication that fails to decode stops the client', () async {
    final received = <String>[];
    server.onSubscribe = (ch, req) => protocol.SubscribeResult()
      ..delta = true
      ..recoverable = true
      ..epoch = 'e'
      ..offset = Int64(3)
      ..publications.addAll([
        pub(1, 'hello'),
        pub(2, '5\n5@0,bad;', delta: true),
        pub(3, 'world'),
      ]);
    await guarded(() async {
      client = centrifuge.createClient(server.url, centrifuge.ClientConfig());
      final sub = client.newSubscription('ch', centrifuge.SubscriptionConfig(delta: centrifuge.DeltaType.fossil));
      sub.publication.listen((e) => received.add(utf8.decode(e.data)));
      final disconnected = client.disconnected.first.timeout(const Duration(seconds: 3));
      await client.connect();
      await sub.subscribe();
      final event = await disconnected;
      expect(event.code, 2);
    });
    expect(received, ['hello']);
    expect(uncaught, hasLength(1));
  });

  test('a delta publication without a base stops the client', () async {
    final received = <String>[];
    server.onSubscribe = (ch, req) => protocol.SubscribeResult()..delta = true;
    await guarded(() async {
      client = centrifuge.createClient(server.url, centrifuge.ClientConfig());
      final sub = client.newSubscription('ch', centrifuge.SubscriptionConfig(delta: centrifuge.DeltaType.fossil));
      sub.publication.listen((e) => received.add(utf8.decode(e.data)));
      final disconnected = client.disconnected.first.timeout(const Duration(seconds: 3));
      await client.connect();
      await sub.subscribe();
      server.sendPush(protocol.Push()
        ..channel = 'ch'
        ..pub = pub(1, '4\n4:test2Bm6Re;', delta: true));
      final event = await disconnected;
      expect(event.code, 2);
    });
    expect(received, isEmpty);
    expect(uncaught, hasLength(1));
  });
}
