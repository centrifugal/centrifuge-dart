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
      this.delta = DeltaType.none,
      this.getState});

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

  /// Called to load the app's current state and stream position.
  /// Requires Centrifugo >= 6.8.0.
  ///
  /// The SDK calls this:
  /// - On initial subscribe (no saved position)
  /// - On reconnect when recovery fails (server returns error 112 —
  ///   unrecoverable position)
  ///
  /// NOT called on reconnects where the server successfully recovers missed
  /// publications — in that case the recovered publications arrive as events
  /// and getState is skipped.
  ///
  /// The app should load its data from its own source of truth (database,
  /// API), render it, and return the stream position. The SDK subscribes with
  /// recovery from the returned position, so any publications between the
  /// state read and the subscribe are delivered as publication events.
  ///
  /// IMPORTANT: inside getState, read the stream position FIRST, then read
  /// your data. This ensures the position is a lower bound — any data loaded
  /// after the position read is guaranteed to be included. The reverse order
  /// can produce gaps.
  ///
  /// Recovered publications may overlap with data already loaded in getState.
  /// This works correctly when updates are idempotent (applying the same
  /// update twice produces the same result). For non-idempotent updates,
  /// deduplicate by publication offset.
  ///
  /// On error, the SDK emits an error event with [SubscriptionGetStateError]
  /// and retries with backoff.
  final SubscriptionGetStateCallback? getState;
}

typedef SubscriptionTokenCallback = Future<String> Function(SubscriptionTokenEvent);
typedef SubscriptionGetStateCallback = Future<StreamPosition> Function();
