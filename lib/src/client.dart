import 'dart:async';

import 'package:centrifuge/src/server_subscription.dart';
import 'package:centrifuge/src/transport.dart';
import 'package:meta/meta.dart';

import 'client_config.dart';
import 'events.dart';
import 'proto/client.pb.dart' as protocol;
import 'subscription.dart';
import 'transport.dart';

Client createClient(String url, {ClientConfig? config}) => ClientImpl(
      url,
      config ?? ClientConfig(),
      protobufTransportBuilder,
    );

abstract class Client {
  Stream<ConnectEvent> get connectStream;

  Stream<ErrorEvent> get errorStream;

  Stream<DisconnectEvent> get disconnectStream;

  Stream<MessageEvent> get messageStream;

  Stream<ServerSubscribeEvent> get subscribeStream;

  Stream<ServerUnsubscribeEvent> get unsubscribeStream;

  Stream<ServerPublishEvent> get publishStream;

  Stream<ServerJoinEvent> get joinStream;

  Stream<ServerLeaveEvent> get leaveStream;

  /// Connect to the server.
  ///
  Future<void> connect();

  /// Set token for connection request.
  ///
  /// Whenever the client connects to a server, it adds token to the
  /// connection request.
  ///
  /// To remove previous token, call with null.
  ///
  void setToken(String token);

  /// Set data for connection request.
  ///
  /// Whenever the client connects to a server, it adds connectData to the
  /// connection request.
  ///
  /// To remove previous connectData, call with null.
  ///
  void setConnectData(List<int> connectData);

  // Send asynchronous message to a server. This method makes sense
  // only when using Centrifuge library for Go on a server side. In Centrifugo
  // asynchronous message handler does not exist.
  ///
  Future<void> send(List<int> data);

  /// Publish data to the channel.
  ///
  Future<PublishResult> publish(String channel, List<int> data);

  /// Send RPC command.
  ///
  Future<RPCResult> rpc(String method, List<int> data);

  /// Send History command.
  ///
  Future<HistoryResult> history(String channel,
      {int limit = 0, StreamPosition? since, bool reverse = false});

  /// Send Presence command.
  ///
  Future<PresenceResult> presence(String channel);

  /// Send PresenceStats command.
  ///
  Future<PresenceStatsResult> presenceStats(String channel);

  /// Disconnect from the server.
  ///
  Future<void> disconnect();

  /// Detect that the subscription already exists.
  ///
  bool hasSubscription(String channel);

  /// Get subscription to the channel.
  ///
  /// You need to call [Subscription.subscribe] to start receiving events
  /// in the channel.
  Subscription getSubscription(String channel);

  /// Remove the [subscription] and unsubscribe from [subscription.channel].
  ///
  void removeSubscription(Subscription subscription);
}

class ClientImpl implements Client {
  ClientImpl(this._url, this._config, this._transportBuilder);

  final TransportBuilder _transportBuilder;
  final _subscriptions = <String, SubscriptionImpl>{};
  final _serverSubs = <String, ServerSubscription>{};

  late Transport _transport;
  String? _token;

  final String _url;
  ClientConfig _config;

  ClientConfig? get config => _config;
  List<int>? _connectData;
  String? _clientID;
  bool _new = true;

  final _connectController = StreamController<ConnectEvent>.broadcast();
  final _errorController = StreamController<ErrorEvent>.broadcast();
  final _disconnectController = StreamController<DisconnectEvent>.broadcast();
  final _messageController = StreamController<MessageEvent>.broadcast();
  final _subscribeController =
      StreamController<ServerSubscribeEvent>.broadcast();
  final _unsubscribeController =
      StreamController<ServerUnsubscribeEvent>.broadcast();
  final _publishController = StreamController<ServerPublishEvent>.broadcast();
  final _joinController = StreamController<ServerJoinEvent>.broadcast();
  final _leaveController = StreamController<ServerLeaveEvent>.broadcast();

  _ClientState _state = _ClientState.disconnected;

  @override
  Stream<ConnectEvent> get connectStream => _connectController.stream;

  @override
  Stream<ErrorEvent> get errorStream => _errorController.stream;

  @override
  Stream<DisconnectEvent> get disconnectStream => _disconnectController.stream;

  @override
  Stream<MessageEvent> get messageStream => _messageController.stream;

  @override
  Stream<ServerSubscribeEvent> get subscribeStream =>
      _subscribeController.stream;

  @override
  Stream<ServerUnsubscribeEvent> get unsubscribeStream =>
      _unsubscribeController.stream;

  @override
  Stream<ServerPublishEvent> get publishStream => _publishController.stream;

  @override
  Stream<ServerJoinEvent> get joinStream => _joinController.stream;

  @override
  Stream<ServerLeaveEvent> get leaveStream => _leaveController.stream;

  @override
  Future<void> connect() async => await _connect();

  @override
  void setToken(String token) => _token = token;

  @override
  void setConnectData(List<int> connectData) => _connectData = connectData;

  @override
  Future<PublishResult> publish(String channel, List<int> data) async {
    final request = protocol.PublishRequest()
      ..channel = channel
      ..data = data;

    final result =
        await _transport.sendMessage(request, protocol.PublishResult());
    return PublishResult.from(result);
  }

  @override
  Future<RPCResult> rpc(String method, List<int> data) async {
    final request = protocol.RPCRequest();
    request.method = method;
    request.data = data;
    final result = await _transport.sendMessage(request, protocol.RPCResult());
    return RPCResult.from(result);
  }

  @override
  Future<HistoryResult> history(String channel,
      {int limit = 0, StreamPosition? since, bool reverse = false}) async {
    final request = protocol.HistoryRequest()..channel = channel;
    request.limit = limit;
    request.reverse = reverse;
    if (since != null) {
      final sp = protocol.StreamPosition();
      sp.offset = since.offset;
      sp.epoch = since.epoch;
      request.since = sp;
    }
    final result =
        await _transport.sendMessage(request, protocol.HistoryResult());
    return HistoryResult.from(result);
  }

  @override
  Future<PresenceResult> presence(String channel) async {
    final request = protocol.PresenceRequest()..channel = channel;
    final result =
        await _transport.sendMessage(request, protocol.PresenceResult());
    return PresenceResult.from(result);
  }

  @override
  Future<PresenceStatsResult> presenceStats(String channel) async {
    final request = protocol.PresenceStatsRequest()..channel = channel;
    final result =
        await _transport.sendMessage(request, protocol.PresenceStatsResult());
    return PresenceStatsResult.from(result);
  }

  @override
  Future<void> send(List<int> data) async {
    final request = protocol.Message()..data = data;
    await _transport.sendAsyncMessage(request);
  }

  @override
  Future<void> disconnect() async {
    _processDisconnect(reason: 'client disconnect', reconnect: false);
    _new = true;
    await _transport.close();
  }

  @override
  bool hasSubscription(String channel) {
    return _subscriptions.containsKey(channel);
  }

  @override
  Subscription getSubscription(String channel) {
    if (hasSubscription(channel)) {
      return _subscriptions[channel]!;
    }

    final subscription = SubscriptionImpl(channel, this);

    _subscriptions[channel] = subscription;

    return subscription;
  }

  @override
  Future<void> removeSubscription(Subscription subscription) async {
    final String channel = subscription.channel;
    subscription.unsubscribe();
    _subscriptions.remove(channel);
  }

  int _retryCount = 0;

  void _processDisconnect(
      {required String reason, required bool reconnect}) async {
    if (_state == _ClientState.disconnected) {
      return;
    }
    _clientID = '';

    if (_state == _ClientState.connected ||
        (_state == _ClientState.connecting && _new)) {
      _subscriptions.values.forEach((s) => s.unsubscribeOnDisconnect());
      _serverSubs.forEach((key, value) {
        final event = ServerUnsubscribeEvent.from(key);
        _unsubscribeController.add(event);
      });
      final disconnect = DisconnectEvent(reason, reconnect);
      _disconnectController.add(disconnect);
      _new = false;
    }

    if (reconnect) {
      _state = _ClientState.connecting;
      scheduleReconnect();
    } else {
      _state = _ClientState.disconnected;
    }
  }

  void scheduleReconnect() async {
    _retryCount += 1;
    await _config.retry(_retryCount);
    if (_state == _ClientState.disconnected) {
      return;
    }
    _connect();
  }

  Future<void> _connect() async {
    try {
      _state = _ClientState.connecting;

      _transport = _transportBuilder(
          url: _url,
          config: TransportConfig(
              headers: _config.headers,
              pingInterval: _config.pingInterval,
              timeout: _config.timeout));

      await _transport.open(_onPush, onError: (dynamic error) {
        final event = ErrorEvent(error);
        _errorController.add(event);
        if (_state != _ClientState.connected) {
          return;
        }
        _processDisconnect(reason: "connection closed", reconnect: true);
      }, onDone: (reason, reconnect) {
        if (_state != _ClientState.connected &&
            !(_state == _ClientState.connecting && _new)) {
          return;
        }
        _processDisconnect(reason: reason, reconnect: reconnect);
      });

      final request = protocol.ConnectRequest();
      if (_token != null) {
        request.token = _token!;
      }

      if (_connectData != null) {
        request.data = _connectData!;
      }

      request.name = _config.name;
      request.version = _config.version;

      if (_serverSubs.isNotEmpty) {
        _serverSubs.forEach((key, value) {
          final subRequest = protocol.SubscribeRequest();
          subRequest.offset = value.offset;
          subRequest.epoch = value.epoch;
          subRequest.recover = value.recoverable;
          request.subs.putIfAbsent(key, () => subRequest);
        });
      }

      final result = await _transport.sendMessage(
        request,
        protocol.ConnectResult(),
      );

      _clientID = result.client;
      _retryCount = 0;
      _state = _ClientState.connected;
      _new = false;
      _connectController.add(ConnectEvent.from(result));

      result.subs.forEach((key, value) {
        final isResubscribed = _serverSubs[key] != null;
        _serverSubs[key] = ServerSubscription(
            key, value.recoverable, value.offset, value.epoch);
        final event = ServerSubscribeEvent.fromSubscribeResult(
            key, value, isResubscribed);
        _subscribeController.add(event);
        value.publications.forEach((element) {
          final event = ServerPublishEvent.from(key, element);
          _publishController.add(event);
          if (_serverSubs[key]!.recoverable && element.offset > 0) {
            _serverSubs[key]!.offset = element.offset;
          }
        });
      });
      _serverSubs.removeWhere((key, value) => !result.subs.containsKey(key));

      for (SubscriptionImpl subscription in _subscriptions.values) {
        subscription.resubscribeOnConnect();
      }
    } catch (ex) {
      final event = ErrorEvent(ex);
      _errorController.add(event);
      _processDisconnect(reason: "connect error", reconnect: true);
      await _transport.close();
    }
  }

  void _onPush(protocol.Push push) {
    switch (push.type) {
      case protocol.Push_PushType.PUBLICATION:
        final pub = protocol.Publication.fromBuffer(push.data);
        final subscription = _subscriptions[push.channel];
        if (subscription != null) {
          final event = PublishEvent.from(pub);
          subscription.addPublish(event);
          break;
        }
        final serverSubscription = _serverSubs[push.channel];
        if (serverSubscription != null) {
          final event = ServerPublishEvent.from(push.channel, pub);
          _publishController.add(event);
          if (_serverSubs[push.channel]!.recoverable && pub.offset > 0) {
            _serverSubs[push.channel]!.offset = pub.offset;
          }
        }
        break;
      case protocol.Push_PushType.LEAVE:
        final leave = protocol.Leave.fromBuffer(push.data);
        final subscription = _subscriptions[push.channel];
        if (subscription != null) {
          final event = LeaveEvent.from(leave.info);
          subscription.addLeave(event);
          break;
        }
        final serverSubscription = _serverSubs[push.channel];
        if (serverSubscription != null) {
          final event = ServerLeaveEvent.from(push.channel, leave.info);
          _leaveController.add(event);
        }
        break;
      case protocol.Push_PushType.JOIN:
        final join = protocol.Join.fromBuffer(push.data);
        final subscription = _subscriptions[push.channel];
        if (subscription != null) {
          final event = JoinEvent.from(join.info);
          subscription.addJoin(event);
          break;
        }
        final serverSubscription = _serverSubs[push.channel];
        if (serverSubscription != null) {
          final event = ServerJoinEvent.from(push.channel, join.info);
          _joinController.add(event);
        }
        break;
      case protocol.Push_PushType.MESSAGE:
        final message = protocol.Message.fromBuffer(push.data);
        final event = MessageEvent(message.data);
        _messageController.add(event);
        break;
      case protocol.Push_PushType.SUBSCRIBE:
        final subscribe = protocol.Subscribe.fromBuffer(push.data);
        final event = ServerSubscribeEvent.fromSubscribePush(
            push.channel, subscribe, false);
        _serverSubs[push.channel] = ServerSubscription.from(push.channel,
            subscribe.recoverable, subscribe.offset, subscribe.epoch);
        _subscribeController.add(event);
        break;
      case protocol.Push_PushType.UNSUBSCRIBE:
        final subscription = _subscriptions[push.channel];
        if (subscription != null) {
          final event = UnsubscribeEvent();
          subscription.addUnsubscribe(event);
          break;
        }
        final serverSubscription = _serverSubs[push.channel];
        if (serverSubscription != null) {
          final event = ServerUnsubscribeEvent.from(push.channel);
          _serverSubs.remove(push.channel);
          _unsubscribeController.add(event);
        }
        break;
    }
  }

  Future<String?> getToken(String channel) async {
    if (_clientID != null && _isPrivateChannel(channel)) {
      final event = PrivateSubEvent(_clientID!, channel);
      return _onPrivateSub(event);
    }
    return null;
  }

  Future<String> _onPrivateSub(PrivateSubEvent event) =>
      _config.onPrivateSub(event);

  bool _isPrivateChannel(String channel) =>
      channel.startsWith(_config.privateChannelPrefix);

  @internal
  Future<protocol.UnsubscribeResult> sendUnsubscribe(String channel) async {
    final request = protocol.UnsubscribeRequest()..channel = channel;
    return await _transport.sendMessage(request, protocol.UnsubscribeResult());
  }

  @internal
  Future<protocol.SubscribeResult> sendSubscribe(
      String channel, String? token) async {
    final request = protocol.SubscribeRequest()
      ..channel = channel
      ..token = token ?? '';
    return await _transport.sendMessage(request, protocol.SubscribeResult());
  }

  @internal
  void processDisconnect(
      {required String reason, required bool reconnect}) async {
    return _processDisconnect(reason: reason, reconnect: reconnect);
  }

  @internal
  void closeTransport() async => await _transport.close();

  @internal
  bool get connected => _state == _ClientState.connected;
}

enum _ClientState { connected, disconnected, connecting }
