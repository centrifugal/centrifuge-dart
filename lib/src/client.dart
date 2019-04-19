import 'dart:async';

import 'package:centrifuge/src/transport.dart';
import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart';

import 'client_config.dart';
import 'events.dart';
import 'proto/client.pb.dart';
import 'subscription.dart';
import 'transport.dart';

Client createClient(String url, {ClientConfig config = const ClientConfig()}) =>
    ClientImpl(
      url,
      config,
      protobufTransportBuilder,
    );

abstract class Client {
  Stream<ConnectEvent> get connectStream;

  Stream<DisconnectEvent> get disconnectStream;

  Stream<MessageEvent> get messageStream;

  Future<void> connect();

  void setToken(String token);

  void setConnectData(List<int> connectData);

  Future publish(String channel, List<int> data);

  /// Send RPC  command
  ///
  Future<RPCResult> rpc(List<int> data);

  @alwaysThrows
  Future<void> send(List<int> data);

  Future<void> disconnect();

  Subscription getSubscription(String channel);

  @alwaysThrows
  Future<void> removeSubscription(Subscription subscription);
}

class ClientImpl implements Client, GeneratedMessageSender {
  ClientImpl(this._url, this._config, this._transportBuilder);

  final TransportBuilder _transportBuilder;
  final _subscriptions = <String, SubscriptionImpl>{};

  Transport _transport;
  String _token;

  final String _url;
  ClientConfig _config;
  List<int> _connectData;

  final _connectController = StreamController<ConnectEvent>.broadcast();
  final _disconnectController = StreamController<DisconnectEvent>.broadcast();
  final _messageController = StreamController<MessageEvent>.broadcast();

  @override
  Stream<ConnectEvent> get connectStream => _connectController.stream;

  @override
  Stream<DisconnectEvent> get disconnectStream => _disconnectController.stream;

  @override
  Stream<MessageEvent> get messageStream => _messageController.stream;

  @override
  Future<void> connect() async {
    _transport = _transportBuilder(url: _url, headers: _config.headers);

    await _transport.open(
      _onPush,
      onError: (dynamic error) =>
          _processDisconnect(reason: error.toString(), reconnect: true),
      onDone: (reason, reconnect) =>
          _processDisconnect(reason: reason, reconnect: reconnect),
    );

    final request = ConnectRequest();
    if (_token != null) {
      request.token = _token;
    }

    if (_connectData != null) {
      request.data = _connectData;
    }

    final result = await _transport.sendMessage(
      request,
      ConnectResult(),
    );
    _connectController.add(ConnectEvent.from(result));
  }

  @override
  void setToken(String token) => _token = token;

  @override
  void setConnectData(List<int> connectData) => _connectData = connectData;

  @override
  Future publish(String channel, List<int> data) async {
    final request = PublishRequest()
      ..channel = channel
      ..data = data;

    await _transport.sendMessage(request, PublishResult());
  }

  @override
  Future<RPCResult> rpc(List<int> data) => _transport.sendMessage(
        RPCRequest()..data = data,
        RPCResult(),
      );

  @override
  @alwaysThrows
  Future<void> send(List<int> data) async {
    throw UnimplementedError;
  }

  @override
  Future<void> disconnect() async {
    await _transport.close();
  }

  @override
  Subscription getSubscription(String channel) {
    if (_subscriptions.containsKey(channel)) {
      return _subscriptions[channel];
    }

    final subscription = SubscriptionImpl(channel, this);

    _subscriptions[channel] = subscription;

    return subscription;
  }

  @override
  @alwaysThrows
  Future<void> removeSubscription(Subscription subscription) async {
    throw UnimplementedError;
  }

  Future<UnsubscribeEvent> unsubscribe(String channel) async {
    final request = UnsubscribeRequest()..channel = channel;
    await _transport.sendMessage(request, UnsubscribeResult());
    return UnsubscribeEvent();
  }

  @override
  Future<Rep>
      sendMessage<Req extends GeneratedMessage, Rep extends GeneratedMessage>(
              Req request, Rep result) =>
          _transport.sendMessage(request, result);

  void _processDisconnect({@required String reason, bool reconnect}) {
    for (SubscriptionImpl subscription in _subscriptions.values) {
      final unsubscribe = UnsubscribeEvent();
      subscription.addUnsubscribe(unsubscribe);
    }

    final disconnect = DisconnectEvent(reason, reconnect);
    _disconnectController.add(disconnect);
  }

  void _onPush(Push push) {
    switch (push.type) {
      case PushType.PUBLICATION:
        final pub = Publication.fromBuffer(push.data);
        final event = PublishEvent.from(pub);
        final subscription = _subscriptions[push.channel];

        subscription.addPublish(event);
        break;
      case PushType.LEAVE:
        final leave = Leave.fromBuffer(push.data);
        final event = LeaveEvent.from(leave.info);
        final subscription = _subscriptions[push.channel];

        subscription.addLeave(event);
        break;
      case PushType.JOIN:
        final join = Join.fromBuffer(push.data);
        final event = JoinEvent.from(join.info);
        final subscription = _subscriptions[push.channel];

        subscription.addJoin(event);
        break;
      case PushType.MESSAGE:
        final message = Message.fromBuffer(push.data);
        final event = MessageEvent(message.data);

        _messageController.add(event);
        break;
      case PushType.UNSUB:
        final event = UnsubscribeEvent();
        final subscription = _subscriptions[push.channel];

        subscription.addUnsubscribe(event);
        break;
    }
  }
}
