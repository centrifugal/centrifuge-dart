import 'dart:async';
import 'dart:math';

class ClientConfig {
  ClientConfig(
      {this.timeout = const Duration(seconds: 5),
      this.debug = false,
      this.headers = const <String, dynamic>{},
      this.tlsSkipVerify = false,
      this.maxReconnectDelay = const Duration(seconds: 20),
      this.privateChannelPrefix = "\$",
      this.pingInterval = const Duration(seconds: 25),
      WaitRetry retry})
      : retry = retry ?? _defaultRetry(maxReconnectDelay.inSeconds);

  final Duration timeout;
  final bool debug;
  final Map<String, dynamic> headers;

  final bool tlsSkipVerify;

  final Duration maxReconnectDelay;
  final String privateChannelPrefix;
  final Duration pingInterval;
  final Future Function(int) retry;
}

typedef WaitRetry = Future Function(int);

WaitRetry _defaultRetry(int maxReconnectDelay) => (int count) {
      return Future<void>.delayed(
          Duration(seconds: max(2 * pow(2, count), maxReconnectDelay)));
    };
