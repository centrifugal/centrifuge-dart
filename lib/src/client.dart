import 'dart:async';

import 'package:meta/meta.dart';

import 'events.dart';
import 'proto/client.pb.dart';
import 'transport.dart';

Client createClient(String url, {ClientConfig config = const ClientConfig()}) => _Client(
      url,
      config,
      protobufTransportBuilder,
    );

class ClientConfig {
  const ClientConfig({
    this.timeout = const Duration(seconds: 5),
    this.debug = false,
    this.headers = const <String, dynamic>{},
    this.tlsSkipVerify = false,
    this.maxReconnectDelay = const Duration(seconds: 20),
    this.privateChannelPrefix = "\$",
    this.pingInterval = const Duration(seconds: 25),
  });

  final Duration timeout;
  final bool debug;
  final Map<String, dynamic> headers;

  final bool tlsSkipVerify;

  final Duration maxReconnectDelay;
  final String privateChannelPrefix;
  final Duration pingInterval;
}

abstract class Client {
  void setToken(String token);

  Future<void> connect();

  Future<void> disconnect();

  Subscription subscribe(String channel, {String token});

  Future publish(String channel, List<int> data);

  Stream<ConnectEvent> get connectStream;

  Stream<DisconnectEvent> get disconnectStream;

  Stream<MessageEvent> get messageStream;
}

class _Client implements Client, SubscriptionClient {
  _Client(this.url, this.config, this.transportBuilder);

  final TransportBuilder transportBuilder;
  final _subscriptions = <String, _Subscription>{};

  Transport _transport;
  String _token;

  final String url;
  ClientConfig config;

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
  void setToken(String token) => _token = token;

  @override
  Future<void> connect() async {
    _transport = transportBuilder(url: url, headers: config.headers);

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

    final result = await _transport.send(
      request,
      ConnectResult(),
    );
    _connectController.add(ConnectEvent.from(result));
  }

  @override
  Subscription subscribe(String channel, {String token}) {
    final subscription = _Subscription(
      channel: channel,
      client: this,
      token: token,
    );

    _subscriptions[channel] = subscription;

    subscription.subscribe();

    return subscription;
  }

  @override
  Future<void> disconnect() async {
    await _transport.close();
  }

  void _processDisconnect({@required String reason, bool shouldReconnect}) {
    for (_Subscription subscription in _subscriptions.values) {
      final unsubscribe = UnsubscribeEvent();
      subscription.onUnsubscribe(unsubscribe);
    }

    final disconnect = DisconnectEvent(reason, shouldReconnect);
    _disconnectController.add(disconnect);
  }

  @override
  Future publish(String channel, List<int> data) async {
    final request = PublishRequest()
      ..channel = channel
      ..data = data;

    await _transport.send(request, PublishResult());
  }

  @override
  Future<UnsubscribeResult> sendUnsubscribe(String channel) {
    final request = UnsubscribeRequest()..channel = channel;
    final result = _transport.send(request, UnsubscribeResult());
    return result;
  }

  @override
  Future<SubscribeResult> sendSubscribe(String channel, {String token}) {
    final request = SubscribeRequest()..channel = channel;
    if (token != null) {
      request.token = token;
    }

    final result = _transport.send(request, SubscribeResult());
    return result;
  }

  @override
  Future<HistoryResult> sendHistory(String channel) {
    final request = HistoryRequest()..channel = channel;
    final result = _transport.send(request, HistoryResult());
    return result;
  }

  void _onPush(Push push) {
    switch (push.type) {
      case PushType.PUBLICATION:
        final pub = Publication.fromBuffer(push.data);
        final event = PublishEvent.from(pub);
        final subscription = _subscriptions[push.channel];

        subscription.onPublish(event);
        break;
      case PushType.LEAVE:
        final leave = Leave.fromBuffer(push.data);
        final event = LeaveEvent.from(leave.info);
        final subscription = _subscriptions[push.channel];

        subscription.onLeave(event);
        break;
      case PushType.JOIN:
        final join = Join.fromBuffer(push.data);
        final event = JoinEvent.from(join.info);
        final subscription = _subscriptions[push.channel];

        subscription.onJoin(event);
        break;
      case PushType.MESSAGE:
        final message = Message.fromBuffer(push.data);
        final event = MessageEvent(message.data);

        _messageController.add(event);
        break;
      case PushType.UNSUB:
        final event = UnsubscribeEvent();
        final subscription = _subscriptions[push.channel];

        subscription.onUnsubscribe(event);
        break;
    }
  }
}

abstract class Subscription {
  Subscription(this.channel);

  final String channel;

  Stream<PublishEvent> get publishStream;

  Stream<JoinEvent> get joinStream;

  Stream<LeaveEvent> get leaveStream;

  Stream<SubscribeSuccessEvent> get subscribeSuccessStream;

  Stream<SubscribeErrorEvent> get subscribeErrorStream;

  Stream<UnsubscribeEvent> get unsubscribeStream;

  Future subscribe();

  Future unsubscribe();

  Future publish(List<int> data);

  Future history();
}

abstract class SubscriptionClient {
  Future<SubscribeResult> sendSubscribe(String channel, {String token});

  Future<UnsubscribeResult> sendUnsubscribe(String channel);

  Future<HistoryResult> sendHistory(String channel);

  Future publish(String channel, List<int> data);
}

class _Subscription implements Subscription {
  _Subscription({
    @required this.channel,
    @required this.client,
    this.token,
  });

  @override
  final String channel;
  final String token;
  final SubscriptionClient client;

  final _publishController = StreamController<PublishEvent>.broadcast();
  final _joinController = StreamController<JoinEvent>.broadcast();
  final _leaveController = StreamController<LeaveEvent>.broadcast();
  final _subscribeSuccessController = StreamController<SubscribeSuccessEvent>.broadcast();
  final _subscribeErrorController = StreamController<SubscribeErrorEvent>.broadcast();
  final _unsubscribeController = StreamController<UnsubscribeEvent>.broadcast();

  @override
  Stream<PublishEvent> get publishStream => _publishController.stream;

  @override
  Stream<JoinEvent> get joinStream => _joinController.stream;

  @override
  Stream<LeaveEvent> get leaveStream => _leaveController.stream;

  @override
  Stream<SubscribeSuccessEvent> get subscribeSuccessStream => _subscribeSuccessController.stream;

  @override
  Stream<SubscribeErrorEvent> get subscribeErrorStream => _subscribeErrorController.stream;

  @override
  Stream<UnsubscribeEvent> get unsubscribeStream => _unsubscribeController.stream;

  @override
  Future publish(List<int> data) => client.publish(channel, data);

  @override
  Future subscribe() => _resubscribe(isResubscribed: false);

  @override
  Future unsubscribe() async {
    await client.sendUnsubscribe(channel);
    final event = UnsubscribeEvent();
    onUnsubscribe(event);
  }

  @override
  Future<List<HistoryEvent>> history() async {
    final result = await client.sendHistory(channel);
    final events = result.publications.map(HistoryEvent.from).toList();
    return events;
  }

  void onPublish(PublishEvent event) => _publishController.add(event);

  void onJoin(JoinEvent event) => _joinController.add(event);

  void onLeave(LeaveEvent event) => _leaveController.add(event);

  void onSubscribeSuccess(SubscribeSuccessEvent event) => _subscribeSuccessController.add(event);

  void onSubscribeError(SubscribeErrorEvent event) => _subscribeErrorController.add(event);

  void onUnsubscribe(UnsubscribeEvent event) => _unsubscribeController.add(event);

  Future _resubscribe({@required bool isResubscribed}) async {
    try {
      final result = await client.sendSubscribe(channel, token: token);
      final event = SubscribeSuccessEvent.from(result, isResubscribed);
      onSubscribeSuccess(event);
      recover(result);
    } catch (exception) {
      if (exception is Error) {
        onSubscribeError(SubscribeErrorEvent.from(exception));
      } else {
        onSubscribeError(SubscribeErrorEvent(exception.toString(), -1));
      }
    }
  }

  void recover(SubscribeResult result) {
    for (Publication publication in result.publications) {
      final event = PublishEvent.from(publication);
      onPublish(event);
    }
  }
}
