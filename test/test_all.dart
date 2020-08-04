import 'package:test/test.dart';

import 'client_test.dart' as client;
import 'subscription_test.dart' as subscription;
import 'transport_test.dart' as transport;

void main() {
  group('client', client.main);
  group('subscription', subscription.main);
  group('transport', transport.main);
}
