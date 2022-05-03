import 'events.dart';

class SubscriptionConfig {
  SubscriptionConfig(
      {this.token,
      this.data,
      this.since,
      this.positioned = false,
      this.recoverable = false,
      this.minResubscribeDelay = const Duration(milliseconds: 500),
      this.maxResubscribeDelay = const Duration(milliseconds: 20000)});

  String? token;
  List<int>? data;
  StreamPosition? since;
  final bool positioned;
  final bool recoverable;
  final Duration minResubscribeDelay;
  final Duration maxResubscribeDelay;
}
