import 'package:centrifuge/src/platform/vm.dart' show endpointError;
import 'package:test/test.dart';

// The browser rules are tested in web_endpoint_test.dart.
void main() {
  group('Endpoints on the VM', () {
    test('ws:// and wss:// URLs are accepted', () {
      for (final url in [
        'ws://localhost:8000/connection/websocket',
        'wss://example.com/connection/websocket',
        'WS://LOCALHOST/connection/websocket',
        'ws://[::1]:8000/connection/websocket?cf_protocol=protobuf',
      ]) {
        expect(endpointError(url), isNull, reason: url);
      }
    });

    test('other URLs are rejected', () {
      for (final url in [
        'http://localhost:8000/connection/websocket',
        'https://example.com/connection/websocket',
        '//localhost:8000/connection/websocket',
        '/connection/websocket',
        'localhost:8000/connection/websocket',
        'ws:/localhost:8000/connection/websocket',
        'ws://localhost:99999/connection/websocket',
        'ws://',
        'ws://[bad',
        '',
      ]) {
        expect(endpointError(url), isNotNull, reason: url);
      }
    });
  });
}
