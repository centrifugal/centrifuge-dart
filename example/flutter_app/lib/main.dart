import 'dart:async';
import 'dart:convert';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Centrifuge Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Centrifuge Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late centrifuge.Client _centrifuge;
  late centrifuge.Subscription _subscription;
  late ScrollController _controller;

  final _items = <_ChatItem>[];

  @override
  void initState() {
    final url = 'ws://localhost:8000/connection/websocket?format=protobuf';
    _centrifuge = centrifuge.createClient(url);

    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() async {
    await _centrifuge.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<Function>(
            onSelected: (f) => f(),
            itemBuilder: (context) => <PopupMenuItem<Function>>[
              PopupMenuItem(
                value: () => _connect(),
                child: Text('Connect'),
              ),
              PopupMenuItem(
                value: () => _subscribe(),
                child: Text('Subscribe'),
              ),
            ],
          )
        ],
      ),
      body: ListView.builder(
          itemCount: _items.length,
          controller: _controller,
          itemBuilder: (context, index) {
            final item = _items[index];
            return ListTile(
              title: Text(item.title),
              subtitle: Text(item.subtitle),
            );
          }),
    );
  }

  void _connect() async {
    try {
      await _centrifuge.connect();
    } catch (exception) {
      _show(exception);
    }
  }

  void _subscribe() async {
    final channel = 'chat:index';
    _subscription = _centrifuge.newSubscription(channel);

    _subscription.subscribing.listen(_show);
    _subscription.subscribed.listen(_show);
    _subscription.unsubscribed.listen(_show);

    final onNewItem = (_ChatItem item) {
      setState(() {
        _items.add(item);
      });
      Future.delayed(Duration(milliseconds: 125), () => _controller.jumpTo(64.0 + _controller.offset));
    };

    _subscription.join.listen((event) {
      final user = event.user;
      final client = event.client;

      final item = _ChatItem(title: 'User $user joined channel $channel', subtitle: '(client ID $client)');
      onNewItem(item);
    });

    _subscription.leave.listen((event) {
      final user = event.user;
      final client = event.client;
      final item = _ChatItem(title: 'User $user left channel $channel', subtitle: '(client ID $client)');
      onNewItem(item);
    });

    _subscription.publication.listen((event) {
      final String message = json.decode(utf8.decode(event.data))['input'];

      final item = _ChatItem(title: message, subtitle: 'User: user');
      onNewItem(item);
    });

    await _subscription.subscribe();
  }

  void _show(dynamic error) {
    showDialog<AlertDialog>(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(
          error.toString(),
        ),
      ),
    );
  }
}

class _ChatItem {
  _ChatItem({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}
