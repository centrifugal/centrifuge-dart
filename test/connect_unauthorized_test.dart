import 'dart:async';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:test/test.dart';

import 'fake_server.dart';

void main() {
  group('Connection getToken throwing UnauthorizedException', () {
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

    test('connect() called from the disconnected listener starts a new attempt', () async {
      var getTokenCalls = 0;
      client = centrifuge.createClient(
        server.url,
        centrifuge.ClientConfig(getToken: (event) async {
          getTokenCalls++;
          if (getTokenCalls == 1) {
            throw centrifuge.UnauthorizedException();
          }
          return 'token';
        }),
      );

      final disconnects = <centrifuge.DisconnectedEvent>[];
      final disconnectedSubscription = client.disconnected.listen((event) {
        disconnects.add(event);
        if (disconnects.length == 1) {
          // e.g. the app re-authenticated the user and retries right away.
          client.connect();
        }
      });
      addTearDown(() => disconnectedSubscription.cancel());

      final connected = client.connected.first;
      await client.connect();

      await connected.timeout(const Duration(seconds: 5));
      expect(client.state, centrifuge.State.connected);
      expect(getTokenCalls, 2);
      expect(disconnects, hasLength(1));
      expect(disconnects.single.code, 1); // disconnectedCodeUnauthorized
    });
  });
}
