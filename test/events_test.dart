import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:test/test.dart';

void main() {
  group('MessageEvent', () {
    test('toString is well-formed and includes the data', () {
      final event = centrifuge.MessageEvent('hello'.codeUnits);
      expect(event.toString(), 'MessageEvent{data: hello}');
    });
  });
}
