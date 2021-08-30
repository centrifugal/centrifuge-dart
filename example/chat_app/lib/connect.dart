import 'dart:math';

import 'package:flutter/material.dart';

import 'conf.dart' as conf;
import 'state.dart' as state;

class _ConnectToServerState extends State<ConnectToServer> {
  _ConnectToServerState();

  @override
  void initState() {
    conf.cli
      ..init(conf.token.toString(), state.username, Random().nextInt(100))
      ..connect(() => Navigator.of(context).pushReplacementNamed("/chat"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const CircularProgressIndicator(),
                  const Padding(padding: EdgeInsets.only(top: 15.0)),
                  const Text("Connecting to server ...")
                ])));
  }
}

class ConnectToServer extends StatefulWidget {
  const ConnectToServer();

  @override
  _ConnectToServerState createState() => _ConnectToServerState();
}
