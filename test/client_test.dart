import 'package:centrifuge/centrifuge.dart';
import 'package:test/test.dart';

import 'src/utils.dart';

void main() {
  final url = 'test_url';

  Client client;
  MockTransport transport;
  ClientConfig config;

  setUp(() {
    client = Client(url, config, ({url, headers}) => transport);
  });

  group('Subscription', () {
    test('getSubscription returns valid subscriptions', () {
      final s1 = client.getSubscription('some_channel');
      final s2 = client.getSubscription('some_channel');
      final s3 = client.getSubscription('some_another_channel');

      expect(s1, same(s2));
      expect(s1.channel, 'some_channel');

      expect(s3, isNot(same(s1)));
      expect(s3.channel, 'some_another_channel');
    });
  });
}
