import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:centrifuge/src/universal_web_socket/web_socket_interface.dart';
import 'package:centrifuge/src/universal_web_socket/web_socket_universal.dart';
import 'package:meta/meta.dart';

@internal
Future<IWebSocket> connect(String url, {List<String>? protocols, Map<String, Object?>? headers}) async {
  final client = html.WebSocket(
    url,
  );
  await client.onOpen.first;
  client.binaryType = 'arraybuffer';
  return WebSocketHtml._(client);
}

@internal
class WebSocketHtml extends UniversalWebSocket {
  final html.WebSocket _client;

  late final StreamSubscription<html.Event> _closeEventListener;
  html.CloseEvent? _closeEvent;

  WebSocketHtml._(html.WebSocket client)
      : _client = client,
        super.internal() {
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
      _client.onMessage.map<Object?>((event) {
        final dynamic data = event.data;
        if (data is ByteBuffer) {
          return data.asInt8List();
        } else {
          throw Exception('data is not ByteBuffer');
        }
      }).listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );

  @override
  Future<void> add(Object? data) async {
    Uint8List? uint8list;
    if (data is List<int>) {
      uint8list = Uint8List.fromList(data);
      _client.sendTypedData(uint8list);
    }
  }

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
