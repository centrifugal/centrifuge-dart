import 'dart:async';
import 'dart:math';

import 'package:centrifuge/centrifuge.dart';
import 'package:centrifuge/src/events.dart';

class ClientConfig {
  ClientConfig(
      {this.timeout = const Duration(seconds: 5),
      this.debug = false,
      this.headers = const <String, dynamic>{},
      this.tlsSkipVerify = false,
      this.maxReconnectDelay = const Duration(seconds: 20),
      this.privateChannelPrefix = "\$",
      this.pingInterval = const Duration(seconds: 25),
      this.onPrivateSub = _defaultPrivateSubCallback,
      WaitRetry? retry})
      : retry = retry ?? _defaultRetry(maxReconnectDelay.inSeconds);

  final Duration timeout;
  final bool debug;
  final Map<String, dynamic> headers;

  final bool tlsSkipVerify;

  final Duration maxReconnectDelay;
  final String privateChannelPrefix;
  final Duration pingInterval;
  final PrivateSubCallback onPrivateSub;
  final Future? Function(int) retry;
}

typedef WaitRetry = Future? Function(int);

typedef PrivateSubCallback = Future<String> Function(PrivateSubEvent);

WaitRetry _defaultRetry(int maxReconnectDelay) => (int count) {
      final seconds = min(0.5 * pow(2, count), maxReconnectDelay).toInt();
      return Future<void>.delayed(Duration(seconds: seconds));
    };

Future<String> _defaultPrivateSubCallback(PrivateSubEvent event) =>
    Future.value("");
