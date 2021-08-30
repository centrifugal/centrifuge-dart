import 'package:flutter/material.dart';

import '../state.dart' as state;

class _LoginFormState extends State<LoginForm> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      const Padding(padding: EdgeInsets.only(top: 35.0)),
      const Text("Choose a username", textScaleFactor: 1.8),
      const Padding(padding: EdgeInsets.only(top: 35.0)),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        const Icon(Icons.person),
        const Padding(padding: EdgeInsets.only(right: 10.0)),
        SizedBox(
            width: 250.0,
            child: TextField(
              controller: _controller,
              autocorrect: false,
              autofocus: true,
              decoration: const InputDecoration.collapsed(hintText: 'Username'),
            )),
      ]),
      const Padding(padding: EdgeInsets.only(top: 35.0)),
      ElevatedButton(
        child: const Text("Login"),
        onPressed: () {
          state.username = _controller.text;
          widget.onLoggedIn();
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)))),
      )
    ]);
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({required this.onLoggedIn});

  final VoidCallback onLoggedIn;

  @override
  _LoginFormState createState() => _LoginFormState();
}
