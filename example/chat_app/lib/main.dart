import 'package:flutter/material.dart';

import 'chat.dart';
import 'login.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/chat': (BuildContext context) => const ChatPage(),
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Centrifuge Dart chat app',
      home: LoginPage(),
      routes: routes,
    );
  }
}
