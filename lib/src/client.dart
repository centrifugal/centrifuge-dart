import 'dart:async';
import 'dart:math';

import 'package:centrifuge/centrifuge.dart';
import 'package:centrifuge/src/server_subscription.dart';
import 'package:centrifuge/src/transport.dart';
import 'package:meta/meta.dart';

import 'client_config.dart';
import 'events.dart';
import 'proto/client.pb.dart' as protocol;
import 'subscription.dart';
import 'subscription_config.dart';
import 'transport.dart';

enum State { disconnected, connecting, connected, failed }

enum FailReason { server, connectFailed, refreshFailed, unauthorized, unrecoverable }

Client createClient(String url, [ClientConfig? config]) => ClientImpl(
      url,
      config ?? ClientConfig(),
      protobufTransportBuilder,
    );

abstract class Client {
  Stream<ConnectEvent> get connectStream;
  Stream<DisconnectEvent> get disconnectStream;
  Stream<FailEvent> get failStream;
  Stream<ErrorEvent> get errorStream;
  Stream<MessageEvent> get messageStream;
  Stream<ServerSubscribeEvent> get subscribeStream;
  Stream<ServerUnsubscribeEvent> get unsubscribeStream;
  Stream<ServerPublicationEvent> get publicationStream;
  Stream<ServerJoinEvent> get joinStream;
  Stream<ServerLeaveEvent> get leaveStream;

  /// Connect to the server.
  ///
  Future<void> connect();

  /// Disconnect from the server.
  ///
  Future<void> disconnect();

  /// Ready resolves when client successfully connected.
  /// Throws exceptions if called not in connecting or connected state.
  Future<void> ready();

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
  Future<HistoryResult> history(String channel, {int limit = 0, StreamPosition? since, bool reverse = false});

  /// Send Presence command.
  ///
  Future<PresenceResult> presence(String channel);

  /// Send PresenceStats command.
  ///
  Future<PresenceStatsResult> presenceStats(String channel);

  /// Get subscription to the channel.
  ///
  /// You need to call [Subscription.subscribe] to start receiving events
  /// in the channel.
  Subscription? getSubscription(String channel);

  /// Create new subscription.
  Subscription newSubscription(String channel, [SubscriptionConfig? config]);

  /// Remove the [Subscription] from internal registry and unsubscribe from [Subscription.channel].
  ///
  void removeSubscription(Subscription subscription);

  /// Get map wirth all registered client-side subscriptions.
  Map<String, Subscription> subscriptions();
}

class ClientImpl implements Client {
  ClientImpl(this._url, this._config, this._transportBuilder);

  final TransportBuilder _transportBuilder;
  final _subscriptions = <String, SubscriptionImpl>{};
  final _serverSubs = <String, ServerSubscription>{};

  late Transport _transport;

  final String _url;
  ClientConfig _config;
  ClientConfig get config => _config;

  String? _token;
  List<int>? _data;
  String? _client;
  String? get client => _client;

  Timer? _reconnectTimer;
  Timer? _refreshTimer;
  bool _refreshRequired = false;

  State state = State.disconnected;

  int _reconnectCount = 0;

  final _readyFutures = <Completer<void>>[];

  final _connectController = StreamController<ConnectEvent>.broadcast(sync: true);
  final _disconnectController = StreamController<DisconnectEvent>.broadcast(sync: true);
  final _failController = StreamController<FailEvent>.broadcast(sync: true);
  final _errorController = StreamController<ErrorEvent>.broadcast(sync: true);
  final _messageController = StreamController<MessageEvent>.broadcast(sync: true);
  final _subscribeController = StreamController<ServerSubscribeEvent>.broadcast(sync: true);
  final _unsubscribeController = StreamController<ServerUnsubscribeEvent>.broadcast(sync: true);
  final _publicationController = StreamController<ServerPublicationEvent>.broadcast(sync: true);
  final _joinController = StreamController<ServerJoinEvent>.broadcast(sync: true);
  final _leaveController = StreamController<ServerLeaveEvent>.broadcast(sync: true);

  @override
  Stream<ConnectEvent> get connectStream => _connectController.stream;

  @override
  Stream<DisconnectEvent> get disconnectStream => _disconnectController.stream;

  @override
  Stream<FailEvent> get failStream => _failController.stream;

  @override
  Stream<ErrorEvent> get errorStream => _errorController.stream;

  @override
  Stream<MessageEvent> get messageStream => _messageController.stream;

  @override
  Stream<ServerSubscribeEvent> get subscribeStream => _subscribeController.stream;

  @override
  Stream<ServerUnsubscribeEvent> get unsubscribeStream => _unsubscribeController.stream;

  @override
  Stream<ServerPublicationEvent> get publicationStream => _publicationController.stream;

  @override
  Stream<ServerJoinEvent> get joinStream => _joinController.stream;

  @override
  Stream<ServerLeaveEvent> get leaveStream => _leaveController.stream;

  @override
  Future<void> connect() async {
    if (state == State.connected) {
      return;
    }
    if (state == State.connecting) {
      throw ClientConnectingError();
    }
    state = State.connecting;
    await _connect();
  }

  @override
  Future<PublishResult> publish(String channel, List<int> data) async {
    final request = protocol.PublishRequest()
      ..channel = channel
      ..data = data;

    final result = await _transport.sendMessage(
      request,
      protocol.PublishResult(),
    );
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
    final result = await _transport.sendMessage(
      request,
      protocol.HistoryResult(),
    );
    return HistoryResult.from(result);
  }

  @override
  Future<void> ready() {
    if (state == State.connected) {
      return Future.value();
    }
    if (state != State.connecting) {
      if (state == State.disconnected) {
        throw ClientDisconnectedError();
      }
      throw ClientFailedError();
    }
    final completer = new Completer<void>();
    _readyFutures.add(completer);
    return completer.future;
  }

  @override
  Future<PresenceResult> presence(String channel) async {
    final request = protocol.PresenceRequest()..channel = channel;
    final result = await _transport.sendMessage(
      request,
      protocol.PresenceResult(),
    );
    return PresenceResult.from(result);
  }

  @override
  Future<PresenceStatsResult> presenceStats(String channel) async {
    final request = protocol.PresenceStatsRequest()..channel = channel;
    final result = await _transport.sendMessage(
      request,
      protocol.PresenceStatsResult(),
    );
    return PresenceStatsResult.from(result);
  }

  @override
  Future<void> send(List<int> data) async {
    final request = protocol.Message()..data = data;
    await _transport.sendAsyncMessage(request);
  }

  @override
  Future<void> disconnect() async {
    _processDisconnect(code: 0, reason: 'client', reconnect: false);
    await _transport.close();
  }

  @override
  Subscription? getSubscription(String channel) {
    if (_subscriptions.containsKey(channel)) {
      return _subscriptions[channel]!;
    }
    return null;
  }

  @override
  Subscription newSubscription(String channel, [SubscriptionConfig? config]) {
    if (_subscriptions.containsKey(channel)) {
      throw Exception("Subscription to a channel already exists in client's internal registry");
    }
    final subscription = SubscriptionImpl(channel, this, config ?? SubscriptionConfig());
    _subscriptions[channel] = subscription;
    return subscription;
  }

  @override
  void removeSubscription(Subscription subscription) {
    final String channel = subscription.channel;
    subscription.unsubscribe();
    _subscriptions.remove(channel);
  }

  @override
  Map<String, Subscription> subscriptions() {
    return _subscriptions;
  }

  void _processDisconnect({required int code, required String reason, required bool reconnect}) async {
    if (state == State.disconnected || state == State.failed) {
      return;
    }
    _reconnectTimer?.cancel();
    _refreshTimer?.cancel();

    if (state == State.connected) {
      _client = null;

      _subscriptions.values.forEach((s) => s.unsubscribeOnDisconnect());

      _serverSubs.forEach((key, value) {
        final event = ServerUnsubscribeEvent.from(key);
        _unsubscribeController.add(event);
      });

      final disconnect = DisconnectEvent(code, reason, reconnect);
      _disconnectController.add(disconnect);
    }

    if (reconnect) {
      state = State.connecting;
      _scheduleReconnect();
    } else {
      state = State.disconnected;
    }

    if (!reconnect && code >= 3000) {
      _failServer(code);
    }

    if (state == State.disconnected) {
      _errorReadyFutures(ClientDisconnectedError());
    } else if (state == State.failed) {
      _errorReadyFutures(ClientFailedError());
    }
  }

  void _fail(FailReason reason, int disconnectCode) {
    _processDisconnect(code: disconnectCode, reason: "failed", reconnect: false);
    state = State.failed;
    final failEvent = FailEvent(reason);
    _failController.add(failEvent);
    _subscriptions.values.forEach((s) => s.failClient());
  }

  void _connectFailed() {
    _fail(FailReason.connectFailed, 5);
  }

  void _refreshFailed() {
    _fail(FailReason.refreshFailed, 6);
  }

  void _failUnauthorized() {
    _fail(FailReason.unauthorized, 7);
  }

  void _failUnrecoverable() {
    _serverSubs.clear();
    _fail(FailReason.unrecoverable, 8);
  }

  void _failServer(int disconnectCode) {
    _fail(FailReason.server, disconnectCode);
  }

  void _scheduleReconnect() {
    final delay = backoffDelay(_reconnectCount, _config.minReconnectDelay, _config.maxReconnectDelay);
    _reconnectTimer = Timer(delay, () {
      if (state != State.connecting) {
        return;
      }
      _connect();
    });
    _reconnectCount += 1;
  }

  Future<void> _connect() async {
    if (state != State.connecting) {
      return;
    }

    if (_refreshRequired) {
      final event = ConnectionTokenEvent();
      try {
        final String token = await _config.onConnectionToken(event);
        if (token == "") {
          _failUnauthorized();
          return;
        }
        _token = token;
        _refreshRequired = false;
      } catch (ex) {
        final event = ErrorEvent(RefreshError(ex));
        _errorController.add(event);
        await _transport.close();
        _scheduleReconnect();
        return;
      }
    }

    _transport = _transportBuilder(
        url: _url, config: TransportConfig(headers: _config.headers, timeout: _config.timeout));

    try {
      await _transport.open(_onPush, onError: (dynamic error) {
        final event = ErrorEvent(TransportError(error));
        _errorController.add(event);
        if (state != State.connected) {
          return;
        }
        _transport.close();
        _processDisconnect(code: 4, reason: "connection closed", reconnect: true);
      }, onDone: (code, reason, reconnect) {
        if (state != State.connected && !(state == State.connecting)) {
          return;
        }
        _processDisconnect(code: code, reason: reason, reconnect: reconnect);
      });
    } catch (ex) {
      final event = ErrorEvent(TransportError(ex));
      _errorController.add(event);
      await _transport.close();
      _scheduleReconnect();
      return;
    }

    final request = protocol.ConnectRequest();
    if (_token != null) {
      request.token = _token!;
    }
    if (_data != null) {
      request.data = _data!;
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

    try {
      final result = await _transport.sendMessage(
        request,
        protocol.ConnectResult(),
      );

      state = State.connected;
      _client = result.client;
      _reconnectCount = 0;
      final event = ConnectEvent.from(result);
      _connectController.add(event);
      _completeReadyFutures();

      result.subs.forEach((key, value) {
        _serverSubs[key] = ServerSubscription(key, value.recoverable, value.offset, value.epoch);
        final event = ServerSubscribeEvent.fromSubscribeResult(key, value);
        _subscribeController.add(event);
        value.publications.forEach((element) {
          final event = ServerPublicationEvent.from(key, element);
          _publicationController.add(event);
          if (_serverSubs[key]!.recoverable && element.offset > 0) {
            _serverSubs[key]!.offset = element.offset;
          }
        });
      });

      _serverSubs.removeWhere((key, value) => !result.subs.containsKey(key));

      for (SubscriptionImpl subscription in _subscriptions.values) {
        subscription.resubscribeOnConnect();
      }

      if (result.expires) {
        _refreshTimer = Timer(Duration(seconds: result.ttl), () {
          if (state != State.connected) {
            return;
          }
          _refreshToken();
        });
      }
    } catch (err) {
      final event = ErrorEvent(ConnectError(err));
      _errorController.add(event);
      await _transport.close();
      if (err is Error) {
        if (err.code == 109) {
          // token expired.
          _refreshRequired = true;
          _scheduleReconnect();
          return;
        } else if (err.code == 112) {
          // unrecoverable position.
          _failUnrecoverable();
          return;
        } else if (!err.temporary) {
          _connectFailed();
          return;
        } else {
          _scheduleReconnect();
          return;
        }
      } else {
        _scheduleReconnect();
        return;
      }
    }
  }

  void _refreshToken() async {
    try {
      final event = ConnectionTokenEvent();
      final String token = await _config.onConnectionToken(event);
      if (token == "") {
        _failUnauthorized();
        return;
      }
      _token = token;
    } catch (ex) {
      if (state != State.connected) {
        return;
      }
      final event = ErrorEvent(RefreshError(ex));
      _errorController.add(event);
      _refreshTimer = Timer(backoffDelay(0, Duration(seconds: 5), Duration(seconds: 10)), () {
        if (state != State.connected) {
          return;
        }
        _refreshToken();
      });
      return;
    }

    final request = protocol.RefreshRequest();

    if (_token != null) {
      request.token = _token!;
    }

    try {
      final result = await _transport.sendMessage(
        request,
        protocol.RefreshResult(),
      );

      if (result.expires) {
        _refreshTimer = Timer(Duration(seconds: result.ttl), () {
          if (state != State.connected) {
            return;
          }
          _refreshToken();
        });
      }
    } catch (err) {
      if (state != State.connected) {
        return;
      }
      final event = ErrorEvent(RefreshError(err));
      _errorController.add(event);
      if (err is Error) {
        if (err.temporary) {
          _refreshTimer = Timer(backoffDelay(0, Duration(seconds: 5), Duration(seconds: 10)), () {
            if (state != State.connected) {
              return;
            }
            _refreshToken();
          });
          return;
        }
        _refreshFailed();
        return;
      }
      _refreshTimer = Timer(backoffDelay(0, Duration(seconds: 5), Duration(seconds: 10)), () {
        if (state != State.connected) {
          return;
        }
        _refreshToken();
      });
    }
  }

  void _completeReadyFutures() {
    for (var i = 0; i < _readyFutures.length; i++) {
      _readyFutures[i].complete();
    }
  }

  void _errorReadyFutures(dynamic error) {
    for (var i = 0; i < _readyFutures.length; i++) {
      _readyFutures[i].completeError(error);
    }
  }

  void _handlePub(String channel, protocol.Publication pub) {
    final subscription = _subscriptions[channel];
    if (subscription != null) {
      subscription.handlePublication(pub);
      return;
    }
    final serverSubscription = _serverSubs[channel];
    if (serverSubscription != null) {
      final event = ServerPublicationEvent.from(channel, pub);
      _publicationController.add(event);
      if (serverSubscription.recoverable && pub.offset > 0) {
        serverSubscription.offset = pub.offset;
        _serverSubs[channel] = serverSubscription; // TODO: necessary to assign explicitly?
      }
    }
  }

  void _handleJoin(String channel, protocol.Join join) {
    final subscription = _subscriptions[channel];
    if (subscription != null) {
      subscription.handleJoin(join);
      return;
    }
    final serverSubscription = _serverSubs[channel];
    if (serverSubscription != null) {
      final event = ServerJoinEvent.from(channel, join.info);
      _joinController.add(event);
    }
  }

  void _handleLeave(String channel, protocol.Leave leave) {
    final subscription = _subscriptions[channel];
    if (subscription != null) {
      subscription.handleLeave(leave);
      return;
    }
    final serverSubscription = _serverSubs[channel];
    if (serverSubscription != null) {
      final event = ServerLeaveEvent.from(channel, leave.info);
      _leaveController.add(event);
    }
  }

  void _handleMessage(protocol.Message message) {
    final event = MessageEvent(message.data);
    _messageController.add(event);
  }

  void _handleSubscribe(String channel, protocol.Subscribe subscribe) {
    final event = ServerSubscribeEvent.fromSubscribePush(channel, subscribe, false);
    _serverSubs[channel] =
        ServerSubscription.from(channel, subscribe.recoverable, subscribe.offset, subscribe.epoch);
    _subscribeController.add(event);
  }

  void _handleUnsubscribe(String channel, protocol.Unsubscribe_Type type) {
    final subscription = _subscriptions[channel];
    if (subscription != null) {
      if (type == protocol.Unsubscribe_Type.INSUFFICIENT) {
        // TODO: Better handling without unsubscribed state.
        subscription.unsubscribe();
        subscription.subscribe();
      } else if (type == protocol.Unsubscribe_Type.UNRECOVERABLE) {
        subscription.failUnrecoverable();
      } else {
        subscription.unsubscribe();
      }
      return;
    }
    final serverSubscription = _serverSubs[channel];
    if (serverSubscription != null) {
      final event = ServerUnsubscribeEvent.from(channel);
      _serverSubs.remove(channel);
      _unsubscribeController.add(event);
    }
  }

  void _onPing() {
    _transport.sendAsyncMessage(
      protocol.Command(),
    );
  }

  void _onPush(protocol.Push push, bool isPing) {
    if (isPing) {
      _onPing();
      return;
    }
    if (push.hasPub()) {
      _handlePub(push.channel, push.pub);
    } else if (push.hasJoin()) {
      _handleJoin(push.channel, push.join);
    } else if (push.hasLeave()) {
      _handleLeave(push.channel, push.leave);
    } else if (push.hasSubscribe()) {
      _handleSubscribe(push.channel, push.subscribe);
    } else if (push.hasUnsubscribe()) {
      _handleUnsubscribe(push.channel, push.unsubscribe.type);
    } else if (push.hasMessage()) {
      _handleMessage(push.message);
    } else if (push.hasDisconnect()) {
      // TODO: implement.
      // _handleDisconnect(push.disconnect);
    }
  }

  @internal
  bool isPrivateChannel(String channel) => channel.startsWith(_config.privateChannelPrefix);

  @internal
  Future<protocol.UnsubscribeResult> sendUnsubscribe(String channel) async {
    final request = protocol.UnsubscribeRequest()..channel = channel;
    return await _transport.sendMessage(
      request,
      protocol.UnsubscribeResult(),
    );
  }

  @internal
  Future<protocol.SubscribeResult> sendSubscribe(protocol.SubscribeRequest request) async {
    return await _transport.sendMessage(
      request,
      protocol.SubscribeResult(),
    );
  }

  @internal
  Future<protocol.SubRefreshResult> sendSubRefresh(protocol.SubRefreshRequest request) async {
    return await _transport.sendMessage(
      request,
      protocol.SubRefreshResult(),
    );
  }

  @internal
  void processDisconnect({required int code, required String reason, required bool reconnect}) async {
    return _processDisconnect(code: code, reason: reason, reconnect: reconnect);
  }

  @internal
  void closeTransport() async => await _transport.close();
}

final _random = new Random();

Duration backoffDelay(int step, Duration minDelay, Duration maxDelay) {
  if (step > 31) {
    step = 31;
  } // Avoid RangeError.
  final val = min(maxDelay.inMilliseconds, minDelay.inMilliseconds * pow(2, step));
  final interval = _random.nextInt(val.toInt());
  final milliseconds = min(maxDelay.inMilliseconds, minDelay.inMilliseconds + interval);
  return Duration(milliseconds: milliseconds);
}
