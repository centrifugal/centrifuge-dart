import 'dart:async';
import 'dart:convert';

import 'proto/client.pb.dart' hide Error;
import 'subscription.dart';
import 'transport.dart';

abstract class CentrifugeClient {
  Future<void> connect();

  Future<void> disconnect();

  Subscription subscribe(String channel);

  Future publish(String channel, List<int> data);
}

class CentrifugeClientImpl implements CentrifugeClient {
  Transport _connection;
  final TransportBuilder _connectionBuilder;
  final _subscriptions = <String, SubscriptionImpl>{};

  CentrifugeClientImpl(this._connectionBuilder);

  final _connectController =
      StreamController<ConnectEvent>.broadcast(sync: true);
  final _disconnectController =
      StreamController<DisconnectEvent>.broadcast(sync: true);
  final _errorController = StreamController<ErrorEvent>.broadcast(sync: true);

  Stream<ConnectEvent> get connectStream => _connectController.stream;

  Stream<DisconnectEvent> get disconnectStream => _disconnectController.stream;

  Stream<ErrorEvent> get errorStream => _errorController.stream;

  @override
  Future<void> connect() async {
    _connection = await _connectionBuilder();
    _connection.listen(_onPush);

    final result = await _connection.send(ConnectRequest(), ConnectResult());
    _connectController.add(ConnectEvent.from(result));
  }

  @override
  Subscription subscribe(String channel) {
    final subscription = SubscriptionImpl(channel, this);

    _subscriptions[channel] = subscription;

    subscription.resubscribe(false);

    return subscription;
  }

  @override
  Future<void> disconnect() async {
    await _connection.close();

    for (SubscriptionImpl subscription in _subscriptions.values) {
      final unsubscribe = UnsubscribeEvent();
      subscription.onUnsubscribe(unsubscribe);
    }

    final disconnect = DisconnectEvent._('clean disconnect', false);
    _disconnectController.add(disconnect);
  }

  @override
  Future publish(String channel, List<int> data) async {
    final request = PublishRequest()
      ..channel = channel
      ..data = data;

    await _connection.send(request, PublishResult());
  }

  Future<UnsubscribeResult> sendUnsubscribe(String channel) {
    final request = UnsubscribeRequest()..channel = channel;
    final result = _connection.send(request, UnsubscribeResult());
    return result;
  }

  Future<SubscribeResult> sendSubscribe(String channel) {
    final request = SubscribeRequest()..channel = channel;
    final result = _connection.send(request, SubscribeResult());
    return result;
  }

  void _onPush(Push push) {
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
}

class PrivateSubEvent {
  final String clientID;
  final String channel;

  PrivateSubEvent._(this.clientID, this.channel);

  @override
  String toString() {
    return 'PrivateSubEvent{clientID: $clientID, channel: $channel}';
  }
}

class ConnectEvent {
  final String client;
  final String version;
  final List<int> data;

  ConnectEvent._(this.client, this.version, this.data);

  static ConnectEvent from(ConnectResult result) =>
      ConnectEvent._(result.client, result.version, result.data);

  @override
  String toString() {
    return 'ConnectEvent{client: $client, version: $version, data: ${utf8.decode(data, allowMalformed: true)}}';
  }
}

class DisconnectEvent {
  final String reason;
  final bool reconnect;

  DisconnectEvent._(this.reason, this.reconnect);

  @override
  String toString() {
    return 'DisconnectEvent{reason: $reason, reconnect: $reconnect}';
  }
}

class ErrorEvent {
  final String message;

  ErrorEvent._(this.message);

  @override
  String toString() {
    return 'ErrorEvent{message: $message}';
  }
}

class MessageEvent {
  final List<int> data;

  MessageEvent._(this.data);

  @override
  String toString() {
    return 'MessageEvent{data: ${utf8.decode(data, allowMalformed: true)}';
  }
}
