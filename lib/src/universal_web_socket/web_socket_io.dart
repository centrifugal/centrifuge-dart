import 'dart:async';
import 'dart:io' as io;

import 'package:centrifuge/src/universal_web_socket/web_socket_interface.dart';
import 'package:centrifuge/src/universal_web_socket/web_socket_universal.dart';
import 'package:meta/meta.dart';

@internal
Future<IWebSocket> connect(String url, {List<String>? protocols, Map<String, Object?>? headers}) async {
  final client = await io.WebSocket.connect(url, protocols: protocols, headers: headers);
  return WebSocketIO._(client);
}

@internal
class WebSocketIO extends UniversalWebSocket {
  final io.WebSocket _client;

  WebSocketIO._(io.WebSocket client)
      : _client = client,
        super.internal();

  @override
  StreamSubscription<Object?> listen(
    void Function(Object? event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      _client.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );

  @override
  Duration? get pingInterval => _client.pingInterval;

  @override
  void add(Object? data) {
    return _client.add(data);
  }

  @override
  Future<void> close() => _client.close();

  @override
  String? get closeReason => _client.closeReason;

  @override
  set pingInterval(Duration? duration) => _client.pingInterval = duration;
}
