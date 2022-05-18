import 'dart:async';

import 'package:centrifuge/centrifuge.dart';
import 'package:centrifuge/src/events.dart';

class ClientConfig {
  ClientConfig(
      {this.token,
      this.data,
      this.headers = const <String, dynamic>{},
      this.tlsSkipVerify = false,
      this.timeout = const Duration(seconds: 10),
      this.minReconnectDelay = const Duration(milliseconds: 500),
      this.maxReconnectDelay = const Duration(seconds: 20),
      this.maxServerPingDelay = const Duration(seconds: 10),
      this.getToken,
      this.name = "dart",
      this.version = ""});

  String? token;
  List<int>? data;

  final Duration timeout;
  final Map<String, dynamic> headers;
  final bool tlsSkipVerify;
  final Duration minReconnectDelay;
  final Duration maxReconnectDelay;
  final Duration maxServerPingDelay;
  final ConnectionTokenCallback? getToken;
  final String name;
  final String version;
}

typedef ConnectionTokenCallback = Future<String> Function(ConnectionTokenEvent);
