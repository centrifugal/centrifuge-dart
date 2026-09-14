import 'package:centrifuge/src/client.dart' show endpointError;
import 'package:test/test.dart';

void main() {
  group('Endpoints on the VM', () {
    test('ws:// and wss:// URLs are accepted', () {
      for (final url in [
        'ws://localhost:8000/connection/websocket',
        'wss://example.com/connection/websocket',
        'WS://LOCALHOST/connection/websocket',
        'ws://[::1]:8000/connection/websocket?cf_protocol=protobuf',
      ]) {
        expect(endpointError(url, web: false), isNull, reason: url);
      }
    });

    test('other URLs are rejected', () {
      for (final url in [
        'http://localhost:8000/connection/websocket',
        'https://example.com/connection/websocket',
        '//localhost:8000/connection/websocket',
        '/connection/websocket',
        'localhost:8000/connection/websocket',
        'ws://',
        'ws://[bad',
        '',
      ]) {
        expect(endpointError(url, web: false), isNotNull, reason: url);
      }
    });
  });

  group('Endpoints in browsers', () {
    test('websocket, http and relative URLs, which browsers resolve, are accepted', () {
      for (final url in [
        'ws://localhost:8000/connection/websocket',
        'wss://example.com/connection/websocket',
        'http://localhost:8000/connection/websocket',
        'https://example.com/connection/websocket',
        '//example.com/connection/websocket',
        '/connection/websocket',
        'connection/websocket',
      ]) {
        expect(endpointError(url, web: true), isNull, reason: url);
      }
    });

    test('other schemes and invalid URLs are rejected', () {
      for (final url in [
        'ftp://example.com/connection/websocket',
        'localhost:8000/connection/websocket',
        'ws://',
        'https://',
        'ws://[bad',
      ]) {
        expect(endpointError(url, web: true), isNotNull, reason: url);
      }
    });
  });
}
