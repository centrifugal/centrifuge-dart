import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:centrifuge/src/proto/client.pb.dart' as protocol;
import 'package:test/test.dart';

import 'fake_server.dart';

// Publication filtering (server-side filtering by publication tags). The Filter
// builders construct a protocol FilterNode tree; the subscribe request carries
// it in the `tf` field. The feature requires Centrifugo PRO / namespace config,
// so wire-level behavior is exercised against the in-process FakeCentrifugoServer.

void main() {
  group('Filter builder', () {
    test('comparison leaf nodes', () {
      expect(centrifuge.Filter.eq('ticker', 'AAPL').proto,
          predicate<protocol.FilterNode>((n) => n.key == 'ticker' && n.cmp == 'eq' && n.val == 'AAPL'));
      expect(centrifuge.Filter.neq('source', 'TEST').proto,
          predicate<protocol.FilterNode>((n) => n.cmp == 'neq' && n.val == 'TEST'));
      expect(centrifuge.Filter.exists('price').proto,
          predicate<protocol.FilterNode>((n) => n.cmp == 'ex' && !n.hasVal()));
      expect(centrifuge.Filter.notExists('internal_id').proto,
          predicate<protocol.FilterNode>((n) => n.cmp == 'nex'));
      expect(centrifuge.Filter.startsWith('ticker', 'AA').proto,
          predicate<protocol.FilterNode>((n) => n.cmp == 'sw' && n.val == 'AA'));
      expect(centrifuge.Filter.endsWith('source', 'DAQ').proto,
          predicate<protocol.FilterNode>((n) => n.cmp == 'ew'));
      expect(centrifuge.Filter.contains('category', 'ec').proto,
          predicate<protocol.FilterNode>((n) => n.cmp == 'ct'));
      expect(centrifuge.Filter.gt('price', '100').proto,
          predicate<protocol.FilterNode>((n) => n.cmp == 'gt' && n.val == '100'));
      expect(centrifuge.Filter.gte('volume', '1000').proto,
          predicate<protocol.FilterNode>((n) => n.cmp == 'gte'));
      expect(centrifuge.Filter.lt('price', '200').proto,
          predicate<protocol.FilterNode>((n) => n.cmp == 'lt'));
      expect(centrifuge.Filter.lte('volume', '1000').proto,
          predicate<protocol.FilterNode>((n) => n.cmp == 'lte'));
    });

    test('set membership nodes carry vals', () {
      final inNode = centrifuge.Filter.inList('category', ['tech', 'finance']).proto;
      expect(inNode.cmp, 'in');
      expect(inNode.vals, ['tech', 'finance']);

      final ninNode = centrifuge.Filter.notInList('ticker', ['MSFT', 'GOOGL']).proto;
      expect(ninNode.cmp, 'nin');
      expect(ninNode.vals, ['MSFT', 'GOOGL']);
    });

    test('logical nodes nest children', () {
      final filter = centrifuge.Filter.and([
        centrifuge.Filter.eq('ticker', 'AAPL'),
        centrifuge.Filter.gte('price', '100'),
        centrifuge.Filter.inList('source', ['NASDAQ', 'NYSE']),
      ]).proto;
      expect(filter.op, 'and');
      expect(filter.nodes, hasLength(3));
      expect(filter.nodes[0].key, 'ticker');
      expect(filter.nodes[2].cmp, 'in');

      final orNode = centrifuge.Filter.or([
        centrifuge.Filter.eq('ticker', 'MSFT'),
        centrifuge.Filter.eq('category', 'tech'),
      ]).proto;
      expect(orNode.op, 'or');
      expect(orNode.nodes, hasLength(2));

      final notNode = centrifuge.Filter.not(centrifuge.Filter.eq('source', 'NYSE')).proto;
      expect(notNode.op, 'not');
      expect(notNode.nodes, hasLength(1));
      expect(notNode.nodes.first.cmp, 'eq');
    });

    test('delta and tagsFilter cannot be combined in config', () {
      expect(
        () => centrifuge.SubscriptionConfig(
          delta: centrifuge.DeltaType.fossil,
          tagsFilter: centrifuge.Filter.eq('ticker', 'AAPL'),
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('Tags filter wire', () {
    late FakeCentrifugoServer server;
    late centrifuge.Client client;

    setUp(() async {
      server = FakeCentrifugoServer();
      await server.start();
      client = centrifuge.createClient(server.url, centrifuge.ClientConfig());
    });

    tearDown(() async {
      await client.close();
      await server.stop();
    });

    test('subscribe request carries the tags filter', () async {
      await client.connect();
      final sub = client.newSubscription(
        'market:stocks',
        centrifuge.SubscriptionConfig(
          tagsFilter: centrifuge.Filter.and([
            centrifuge.Filter.eq('ticker', 'AAPL'),
            centrifuge.Filter.gte('price', '100'),
          ]),
        ),
      );
      await sub.subscribe();

      final tf = server.lastSubscribe!.tf;
      expect(tf.op, 'and');
      expect(tf.nodes, hasLength(2));
      expect(tf.nodes[0].key, 'ticker');
      expect(tf.nodes[0].cmp, 'eq');
      expect(tf.nodes[0].val, 'AAPL');
      expect(tf.nodes[1].cmp, 'gte');
    });

    test('setTagsFilter applies on next subscribe', () async {
      await client.connect();
      final sub = client.newSubscription('market:stocks', centrifuge.SubscriptionConfig());
      sub.setTagsFilter(centrifuge.Filter.eq('ticker', 'BTC'));
      await sub.subscribe();

      expect(server.lastSubscribe!.hasTf(), isTrue);
      expect(server.lastSubscribe!.tf.key, 'ticker');
      expect(server.lastSubscribe!.tf.val, 'BTC');
    });

    test('subscribe without filter sends no tf', () async {
      await client.connect();
      final sub = client.newSubscription('market:stocks', centrifuge.SubscriptionConfig());
      await sub.subscribe();
      expect(server.lastSubscribe!.hasTf(), isFalse);
    });

    test('setTagsFilter throws when subscription uses delta compression', () async {
      final sub = client.newSubscription(
        'market:stocks',
        centrifuge.SubscriptionConfig(delta: centrifuge.DeltaType.fossil),
      );
      expect(
        () => sub.setTagsFilter(centrifuge.Filter.eq('ticker', 'AAPL')),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
