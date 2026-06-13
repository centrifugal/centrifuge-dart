import 'package:meta/meta.dart';

import 'proto/client.pb.dart' as protocol;

/// A node in a publication tags-filter expression tree, used for server-side
/// publication filtering. Build instances with the [Filter] helpers and pass
/// the result to [SubscriptionConfig.tagsFilter] or
/// [Subscription.setTagsFilter].
///
/// A filter is either a leaf node (a comparison such as `ticker == "AAPL"`) or
/// a logical node combining child nodes with `and` / `or` / `not`. The server
/// evaluates the filter against each publication's tags and delivers only
/// matching publications. See
/// https://centrifugal.dev/docs/server/publication_filtering for details.
///
/// Publication filtering must be enabled for the namespace on the server
/// (`allow_tags_filter`) and cannot be combined with delta compression.
@immutable
class FilterNode {
  const FilterNode._(this._node);

  final protocol.FilterNode _node;

  /// The underlying protocol message. Internal — not part of the public API.
  @internal
  protocol.FilterNode get proto => _node;
}

/// Builders for publication tags-filter expressions. Comparison helpers create
/// leaf nodes; [and], [or] and [not] combine them.
///
/// ```dart
/// // (ticker == "AAPL") AND (price >= "100") AND (source in ["NASDAQ", "NYSE"])
/// final filter = Filter.and([
///   Filter.eq('ticker', 'AAPL'),
///   Filter.gte('price', '100'),
///   Filter.inList('source', ['NASDAQ', 'NYSE']),
/// ]);
/// ```
abstract final class Filter {
  static FilterNode _leaf(String key, String cmp, {String? val, List<String>? vals}) {
    final node = protocol.FilterNode()
      ..key = key
      ..cmp = cmp;
    if (val != null) node.val = val;
    if (vals != null) node.vals.addAll(vals);
    return FilterNode._(node);
  }

  static FilterNode _logical(String op, List<FilterNode> nodes) {
    final node = protocol.FilterNode()..op = op;
    node.nodes.addAll(nodes.map((n) => n.proto));
    return FilterNode._(node);
  }

  /// Tag [key] equals [val].
  static FilterNode eq(String key, String val) => _leaf(key, 'eq', val: val);

  /// Tag [key] does not equal [val].
  static FilterNode neq(String key, String val) => _leaf(key, 'neq', val: val);

  /// Tag [key] is one of [vals].
  static FilterNode inList(String key, List<String> vals) => _leaf(key, 'in', vals: vals);

  /// Tag [key] is not one of [vals].
  static FilterNode notInList(String key, List<String> vals) => _leaf(key, 'nin', vals: vals);

  /// Tag [key] exists.
  static FilterNode exists(String key) => _leaf(key, 'ex');

  /// Tag [key] does not exist.
  static FilterNode notExists(String key) => _leaf(key, 'nex');

  /// Tag [key] (string) starts with [val].
  static FilterNode startsWith(String key, String val) => _leaf(key, 'sw', val: val);

  /// Tag [key] (string) ends with [val].
  static FilterNode endsWith(String key, String val) => _leaf(key, 'ew', val: val);

  /// Tag [key] (string) contains [val].
  static FilterNode contains(String key, String val) => _leaf(key, 'ct', val: val);

  /// Tag [key] (numeric) is greater than [val].
  static FilterNode gt(String key, String val) => _leaf(key, 'gt', val: val);

  /// Tag [key] (numeric) is greater than or equal to [val].
  static FilterNode gte(String key, String val) => _leaf(key, 'gte', val: val);

  /// Tag [key] (numeric) is less than [val].
  static FilterNode lt(String key, String val) => _leaf(key, 'lt', val: val);

  /// Tag [key] (numeric) is less than or equal to [val].
  static FilterNode lte(String key, String val) => _leaf(key, 'lte', val: val);

  /// All [nodes] must match.
  static FilterNode and(List<FilterNode> nodes) => _logical('and', nodes);

  /// At least one of [nodes] must match.
  static FilterNode or(List<FilterNode> nodes) => _logical('or', nodes);

  /// Inverts [node].
  static FilterNode not(FilterNode node) => _logical('not', [node]);
}
