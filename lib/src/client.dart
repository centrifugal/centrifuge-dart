import 'dart:async';

import 'package:centrifuge/src/transport.dart';
import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart';

import 'client_config.dart';
import 'events.dart';
import 'proto/client.pb.dart';
import 'subscription.dart';
import 'transport.dart';

Client createClient(String url, {ClientConfig config}) => ClientImpl(
      url,
      config ?? ClientConfig(),
      protobufTransportBuilder,
    );

abstract class Client {
  Stream<ConnectEvent> get connectStream;

  Stream<DisconnectEvent> get disconnectStream;

  Stream<MessageEvent> get messageStream;

  /// Connect to the server.
  ///
  void connect();

  /// Set token for connection request.
  ///
  /// Whenever the client connects to a server, it adds token to the
  /// connection request.
  ///
  /// To remove previous token, call with null.
  void setToken(String token);

  /// Set data for connection request.
  ///
  /// Whenever the client connects to a server, it adds connectData to the
  /// connection request.
  ///
  /// To remove previous connectData, call with null.
  void setConnectData(List<int> connectData);

  /// Publish data to the channel
  ///
  Future publish(String channel, List<int> data);

  /// Send RPC command
  ///
  Future<RPCResult> rpc(List<int> data);

  @alwaysThrows
  Future<void> send(List<int> data);

  /// Disconnect from the server.
  ///
  void disconnect();

  /// Get subscription to the channel.
  ///
  /// You need to call [Subscription.subscribe] to start receiving events
  /// in the channel.
  Subscription getSubscription(String channel);

  @alwaysThrows
  void removeSubscription(Subscription subscription);
}

class ClientImpl implements Client, GeneratedMessageSender {
  ClientImpl(this._url, this._config, this._transportBuilder);

  final TransportBuilder _transportBuilder;
  final _subscriptions = <String, SubscriptionImpl>{};

  Transport _transport;
  String _token;

  final String _url;
  ClientConfig _config;

  ClientConfig get config => _config;
  List<int> _connectData;
  String _clientID;

  final _connectController = StreamController<ConnectEvent>.broadcast();
  final _disconnectController = StreamController<DisconnectEvent>.broadcast();
  final _messageController = StreamController<MessageEvent>.broadcast();

  _ClientState _state = _ClientState.disconnected;

  @override
  Stream<ConnectEvent> get connectStream => _connectController.stream;

  @override
  Stream<DisconnectEvent> get disconnectStream => _disconnectController.stream;

  @override
  Stream<MessageEvent> get messageStream => _messageController.stream;

  @override
  void connect() async {
    return _connect();
  }

  @override
  bool get connected => _state == _ClientState.connected;

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
  void disconnect() async {
    _processDisconnect(reason: 'manual disconnect', reconnect: false);
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

  int _retryCount = 0;

  void _processDisconnect({@required String reason, bool reconnect}) async {
    if (_state == _ClientState.disconnected) {
      return;
    }
    _clientID = '';

    if (_state == _ClientState.connected) {
      _subscriptions.values.forEach((s) => s.sendUnsubscribeEventIfNeeded());

      final disconnect = DisconnectEvent(reason, reconnect);
      _disconnectController.add(disconnect);
    }

    if (reconnect) {
      _state = _ClientState.connecting;
      _retryCount += 1;
      await _config.retry(_retryCount);
      _connect();
    } else {
      _state = _ClientState.disconnected;
    }
  }

  Future<void> _connect() async {
    try {
      _state = _ClientState.connecting;

      _transport = _transportBuilder(
          url: _url,
          config: TransportConfig(
              headers: _config.headers, pingInterval: _config.pingInterval));

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

      _clientID = result.client;
      _retryCount = 0;
      _state = _ClientState.connected;
      _connectController.add(ConnectEvent.from(result));

      for (SubscriptionImpl subscription in _subscriptions.values) {
        subscription.resubscribeIfNeeded();
      }
    } catch (ex) {
      _processDisconnect(reason: ex.toString(), reconnect: true);
    }
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

  Future<String> getToken(String channel) async {
    if (_isPrivateChannel(channel)) {
      final event = PrivateSubEvent(_clientID, channel);
      return _onPrivateSub(event);
    }
    return null;
  }

  Future<String> _onPrivateSub(PrivateSubEvent event) =>
      _config.onPrivateSub(event);

  bool _isPrivateChannel(String channel) =>
      channel.startsWith(_config.privateChannelPrefix);
}

enum _ClientState { connected, disconnected, connecting }
