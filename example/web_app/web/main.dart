import 'dart:html';

import 'package:centrifuge/centrifuge.dart';

void main() {
  querySelector('#output')?.text = 'Your Dart app is running.';

  void onEvent(dynamic event) {
    querySelector('#output')?.text = 'client> $event';
  }

  const url = 'ws://localhost:8000/connection/websocket';
  Client client = createClient(
    url,
    ClientConfig(
      headers: <String, dynamic>{'Authorization': 'example'},
    ),
  );

  // State changes.
  client.connecting.listen(onEvent);
  client.connected.listen(onEvent);
  client.disconnected.listen(onEvent);
  // Handle async errors.
  client.error.listen(onEvent);

  client.connect();
}
