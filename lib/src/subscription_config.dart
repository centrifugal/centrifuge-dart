import 'events.dart';

class SubscriptionConfig {
  SubscriptionConfig(
      {this.token,
      this.data,
      this.since,
      this.tokenUniquePerConnection = false,
      this.minResubscribeDelay = const Duration(milliseconds: 500),
      this.maxResubscribeDelay = const Duration(milliseconds: 20000)});

  String? token;
  List<int>? data;
  StreamPosition? since;
  bool tokenUniquePerConnection;
  final Duration minResubscribeDelay;
  final Duration maxResubscribeDelay;
}