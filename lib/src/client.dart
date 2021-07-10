import 'dart:async';

import 'package:centrifuge/src/transport.dart';
import 'package:centrifuge/src/server_subscription.dart';
import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart';

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

  Stream<DisconnectEvent> get disconnectStream;

  Stream<MessageEvent> get messageStream;

  Stream<ServerSubscribeEvent> get subscribeStream;

  Stream<ServerUnsubscribeEvent> get unsubscribeStream;

  Stream<ServerPublishEvent> get publishStream;

  Stream<ServerJoinEvent> get joinStream;

  Stream<ServerLeaveEvent> get leaveStream;

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
  Future<PublishResult> publish(String channel, List<int> data);

  /// Send RPC command
  ///
  Future<RPCResult> rpc(String method, List<int> data);

  /// Send History command
  ///
  Future<HistoryResult> history(String channel,
      {int limit = 0, StreamPosition? since});

  @alwaysThrows
  Future<void> send(List<int> data);

  /// Disconnect from the server.
  ///
  void disconnect();

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

class ClientImpl implements Client, GeneratedMessageSender {
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

  final _connectController = StreamController<ConnectEvent>.broadcast();
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
  void connect() async {
    return _connect();
  }

  bool get connected => _state == _ClientState.connected;

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
      {int limit = 0, StreamPosition? since}) async {
    final request = protocol.HistoryRequest()..channel = channel;
    request.limit = limit;
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

  Future<UnsubscribeEvent> unsubscribe(String channel) async {
    final request = protocol.UnsubscribeRequest()..channel = channel;
    await _transport.sendMessage(request, protocol.UnsubscribeResult());
    return UnsubscribeEvent();
  }

  @override
  Future<Rep>
      sendMessage<Req extends GeneratedMessage, Rep extends GeneratedMessage>(
              Req request, Rep result) =>
          _transport.sendMessage(request, result);

  int _retryCount = 0;

  void _processDisconnect(
      {required String reason, required bool reconnect}) async {
    if (_state == _ClientState.disconnected) {
      return;
    }
    _clientID = '';

    if (_state == _ClientState.connected) {
      _subscriptions.values.forEach((s) => s.sendUnsubscribeEventIfNeeded());
      _serverSubs.forEach((key, value) {
        final event = ServerUnsubscribeEvent.from(key);
        _unsubscribeController.add(event);
      });
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
        });
      });
      _serverSubs.forEach((key, value) {
        if (!result.subs.containsKey(key)) {
          _serverSubs.remove(key);
        }
      });

      for (SubscriptionImpl subscription in _subscriptions.values) {
        subscription.resubscribeIfNeeded();
      }
    } catch (ex) {
      _processDisconnect(reason: ex.toString(), reconnect: true);
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
          _serverSubs[push.channel]!.offset = pub.offset;
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
}

enum _ClientState { connected, disconnected, connecting }
