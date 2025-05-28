import 'events.dart';

/// Enum for supported delta encoding algorithms.
enum DeltaType {
  none,
  fossil,
}

class SubscriptionConfig {
  SubscriptionConfig(
      {this.token = '',
      this.getToken,
      this.data,
      this.since,
      this.positioned = false,
      this.recoverable = false,
      this.joinLeave = false,
      this.minResubscribeDelay = const Duration(milliseconds: 500),
      this.maxResubscribeDelay = const Duration(milliseconds: 20000),
      this.delta = DeltaType.none});

  String token;
  final SubscriptionTokenCallback? getToken;
  List<int>? data;
  StreamPosition? since;
  final bool positioned;
  final bool recoverable;
  final bool joinLeave;
  final Duration minResubscribeDelay;
  final Duration maxResubscribeDelay;
  final DeltaType delta;
}

typedef SubscriptionTokenCallback = Future<String> Function(SubscriptionTokenEvent);
