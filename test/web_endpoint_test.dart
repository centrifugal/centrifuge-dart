@TestOn('browser')
library;

import 'dart:async';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:test/test.dart';

// Run with: dart test -p chrome test/web_endpoint_test.dart
void main() {
  // Browsers resolve these to websocket URLs.
  for (final endpoint in [
    'http://localhost:1/connection/websocket',
    'https://localhost:1/connection/websocket',
    '//localhost:1/connection/websocket',
    '/connection/websocket',
  ]) {
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

  test('connect() with an endpoint a browser cannot open throws and stays disconnected', () async {
    final client = centrifuge.createClient('ftp://localhost/connection/websocket', centrifuge.ClientConfig());
    addTearDown(client.close);
    await expectLater(client.connect(), throwsA(isA<centrifuge.ConfigurationError>()));
    expect(client.state, centrifuge.State.disconnected);
  });
}
