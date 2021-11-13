import 'dart:async';

import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';

import 'conf.dart' as conf;
import 'state.dart' as state;

class _ChatPageState extends State<ChatPage> {
  final _msgs = <ChatMessage>[];
  late StreamSubscription<ChatMessage> _sub;

  @override
  void initState() {
    conf.cli.subscribe(conf.channel);
    _sub = conf.cli.messages.listen((msg) => setState(() => _msgs.add(msg)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashChat(
        messages: _msgs,
        user: ChatUser(name: state.username),
        onSend: (msg) async {
          await conf.cli.sendMsg(msg);
        },
        onLoadEarlier: () {
          print("loading...");
        },
      ),
    );
  }

  @override
  Future<void> dispose() async {
    await _sub.cancel();
    super.dispose();
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage();

  @override
  _ChatPageState createState() => _ChatPageState();
}
