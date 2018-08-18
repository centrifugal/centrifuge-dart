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
  final _subscriptions = Map<String, _Subscription>();

  CentrifugeClient({@required this.url});

  void connect() async {
    _socket = await WebSocket.connect(url);
    _streamSubscription = _socket.listen(
      _onData,
      onError: (error) => print(error),
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
    final subscription = _Subscription(channel);

    try {
      _subscriptions[channel] = subscription;

      final command = _createCommand(MethodType.SUBSCRIBE)
        ..params = (SubscribeRequest()..channel = channel).writeToBuffer();
      _send(command, SubscribeResult()).then((result) {
        subscription
            .onSubscribeSuccess(SubscribeSuccessEvent.from(result, false));
      },
          onError: (error) =>
              subscription.onSubscribeError(SubscribeErrorEvent._(error)));
    } catch (exception) {
      final event = SubscribeErrorEvent._(exception);
      subscription.onSubscribeError(event);
    }
    return subscription;
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

    print('onData> ${utf8.decode(data)}');

    final reader = CodedBufferReader(data);
    var count = 0;
    while (!reader.isAtEnd()) {
      final reply = Reply();
      reader.readMessage(reply, ExtensionRegistry.EMPTY);
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

abstract class Subscription {
  final String channel;

  Subscription(this.channel);

  Stream<PublishEvent> get publishStream;

  Stream<JoinEvent> get joinStream;

  Stream<LeaveEvent> get leaveStream;

  Stream<SubscribeSuccessEvent> get subscribeSuccessStream;

  Stream<SubscribeErrorEvent> get subscribeErrorStream;

  Stream<UnsubscribeEvent> get unsubscribeStream;
}

class _Subscription implements Subscription {
  final String channel;

  _Subscription(this.channel);

  final _publishController =
      StreamController<PublishEvent>.broadcast(sync: true);
  final _joinController = StreamController<JoinEvent>.broadcast(sync: true);
  final _leaveController = StreamController<LeaveEvent>.broadcast(sync: true);
  final _subscribeSuccessController =
      StreamController<SubscribeSuccessEvent>.broadcast(sync: true);
  final _subscribeErrorController =
      StreamController<SubscribeErrorEvent>.broadcast(sync: true);
  final _unsubscribeController =
      StreamController<UnsubscribeEvent>.broadcast(sync: true);

  Stream<PublishEvent> get publishStream => _publishController.stream;

  Stream<JoinEvent> get joinStream => _joinController.stream;

  Stream<LeaveEvent> get leaveStream => _leaveController.stream;

  Stream<SubscribeSuccessEvent> get subscribeSuccessStream =>
      _subscribeSuccessController.stream;

  Stream<SubscribeErrorEvent> get subscribeErrorStream =>
      _subscribeErrorController.stream;

  Stream<UnsubscribeEvent> get unsubscribeStream =>
      _unsubscribeController.stream;

  void onPublish(PublishEvent event) => _publishController.add(event);

  void onJoin(JoinEvent event) => _joinController.add(event);

  void onLeave(LeaveEvent event) => _leaveController.add(event);

  void onSubscribeSuccess(SubscribeSuccessEvent event) =>
      _subscribeSuccessController.add(event);

  void onSubscribeError(SubscribeErrorEvent event) =>
      _subscribeErrorController.add(event);

  void onUnsubscribe(UnsubscribeEvent event) =>
      _unsubscribeController.add(event);
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

  static SubscribeSuccessEvent from(
          SubscribeResult result, bool resubscribed) =>
      SubscribeSuccessEvent._(resubscribed, result.recovered);

  @override
  String toString() {
    return 'SubscribeSuccessEvent{resubscribed: $resubscribed, recovered: $recovered}';
  }
}

class SubscribeErrorEvent {
  final Error error;

  SubscribeErrorEvent._(this.error);

  @override
  String toString() {
    return 'SubscribeErrorEvent{error: $error}';
  }
}

class UnsubscribeEvent {
  @override
  String toString() {
    return 'UnsubscribeEvent{}';
  }
}
