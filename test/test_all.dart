import 'package:test/test.dart';

import 'client_test.dart' as client;
import 'fossil_test.dart' as fossil;

void main() {
  group('client', client.main);
  group('fossil', fossil.main);
}
