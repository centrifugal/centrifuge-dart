import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart';

import 'proto/client.pb.dart' hide Error;
import 'subscription.dart';

class Client {
  WebSocket socket;
  final _handlers = <int, Completer<GeneratedMessage>>{};
  final _subscriptions = <String, SubscriptionImpl>{};

  Client({@required this.socket});

  Future connect() async {
    socket.listen(
      _onData,
      onError: (dynamic error) => print(error),
      onDone: _onSocketDone,
    );

    final command = _createCommand(MethodType.CONNECT);
    await _send(command, ConnectResult());
  }

  void _onSocketDone() {
    final event = UnsubscribeEvent();
    _subscriptions.values.forEach((s) => s.onUnsubscribe(event));
    //TODO: Invoke onDisconnect handler
  }

  Subscription subscribe(String channel) {
    final subscription = SubscriptionImpl(channel, this);

    _subscriptions[channel] = subscription;

    subscription.resubscribe(false);

    return subscription;
  }

  T _processReply<T extends GeneratedMessage>(T result, Reply reply) {
    result.mergeFromBuffer(reply.result);
    if (reply.hasError()) {
      throw reply.error;
    }
    return result;
  }

  Future<T> _send<T extends GeneratedMessage>(Command command, T result) async {
    final reply = await _writeCommand(command);
    final filledResult = _processReply(result, reply);
    return filledResult;
  }

  Command _createCommand(MethodType methodType) => Command()
    ..id = _nextMessageId()
    ..method = methodType;

  void _onData(dynamic input) {
    // TODO: Remove debug prints

    final List<int> data = input;

    final reader = CodedBufferReader(data);
    var count = 0;
    while (!reader.isAtEnd()) {
      final reply = Reply();
      reader.readMessage(reply, ExtensionRegistry.EMPTY);
      print('onData> ${reply.id}');

      count++;
      if (reply.id > 0) {
        _onResponse(reply);
      } else {
        _onPush(reply);
      }
    }
    if (count > 1) {
      print('$count messages in ws frame.');
    }
  }

  void _onPush(Reply reply) {
    final push = Push.fromBuffer(reply.result);

    final subscription = _subscriptions[push.channel];

    switch (push.type) {
      case PushType.PUBLICATION:
        final pub = Publication.fromBuffer(push.data);
        final event = PublishEvent.from(pub);
        subscription.onPublish(event);
        break;
      case PushType.LEAVE:
        final leave = Leave.fromBuffer(push.data);
        final event = LeaveEvent.from(leave.info);

        subscription.onLeave(event);
        break;
      case PushType.JOIN:
        final join = Join.fromBuffer(push.data);
        final event = JoinEvent.from(join.info);
        subscription.onJoin(event);
        break;
      case PushType.MESSAGE:
        final message = Message.fromBuffer(push.data);
        print(utf8.decode(message.data));
        // TODO: Implement MESSAGE
        break;
      case PushType.UNSUB:
        final event = UnsubscribeEvent();
        subscription.onUnsubscribe(event);
        break;
    }
  }

  void _onResponse(Reply reply) {
    assert(reply.id > 0);
    _handlers.remove(reply.id).complete(reply);
  }

  Future<Reply> _writeCommand(Command command) {
    final completer = Completer<Reply>.sync();

    _handlers[command.id] = completer;

    final data = _ProtobufCommandEncoder().encode(command);
    socket.add(data);

    return completer.future;
  }

  int _messageId = 1;

  int _nextMessageId() => _messageId++;

  Future<void> disconnect() async {
    await socket.close();
  }

  Future publish(String channel, List<int> data) async {
    final publish = PublishRequest()
      ..channel = channel
      ..data = data;

    final command = _createCommand(MethodType.PUBLISH)
      ..params = publish.writeToBuffer();

    final result = await _send(command, PublishResult());
    return result;
  }

  Future<UnsubscribeResult> sendUnsubscribe(String channel) {
    final command = _createCommand(MethodType.UNSUBSCRIBE)
      ..params = (UnsubscribeRequest()..channel = channel).writeToBuffer();
    final result = _send(command, UnsubscribeResult());
    return result;
  }

  Future<SubscribeResult> sendSubscribe(String channel) {
    final command = _createCommand(MethodType.SUBSCRIBE)
      ..params = (SubscribeRequest()..channel = channel).writeToBuffer();
    final result = _send(command, SubscribeResult());
    return result;
  }
}

class _ProtobufCommandEncoder {
  List<int> encode(Command command) {
    final commandData = command.writeToBuffer();
    final length = commandData.lengthInBytes;

    final writer = CodedBufferWriter();
    writer.writeInt32NoTag(length);

    return writer.toBuffer() + commandData;
  }
}
