import 'package:flutter/material.dart';

import 'connect.dart';
import 'widgets/login.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: LoginForm(
                onLoggedIn: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute<ConnectToServer>(
                        builder: (context) => const ConnectToServer())))));
  }
}
