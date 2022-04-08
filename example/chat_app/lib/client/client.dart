import 'dart:async';
import 'dart:convert';

import 'package:centrifuge/centrifuge.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../conf.dart' as conf;
import '../state.dart' as state;

class ChatClient {
  late Client _client;

  StreamSubscription<ConnectEvent>? _connSub;
  StreamSubscription<DisconnectEvent>? _disconnSub;
  StreamSubscription<ErrorEvent>? _errorSub;

  late StreamSubscription<MessageEvent> _msgSub;

  late Subscription? subscription;
  final _chatMsgController = StreamController<ChatMessage>();

  Stream<ChatMessage> get messages => _chatMsgController.stream;

  void init(String token, String username, int userid) {
    const url = 'ws://${conf.serverAddr}/connection/websocket?format=protobuf';
    _client = createClient(url,
        ClientConfig(headers: <String, dynamic>{'user-id': userid, 'user-name': username}, token: token));
    _msgSub = _client.messageStream.listen((event) {
      print("Msg: $event");
    });
  }

  Future<void> connect(VoidCallback onConnect) async {
    print("Connecting to Centrifugo server at ${conf.serverAddr}");
    _connSub = _client.connectStream.listen((event) {
      print("Connected to server");
      Fluttertoast.showToast(
          msg: "Centrifugo server connected", backgroundColor: Colors.green, textColor: Colors.white);
      onConnect();
    });
    _disconnSub = _client.disconnectStream.listen((event) {
      print("Disconnected from server");
      Fluttertoast.showToast(
          msg: "Centrifugo server disconnected", backgroundColor: Colors.red, textColor: Colors.white);
    });
    _errorSub = _client.errorStream.listen((event) {
      print(event.error);
    });
    await _client.connect();
  }

  Future<void> subscribe(String channel) async {
    print("Subscribing to channel $channel");
    final subscription = _client.getSubscription(channel);
    subscription.publishStream.map<String>((e) => utf8.decode(e.data)).listen((data) {
      final d = json.decode(data) as Map<String, dynamic>;
      final username = d["username"].toString();
      final msg = d["message"].toString();
      _chatMsgController.sink.add(ChatMessage(
          text: msg,
          user: ChatUser(
              name: username,
              containerColor: username == state.username ? Colors.lightBlueAccent : Colors.grey[300],
              color: Colors.black87)));
    });
    subscription.joinStream.listen(print);
    subscription.leaveStream.listen(print);
    subscription.subscribeSuccessStream.listen(print);
    subscription.subscribeErrorStream.listen(print);
    subscription.unsubscribeStream.listen(print);
    this.subscription = subscription;
    await subscription.subscribe();
  }

  Future<void> dispose() async {
    await _connSub?.cancel();
    await _disconnSub?.cancel();
    await _msgSub.cancel();
    await _chatMsgController.close();
  }

  Future<void> sendMsg(ChatMessage msg) async {
    final output = jsonEncode({'message': msg.text, 'username': msg.user.name});
    print("Sending msg : $output");
    final data = utf8.encode(output);
    try {
      await subscription?.publish(data);
    } on Exception {
      rethrow;
    }
  }
}
