import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';

import 'client.dart';
import 'subscription.dart';

class Centrifuge {
  final String url;
  Client _client;

  Centrifuge({@required this.url});

  Future connect() async {
    final socket = await WebSocket.connect(url);
    _client = Client(socket: socket);
    return _client.connect();
  }

  Future<void> disconnect() {
    if (_client == null) {
      return null;
    }

    final client = _client;
    _client = null;
    return client.disconnect();
  }

  Future publish(String channel, List<int> data) =>
      _client.publish(channel, data);

  Subscription subscribe(String channel) => _client.subscribe(channel);
}
