import 'dart:async';

import 'package:meta/meta.dart';

import 'client_config.dart';
import 'events.dart';
import 'proto/client.pb.dart';
import 'transport.dart';

Client createClient(String url, {ClientConfig config = const ClientConfig()}) =>
    Client(
      url,
      config,
      protobufTransportBuilder,
    );

class Client {
  Client(this._url, this._config, this._transportBuilder);

  final TransportBuilder _transportBuilder;
  final _subscriptions = <String, Subscription>{};

  Transport _transport;
  String _token;

  final String _url;
  ClientConfig _config;
  List<int> _connectData;

  final _connectController = StreamController<ConnectEvent>.broadcast();
  final _disconnectController = StreamController<DisconnectEvent>.broadcast();
  final _messageController = StreamController<MessageEvent>.broadcast();

  Stream<ConnectEvent> get connectStream => _connectController.stream;

  Stream<DisconnectEvent> get disconnectStream => _disconnectController.stream;

  Stream<MessageEvent> get messageStream => _messageController.stream;

  Future<void> connect() async {
    _transport = _transportBuilder(url: _url, headers: _config.headers);

    await _transport.open(
      _onPush,
      onError: (dynamic error) =>
          _processDisconnect(reason: error.toString(), shouldReconnect: false),
      onDone: () => _processDisconnect(reason: 'done', shouldReconnect: false),
    );

    final request = ConnectRequest();
    if (_token != null) {
      request.token = _token;
    }

    if (_connectData != null) {
      request.data = _connectData;
    }

    final result = await _transport.send(
      request,
      ConnectResult(),
    );
    _connectController.add(ConnectEvent.from(result));
  }

  void setToken(String token) => _token = token;

  void setConnectData(List<int> connectData) => _connectData = connectData;

  Future publish(String channel, List<int> data) async {
    final request = PublishRequest()
      ..channel = channel
      ..data = data;

    await _transport.send(request, PublishResult());
  }

  @alwaysThrows
  Future<RPCResult> rpc(List<int> data) async {
    throw UnimplementedError;
  }

  @alwaysThrows
  Future<void> send(List<int> data) async {
    throw UnimplementedError;
  }

  Future<void> disconnect() async {
    await _transport.close();
  }

  Subscription getSubscription(String channel) {
    if (_subscriptions.containsKey(channel)) {
      return _subscriptions[channel];
    }

    final subscription = Subscription(
      channel: channel,
      client: this,
    );

    _subscriptions[channel] = subscription;

    return subscription;
  }

  @alwaysThrows
  Future<void> removeSubscription(Subscription subscription) async {
    throw UnimplementedError;
  }

  void _processDisconnect({@required String reason, bool shouldReconnect}) {
    for (Subscription subscription in _subscriptions.values) {
      final unsubscribe = UnsubscribeEvent();
      subscription._onUnsubscribe(unsubscribe);
    }

    final disconnect = DisconnectEvent(reason, shouldReconnect);
    _disconnectController.add(disconnect);
  }

  Future<UnsubscribeResult> _sendUnsubscribe(String channel) {
    final request = UnsubscribeRequest()..channel = channel;
    final result = _transport.send(request, UnsubscribeResult());
    return result;
  }

  Future<SubscribeResult> _sendSubscribe(String channel, {String token}) {
    final request = SubscribeRequest()..channel = channel;
    if (token != null) {
      request.token = token;
    }

    final result = _transport.send(request, SubscribeResult());
    return result;
  }

  void _onPush(Push push) {
    switch (push.type) {
      case PushType.PUBLICATION:
        final pub = Publication.fromBuffer(push.data);
        final event = PublishEvent.from(pub);
        final subscription = _subscriptions[push.channel];

        subscription._onPublish(event);
        break;
      case PushType.LEAVE:
        final leave = Leave.fromBuffer(push.data);
        final event = LeaveEvent.from(leave.info);
        final subscription = _subscriptions[push.channel];

        subscription._onLeave(event);
        break;
      case PushType.JOIN:
        final join = Join.fromBuffer(push.data);
        final event = JoinEvent.from(join.info);
        final subscription = _subscriptions[push.channel];

        subscription._onJoin(event);
        break;
      case PushType.MESSAGE:
        final message = Message.fromBuffer(push.data);
        final event = MessageEvent(message.data);

        _messageController.add(event);
        break;
      case PushType.UNSUB:
        final event = UnsubscribeEvent();
        final subscription = _subscriptions[push.channel];

        subscription._onUnsubscribe(event);
        break;
    }
  }
}

class Subscription {
  Subscription({
    @required this.channel,
    @required this.client,
    this.token,
  });

  final String channel;
  final String token;
  final Client client;

  final _publishController = StreamController<PublishEvent>.broadcast();
  final _joinController = StreamController<JoinEvent>.broadcast();
  final _leaveController = StreamController<LeaveEvent>.broadcast();
  final _subscribeSuccessController =
      StreamController<SubscribeSuccessEvent>.broadcast();
  final _subscribeErrorController =
      StreamController<SubscribeErrorEvent>.broadcast();
  final _unsubscribeController = StreamController<UnsubscribeEvent>.broadcast();

  Stream<PublishEvent> get publishStream => _publishController.stream;

  Stream<JoinEvent> get joinStream => _joinController.stream;

  Stream<LeaveEvent> get leaveStream => _leaveController.stream;

  Stream<SubscribeSuccessEvent> get subscribeSuccessStream =>
      _subscribeSuccessController.stream;

  Stream<SubscribeErrorEvent> get subscribeErrorStream =>
      _subscribeErrorController.stream;

  Stream<UnsubscribeEvent> get unsubscribeStream =>
      _unsubscribeController.stream;

  Future publish(List<int> data) => client.publish(channel, data);

  Future subscribe() => _resubscribe(isResubscribed: false);

  Future unsubscribe() async {
    await client._sendUnsubscribe(channel);
    final event = UnsubscribeEvent();
    _onUnsubscribe(event);
  }

  void _onPublish(PublishEvent event) => _publishController.add(event);

  void _onJoin(JoinEvent event) => _joinController.add(event);

  void _onLeave(LeaveEvent event) => _leaveController.add(event);

  void _onSubscribeSuccess(SubscribeSuccessEvent event) =>
      _subscribeSuccessController.add(event);

  void _onSubscribeError(SubscribeErrorEvent event) =>
      _subscribeErrorController.add(event);

  void _onUnsubscribe(UnsubscribeEvent event) =>
      _unsubscribeController.add(event);

  Future _resubscribe({@required bool isResubscribed}) async {
    try {
      final result = await client._sendSubscribe(channel, token: token);
      final event = SubscribeSuccessEvent.from(result, isResubscribed);
      _onSubscribeSuccess(event);
      _recover(result);
    } catch (exception) {
      if (exception is Error) {
        _onSubscribeError(SubscribeErrorEvent.from(exception));
      } else {
        _onSubscribeError(SubscribeErrorEvent(exception.toString(), -1));
      }
    }
  }

  void _recover(SubscribeResult result) {
    for (Publication publication in result.publications) {
      final event = PublishEvent.from(publication);
      _onPublish(event);
    }
  }
}
