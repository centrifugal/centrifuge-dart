import 'dart:async';

import 'package:centrifuge/centrifuge.dart';
import 'package:centrifuge/src/events.dart';

/// Contains the client configuration
class ClientConfig {
  /// Creates a new client configuration.
  ///
  /// Note that headers are only used on platforms that support dart:io,
  /// so on web the headers will be ignored.
  ClientConfig({
    this.token = '',
    this.getToken,
    this.data,
    this.headers = const <String, dynamic>{},
    this.tlsSkipVerify = false,
    this.timeout = const Duration(seconds: 10),
    this.minReconnectDelay = const Duration(milliseconds: 500),
    this.maxReconnectDelay = const Duration(seconds: 20),
    this.maxServerPingDelay = const Duration(seconds: 10),
    this.name = 'dart',
    this.version = '',
  });

  /// The initial token used for authentication
  String token;

  /// Callback to get/refresh tokens
  final ConnectionTokenCallback? getToken;

  /// The data send for the first request
  List<int>? data;

  /// The connection timeout
  final Duration timeout;

  /// Headers that are set when connecting the web socket on dart:io platforms.
  ///
  /// Note that headers are ignored on the web platform.
  final Map<String, dynamic> headers;

  final bool tlsSkipVerify;
  final Duration minReconnectDelay;
  final Duration maxReconnectDelay;
  final Duration maxServerPingDelay;

  /// The user's name
  final String name;

  /// The current version
  final String version;
}

typedef ConnectionTokenCallback = Future<String> Function(ConnectionTokenEvent);
