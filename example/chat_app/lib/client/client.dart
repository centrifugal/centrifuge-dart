// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:centrifuge/centrifuge.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../conf.dart' as conf;

class ChatClient {
  late Client _client;

  StreamSubscription<ConnectedEvent>? _connectedSub;
  StreamSubscription<ConnectingEvent>? _connectingSub;
  StreamSubscription<DisconnectedEvent>? _disconnSub;
  StreamSubscription<ErrorEvent>? _errorSub;

  late StreamSubscription<MessageEvent> _msgSub;

  late Subscription? subscription;
  final _chatMsgController = StreamController<ChatMessage>();

  Stream<ChatMessage> get messages => _chatMsgController.stream;

  void init(String token, String chatUserName, int chatUserId) {
    const url = 'ws://${conf.serverAddr}/connection/websocket?format=protobuf';
    _client = createClient(
      url,
      ClientConfig(
        token: conf.userJwtToken,
        headers: <String, String>{
          'user-id': chatUserId.toString(),
          'user-name': chatUserName,
        },
      ),
    );
    _msgSub = _client.message.listen((event) {
      print("Msg: $event");
    });
  }

  Future<void> connect(VoidCallback onConnect) async {
    print("Connecting to Centrifugo server at ${conf.serverAddr}");
    _connectedSub = _client.connected.listen((event) {
      print("Connected to server");
      Fluttertoast.showToast(
        msg: "Centrifugo server connected",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      onConnect();
    });
    _connectingSub = _client.connecting.listen((event) {
      print("Connecting to server");
      Fluttertoast.showToast(
        msg: "Connecting to Centrifugo server",
        backgroundColor: Colors.green[900],
        textColor: Colors.white,
      );
    });
    _disconnSub = _client.disconnected.listen((event) {
      print("Disconnected from server");
      Fluttertoast.showToast(
        msg: "Centrifugo server disconnected",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    });
    _errorSub = _client.error.listen((event) {
      print(event.error);
    });
    await _client.connect();
  }

  Future<void> subscribe(String channel) async {
    print("Subscribing to channel $channel");
    final subscription = _client.getSubscription(channel) ??
        _client.newSubscription(
          channel,
          SubscriptionConfig(
            token: conf.subscriptionJwtToken,
          ),
        );
    subscription.publication.map<String>((e) => utf8.decode(e.data)).listen((data) {
      final d = json.decode(data) as Map<String, dynamic>;
      final username = d["username"].toString();
      final msg = d["message"].toString();
      _chatMsgController.sink.add(
        ChatMessage(
          text: msg,
          user: ChatUser(
            name: username,
            containerColor: username == conf.userName ? Colors.lightBlueAccent : Colors.grey[300],
            color: Colors.black87,
          ),
        ),
      );
    });
    subscription.join.listen(print);
    subscription.leave.listen(print);
    subscription.subscribed.listen(print);
    subscription.subscribing.listen(print);
    subscription.error.listen(print);
    subscription.unsubscribed.listen(print);
    this.subscription = subscription;
    await subscription.subscribe();
  }

  Future<void> dispose() async {
    await _connectingSub?.cancel();
    await _connectedSub?.cancel();
    await _disconnSub?.cancel();
    await _errorSub?.cancel();
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
