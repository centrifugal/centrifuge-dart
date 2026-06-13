import 'package:test/test.dart';

import 'client_test.dart' as client;
import 'compaction_test.dart' as compaction;
import 'fossil_test.dart' as fossil;

void main() {
  group('client', client.main);
  group('compaction', compaction.main);
  group('fossil', fossil.main);
}
