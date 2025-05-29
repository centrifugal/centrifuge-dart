import 'dart:io';
import 'dart:typed_data';

// WARNING: Internal test, do not rely on fossil.dart outside this scope.
import 'package:centrifuge/src/fossil.dart';
import 'package:test/test.dart';

Uint8List readBytes(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    throw Exception('Test data file not found: $path');
  }
  return file.readAsBytesSync();
}

void main() {
  group('Fossil Delta Integration Tests', () {
    // There are test cases in testdata/fossil/1 through 5
    for (var i = 1; i <= 5; i++) {
      test('Delta case #$i', () {
        final baseDir = 'test/testdata/fossil/$i';
        final originPath = '$baseDir/origin';
        final deltaPath = '$baseDir/delta';
        final targetPath = '$baseDir/target';

        final origin = readBytes(originPath);
        final delta = readBytes(deltaPath);
        final expected = readBytes(targetPath);

        // Apply the delta to the origin
        final result = applyDelta(origin, delta);

        // Verify the patched output matches expected target
        expect(result, expected,
            reason: 'Patched bytes do not match expected target for case #\$i');
      });
    }
  });
}
