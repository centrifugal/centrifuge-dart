import 'dart:async';

import 'package:centrifuge/src/universal_web_socket/web_socket_interface.dart';
import 'package:centrifuge/src/universal_web_socket/web_socket_io.dart'
    if (dart.library.html) 'package:centrifuge/src/universal_web_socket/web_socket_html.dart' as platform;
import 'package:meta/meta.dart';

@internal
abstract class UniversalWebSocket extends Stream<Object?> implements IWebSocket {
  @internal
  static Future<IWebSocket> connect(String url, {Map<String, Object?>? headers}) => platform.connect(url, headers: headers);

  @internal
  @protected
  UniversalWebSocket.internal();
}
