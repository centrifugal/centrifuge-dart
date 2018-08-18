import 'dart:convert';
import 'dart:io';
import '../lib/centrifuge.dart';

void main() async {
  final url = 'ws://localhost:8000/connection/websocket?format=protobuf';
  final centrifuge = CentrifugeClient(url: url);

  try {
    await centrifuge.connect();

    final subscription = await centrifuge.subscribe('chat:index');
    final channel = subscription.channel;

    final onEvent = (event) {
      print('$channel> $event');
    };

    subscription.publishStream.map((e) => utf8.decode(e.data)).listen(onEvent);
    subscription.joinStream.listen(onEvent);
    subscription.leaveStream.listen(onEvent);

    subscription.subscribeSuccessStream.listen(onEvent);
    subscription.subscribeErrorStream.listen(onEvent);
    subscription.unsubscribeStream.listen(onEvent);

    await for (List<int> codeUnit in stdin) {
      final message = utf8.decode(codeUnit).trim();
      if (message == 'disconnect') {
        await centrifuge.disconnect();
      }
    }
  } catch (ex) {
    print(ex);
  }
}
