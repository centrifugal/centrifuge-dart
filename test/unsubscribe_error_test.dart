import 'dart:async';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:centrifuge/src/proto/client.pb.dart' as protocol;
import 'package:test/test.dart';

import 'fake_server.dart';

// A failed cleanup Unsubscribe leaves the server-side subscription in place:
// the client reconnects to resync, as centrifuge-js does. That includes the
// cleanup of a subscribe still in flight, whose subscription the server may
// have created. A failure arriving after the connection it was sent on ended
// doesn't tear down the next connection.

void main() {
  late FakeCentrifugoServer server;
  late centrifuge.Client client;

  setUp(() async {
    server = FakeCentrifugoServer();
    await server.start();
    client = centrifuge.createClient(
      server.url,
      centrifuge.ClientConfig(
        minReconnectDelay: const Duration(milliseconds: 10),
        maxReconnectDelay: const Duration(milliseconds: 20),
      ),
    );
  });

  tearDown(() async {
    await client.close();
    await server.stop();
  });

  Future<List<centrifuge.ConnectingEvent>> connectingEvents() async {
    final events = <centrifuge.ConnectingEvent>[];
    final listener = client.connecting.listen(events.add);
    addTearDown(listener.cancel);
    return events;
  }

  test(
    'a failed cleanup unsubscribe of a subscribe in flight reconnects',
    () async {
      await client.connect();
      final connecting = await connectingEvents();
      // The subscribe reply never comes; the cleanup unsubscribe fails.
      server.holdReply = (cmd) => cmd.hasSubscribe();
      server.onCommand =
          (cmd) =>
              cmd.hasUnsubscribe()
                  ? (protocol.Reply()
                    ..id = cmd.id
                    ..error =
                        (protocol.Error()
                          ..code = 100
                          ..message = 'internal'
                          ..temporary = true))
                  : null;

      final sub = client.newSubscription('news');
      unawaited(sub.subscribe());
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(server.received.where((cmd) => cmd.hasSubscribe()), hasLength(1));
      await sub.unsubscribe();
      await Future<void>.delayed(const Duration(milliseconds: 200));

      expect(
        server.received.where((cmd) => cmd.hasUnsubscribe()),
        hasLength(1),
      );
      expect(
        connecting.map((e) => e.code),
        contains(4),
      ); // connectingCodeUnsubscribeError
      expect(client.state, centrifuge.State.connected);
    },
  );

  test(
    'a cleanup unsubscribe failing after its connection ended does not reconnect again',
    () async {
      await client.connect();
      final sub = client.newSubscription('news');
      await sub.subscribe();
      // The unsubscribe reply never comes: the connection closes first, which
      // fails the pending unsubscribe.
      server.holdReply = (cmd) => cmd.hasUnsubscribe();
      final connecting = await connectingEvents();
      unawaited(sub.unsubscribe());
      await Future<void>.delayed(const Duration(milliseconds: 50));
      server.holdReply = null;
      server.closeConnection();
      await Future<void>.delayed(const Duration(milliseconds: 300));

      expect(client.state, centrifuge.State.connected);
      expect(connecting.map((e) => e.code), [1]); // only the transport close
    },
  );
}
