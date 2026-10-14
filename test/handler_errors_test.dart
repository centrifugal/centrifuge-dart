import 'dart:async';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:centrifuge/src/proto/client.pb.dart' as protocol;
import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';

import 'fake_server.dart';

// An exception escaping an event listener is reported to the listener's zone,
// and the client stops: it disconnects with badProtocol and doesn't reconnect,
// as centrifuge-js does. The SDK's own work completes as if the listener had
// returned, and a publication whose listener threw isn't delivered.

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

  // Runs body in a zone that collects the errors the listeners throw.
  Future<void> guarded(Future<void> Function() body) {
    final done = Completer<void>();
    runZonedGuarded(() async {
      await body();
      done.complete();
    }, (error, _) => uncaught.add(error));
    return done.future;
  }

  Future<centrifuge.DisconnectedEvent> nextDisconnected() =>
      client.disconnected.first.timeout(const Duration(seconds: 3));

  test('a connecting listener throwing inside connect() stops the client', () async {
    final events = <String>[];
    await guarded(() async {
      client = centrifuge.createClient(server.url, centrifuge.ClientConfig());
      var calls = 0;
      client.connecting.listen((_) {
        if (++calls == 1) throw StateError('listener bug');
      });
      client.connecting.listen((_) => events.add('second listener'));
      final disconnected = nextDisconnected();
      unawaited(client.connect().catchError((_) {}));
      final event = await disconnected;
      expect(event.code, 2);
      expect(event.reason, startsWith('exception in event handler'));
    });
    expect(uncaught, hasLength(1));
    // The listener after the failing one doesn't get the outdated event.
    expect(events, isEmpty);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(client.state, centrifuge.State.disconnected);
    expect(server.received.where((cmd) => cmd.hasConnect()), isEmpty);

    await client.connect();
    expect(client.state, centrifuge.State.connected);
  });

  test('a subscribing listener throwing inside subscribe() stops the client', () async {
    client = centrifuge.createClient(server.url, centrifuge.ClientConfig());
    late centrifuge.Subscription sub;
    await guarded(() async {
      await client.connect();
      sub = client.newSubscription('news');
      var calls = 0;
      sub.subscribing.listen((_) {
        if (++calls == 1) throw StateError('listener bug');
      });
      final disconnected = nextDisconnected();
      unawaited(sub.subscribe().catchError((_) {}));
      expect((await disconnected).code, 2);
    });
    expect(uncaught, hasLength(1));
    // The subscribe completed as far as it could: it waits for the connection.
    expect(sub.state, centrifuge.SubscriptionState.subscribing);
    await client.connect();
    await sub.ready().timeout(const Duration(seconds: 3));
  });

  test('a publication whose listener threw is recovered again', () async {
    server.onSubscribe =
        (channel, req) =>
            protocol.SubscribeResult()
              ..recoverable = true
              ..epoch = 'e'
              ..offset = req.recover ? req.offset : Int64(0)
              ..wasRecovering = req.recover
              ..recovered = req.recover;
    client = centrifuge.createClient(server.url, centrifuge.ClientConfig());
    late centrifuge.Subscription sub;
    await guarded(() async {
      await client.connect();
      sub = client.newSubscription('news', centrifuge.SubscriptionConfig(recoverable: true));
      var calls = 0;
      sub.publication.listen((_) {
        if (++calls == 1) throw StateError('listener bug');
      });
      await sub.subscribe();
      final disconnected = nextDisconnected();
      server.sendPush(
        protocol.Push()
          ..channel = 'news'
          ..pub =
              (protocol.Publication()
                ..data = [123, 125]
                ..offset = Int64(1)),
      );
      expect((await disconnected).code, 2);
    });
    expect(uncaught, hasLength(1));

    await client.connect();
    await sub.ready().timeout(const Duration(seconds: 3));
    final last = server.lastSubscribe!;
    expect(last.recover, isTrue);
    expect(last.offset, Int64(0));
  });
}
