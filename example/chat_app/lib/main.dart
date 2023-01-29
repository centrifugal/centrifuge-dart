import 'package:flutter/material.dart';

import 'chat.dart';
import 'login.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/chat': (BuildContext context) => const ChatPage(),
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Centrifuge Dart chat app',
      home: const LoginPage(),
      routes: routes,
    );
  }
}
