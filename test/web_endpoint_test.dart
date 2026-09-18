@TestOn('browser')
library;

import 'dart:async';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:centrifuge/src/platform/js.dart' show endpointError;
import 'package:test/test.dart';

// Run with: dart test -p chrome test/web_endpoint_test.dart
// and: dart test -p chrome --compiler dart2wasm test/web_endpoint_test.dart
void main() {
  // Browsers resolve these to websocket URLs.
  final accepted = [
    'ws://localhost:1/connection/websocket',
    'http://localhost:1/connection/websocket',
    'https://localhost:1/connection/websocket',
    '//localhost:1/connection/websocket',
    '/connection/websocket',
    'connection/websocket',
    'ws:/localhost:1/connection/websocket',
    'WS://LOCALHOST:1/connection/websocket?cf_protocol=protobuf',
  ];
  // `new WebSocket()` throws for these on every attempt.
  final rejected = [
    'ftp://localhost/connection/websocket',
    'localhost:1/connection/websocket',
    'ws://localhost:1/connection/websocket#fragment',
    'ws://localhost:1/connection/websocket#',
    'ws://localhost:99999/connection/websocket',
    'ws://',
    'ws://[bad',
  ];

  test('endpointError agrees with the browser', () {
    for (final url in accepted) {
      expect(endpointError(url), isNull, reason: url);
    }
    for (final url in rejected) {
      expect(endpointError(url), isNotNull, reason: url);
    }
  });

  for (final endpoint in accepted) {
    test('connect() with $endpoint starts connecting', () async {
      final client = centrifuge.createClient(endpoint, centrifuge.ClientConfig());
      addTearDown(client.close);
      Object? thrown;
      unawaited(client.connect().catchError((Object error) => thrown = error));
      expect(client.state, centrifuge.State.connecting);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(thrown, isNull);
    });
  }

  for (final endpoint in rejected) {
    test('connect() with $endpoint throws and stays disconnected', () async {
      final client = centrifuge.createClient(endpoint, centrifuge.ClientConfig());
      addTearDown(client.close);
      await expectLater(client.connect(), throwsA(isA<centrifuge.ConfigurationError>()));
      expect(client.state, centrifuge.State.disconnected);
    });
  }
}
