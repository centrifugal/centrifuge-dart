import 'package:test/test.dart';

import 'client_test.dart' as client;
import 'compaction_test.dart' as compaction;
import 'delta_test.dart' as delta;
import 'dictionary_test.dart' as dictionary;
import 'fossil_test.dart' as fossil;

void main() {
  group('client', client.main);
  group('compaction', compaction.main);
  group('delta', delta.main);
  group('dictionary', dictionary.main);
  group('fossil', fossil.main);
}
