import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart';

import 'package:protobuf/protobuf.dart';

import 'proto/client.pb.dart' hide Error;

class _ProtobufCommandEncoder {
  List<int> encode(Command command) {
    final commandData = command.writeToBuffer();
    final length = commandData.lengthInBytes;

    final writer = CodedBufferWriter();
    writer.writeInt32NoTag(length);

    return writer.toBuffer() + commandData;
  }
}

class CentrifugeClient {
  final String url;

  StreamSubscription _streamSubscription;
  WebSocket _socket;
  final _handlers = Map<int, Completer<GeneratedMessage>>();
  final _subscriptions = Map<String, Subscription>();

  CentrifugeClient({@required this.url});

  void connect() async {
    _socket = await WebSocket.connect(url);
    _streamSubscription = _socket.listen(
      _onData,
      onError: (error) => print(error),
      onDone: () => print("Done"),
    );

    final command = _createCommand(MethodType.CONNECT);
    await _send(command, ConnectResult());
  }

  Future<void> subscribe(String channel, SubscriptionEvents eventHub) async {
    _subscriptions[channel] = Subscription(channel, eventHub);

    final command = _createCommand(MethodType.SUBSCRIBE)
      ..params = (SubscribeRequest()..channel = channel).writeToBuffer();
    await _send(command, SubscribeResult());
  }

  T _processReply<T extends GeneratedMessage>(T result, Reply reply) {
    result.mergeFromBuffer(reply.result);
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
    final List<int> data = input;

    final reader = CodedBufferReader(data);
    while (!reader.isAtEnd()) {
      final reply = Reply();
      reader.readMessage(reply, ExtensionRegistry.EMPTY);

      if (reply.id > 0) {
        _onResponse(reply);
      } else {
        _onPush(reply);
      }
    }
  }

  void _onPush(Reply reply) {
    final push = Push.fromBuffer(reply.result);

    final subscription = _subscriptions[push.channel];
    final events = subscription._events;

    switch (push.type) {
      case PushType.PUBLICATION:
        final pub = Publication.fromBuffer(push.data);
        final event = PublishEvent.from(pub);
        events.onPublish?.call(subscription, event);
        break;
      case PushType.LEAVE:
        final leave = Leave.fromBuffer(push.data);
        final event = LeaveEvent.from(leave.info);
        events.onLeave?.call(subscription, event);
        break;
      case PushType.JOIN:
        final join = Join.fromBuffer(push.data);
        final event = JoinEvent.from(join.info);
        events.onJoin?.call(subscription, event);
        break;
      case PushType.MESSAGE:
        final message = Message.fromBuffer(push.data);
        print(utf8.decode(message.data));
        // TODO: Implement MESSAGE
        break;
      case PushType.UNSUB:
        events.onUnsubscribe?.call(subscription);
        break;
    }
  }

  void _onResponse(Reply reply) {
    assert(reply.id > 0);
    _handlers[reply.id].complete(reply);
  }

  Future<Reply> _writeCommand(Command command) {
    final completer = Completer<Reply>();

    _handlers[command.id] = completer;

    final data = _ProtobufCommandEncoder().encode(command);
    _socket.add(data);

    return completer.future;
  }

  int _messageId = 1;

  int _nextMessageId() => _messageId++;

  Future<void> disconnect() async {
    await _streamSubscription.cancel();
    _socket.close();
  }
}

class Subscription {
  final String channel;
  final SubscriptionEvents _events;

  Subscription(this.channel, this._events);
}

class SubscriptionEvents {
  final Function(Subscription, PublishEvent) onPublish;
  final Function(Subscription, JoinEvent) onJoin;
  final Function(Subscription, LeaveEvent) onLeave;
  final Function(Subscription, SubscribeSuccessEvent) onSubscribeSuccess;
  final Function(Subscription, Error) onSubscribeError;
  final Function(Subscription) onUnsubscribe;

  SubscriptionEvents(
      {this.onPublish,
      this.onJoin,
      this.onLeave,
      this.onUnsubscribe,
      this.onSubscribeSuccess,
      this.onSubscribeError});
}

class PublishEvent {
  final String uid;
  final List<int> data;

  PublishEvent._(this.uid, this.data);

  static PublishEvent from(Publication pub) =>
      PublishEvent._(pub.uid, pub.data);

  @override
  String toString() {
    return 'PublishEvent{uid: $uid, data: $data}';
  }
}

class JoinEvent {
  final String user;
  final String client;

  JoinEvent._(this.user, this.client);

  static JoinEvent from(ClientInfo clientInfo) =>
      JoinEvent._(clientInfo.user, clientInfo.client);

  @override
  String toString() {
    return 'JoinEvent{user: $user, client: $client}';
  }
}

class LeaveEvent {
  final String user;
  final String client;

  LeaveEvent._(this.user, this.client);

  static LeaveEvent from(ClientInfo clientInfo) =>
      LeaveEvent._(clientInfo.user, clientInfo.client);

  @override
  String toString() {
    return 'LeaveEvent{user: $user, client: $client}';
  }
}

class SubscribeSuccessEvent {
  final bool resubscribed;
  final bool recovered;

  SubscribeSuccessEvent._(this.resubscribed, this.recovered);

  @override
  String toString() {
    return 'SubscribeSuccessEvent{resubscribed: $resubscribed, recovered: $recovered}';
  }
}
