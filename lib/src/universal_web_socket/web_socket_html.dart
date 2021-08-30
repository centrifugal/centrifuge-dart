import 'dart:async';
import 'dart:html' as html;

import 'package:centrifuge/src/universal_web_socket/web_socket_interface.dart';
import 'package:centrifuge/src/universal_web_socket/web_socket_universal.dart';
import 'package:meta/meta.dart';

@internal
Future<IWebSocket> connect(String url, {Map<String, Object?>? headers}) async {
  // print('URL: $url, HEADERS: $headers');
  // try {
  //   await html.HttpRequest.request(
  //     url,
  //     requestHeaders: headers?.map(
  //           (key, value) =>
  //           MapEntry(
  //             key,
  //             value.toString(),
  //           ),
  //     ),
  //   );
  // }
  // on Object catch(e){
  //   print('1 - $e');
  // }
  try {
    final client = html.WebSocket(
      url,
    );
    return WebSocketHtml._(client);
  }
  on Object catch(e){
    print('2 - $e');
    rethrow;
  }
}

@internal
class WebSocketHtml extends UniversalWebSocket {
  final html.WebSocket _client;

  late final StreamSubscription<html.Event> _closeEventListener;
  html.CloseEvent? _closeEvent;

  WebSocketHtml._(html.WebSocket client)
      : _client = client,
        super.internal() {
    /// прослушиваем все CloseEvent и усстанавливаем их в локальную переменную
    /// для того, чтобы у нас всегда была возможность синхронно иметь доступ к _closeEvent
    _closeEventListener = _client.on['CloseEvent'].where((event) => event is html.CloseEvent).listen((event) {
      if (event is html.CloseEvent) {
        _closeEvent = event;
      }
    });
  }

  @override
  StreamSubscription<Object?> listen(
    void Function(Object? event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      _client.onMessage.map<Object?>((event) => event.data).listen(
            onData,
            onError: onError,
            onDone: onDone,
            cancelOnError: cancelOnError,
          );

  @override
  void add(Object? data) => _client.send(data);

  @override
  Future<void> close() async {
    _client.close();
    await _closeEventListener.cancel();
  }

  @override
  String? get closeReason => _closeEvent?.reason;

  @override
  Duration? get pingInterval => Duration.zero;

  @override
  set pingInterval(Duration? duration) => Duration.zero;
}
