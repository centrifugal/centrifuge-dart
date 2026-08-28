import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:test/test.dart';

void main() {
  group('UnauthorizedException', () {
    test('toString includes the custom message', () {
      final ex = centrifuge.UnauthorizedException('refresh token expired');
      expect(ex.toString(), contains('refresh token expired'));
    });

    test('toString includes the default message', () {
      final ex = centrifuge.UnauthorizedException();
      expect(ex.toString(), contains('unauthorized'));
    });
  });
}
