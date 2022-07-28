import 'dart:async';
import 'dart:math';

import 'package:centrifuge/centrifuge.dart';
import 'package:centrifuge/src/codes.dart';
import 'package:centrifuge/src/server_subscription.dart';
import 'package:centrifuge/src/transport.dart';
import 'package:meta/meta.dart';

import 'client_config.dart';
import 'events.dart';
import 'proto/client.pb.dart' as protocol;
import 'subscription.dart';
import 'subscription_config.dart';
import 'transport.dart';

enum State { disconnected, connecting, connected }

Client createClient(String url, [ClientConfig? config]) => ClientImpl(
      url,
      config ?? ClientConfig(),
      protobufTransportBuilder,
    );

abstract class Client {
  Stream<ConnectingEvent> get connecting;
  Stream<ConnectedEvent> get connected;
  Stream<DisconnectedEvent> get disconnected;

  Stream<ErrorEvent> get error;

  Stream<MessageEvent> get message;

  Stream<ServerSubscribedEvent> get subscribed;
  Stream<ServerSubscribingEvent> get subscribing;
  Stream<ServerUnsubscribedEvent> get unsubscribed;

  Stream<ServerPublicationEvent> get publication;
  Stream<ServerJoinEvent> get join;
  Stream<ServerLeaveEvent> get leave;

  /// State of client.
  State get state;

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
  ClientImpl(this._url, this._config, this._transportBuilder) {
    _token = _config.token;
    _data = _config.data;
  }

  final TransportBuilder _transportBuilder;
  final _subscriptions = <String, SubscriptionImpl>{};
  final _serverSubs = <String, ServerSubscription>{};

  Transport? _transport;

  final String _url;
  ClientConfig _config;
  ClientConfig get config => _config;

  String? _token;
  List<int>? _data;
  String? _client;
  String? get client => _client;

  Timer? _reconnectTimer;
  Timer? _refreshTimer;
  Timer? _pingTimer;
  bool _refreshRequired = false;
  int _reconnectAttempts = 0;
  int _pingInterval = 0;
  bool _sendPong = false;

  @override
  State state = State.disconnected;

  final _readyFutures = <Completer<void>>[];

  final _connectedController = StreamController<ConnectedEvent>.broadcast(sync: true);
  final _disconnectedController = StreamController<DisconnectedEvent>.broadcast(sync: true);
  final _connectingController = StreamController<ConnectingEvent>.broadcast(sync: true);
  final _errorController = StreamController<ErrorEvent>.broadcast(sync: true);
  final _messageController = StreamController<MessageEvent>.broadcast(sync: true);
  final _subscribedController = StreamController<ServerSubscribedEvent>.broadcast(sync: true);
  final _subscribingController = StreamController<ServerSubscribingEvent>.broadcast(sync: true);
  final _unsubscribedController = StreamController<ServerUnsubscribedEvent>.broadcast(sync: true);
  final _publicationController = StreamController<ServerPublicationEvent>.broadcast(sync: true);
  final _joinController = StreamController<ServerJoinEvent>.broadcast(sync: true);
  final _leaveController = StreamController<ServerLeaveEvent>.broadcast(sync: true);

  @override
  Stream<ConnectedEvent> get connected => _connectedController.stream;

  @override
  Stream<DisconnectedEvent> get disconnected => _disconnectedController.stream;

  @override
  Stream<ConnectingEvent> get connecting => _connectingController.stream;

  @override
  Stream<ErrorEvent> get error => _errorController.stream;

  @override
  Stream<MessageEvent> get message => _messageController.stream;

  @override
  Stream<ServerSubscribedEvent> get subscribed => _subscribedController.stream;

  @override
  Stream<ServerSubscribingEvent> get subscribing => _subscribingController.stream;

  @override
  Stream<ServerUnsubscribedEvent> get unsubscribed => _unsubscribedController.stream;

  @override
  Stream<ServerPublicationEvent> get publication => _publicationController.stream;

  @override
  Stream<ServerJoinEvent> get join => _joinController.stream;

  @override
  Stream<ServerLeaveEvent> get leave => _leaveController.stream;

  @override
  Future<void> connect() async {
    if (state == State.connected) {
      return;
    }
    if (state == State.connecting) {
      throw ClientConnectingError();
    }
    state = State.connecting;
    final event = ConnectingEvent(connectingCodeConnectCalled, 'connect called');
    _connectingController.add(event);
    _reconnectAttempts = 0;
    await _connect();
  }

  @override
  Future<void> disconnect() async {
    _reconnectAttempts = 0;
    _processDisconnect(code: disconnectedCodeDisconnectCalled, reason: 'disconnect called', reconnect: false);
    await _transport?.close();
  }

  @override
  Future<void> ready() {
    if (state == State.connected) {
      return Future.value();
    }
    if (state == State.disconnected) {
      throw ClientDisconnectedError();
    }
    final completer = new Completer<void>();
    _readyFutures.add(completer);
    return completer.future;
  }

  @override
  Future<PublishResult> publish(String channel, List<int> data) async {
    await ready().timeout(_config.timeout);
    final request = protocol.PublishRequest()
      ..channel = channel
      ..data = data;
    final result = await _transport!.sendMessage(
      request,
      protocol.PublishResult(),
    );
    return PublishResult.from(result);
  }

  @override
  Future<RPCResult> rpc(String method, List<int> data) async {
    await ready().timeout(_config.timeout);
    final request = protocol.RPCRequest();
    request.method = method;
    request.data = data;
    final result = await _transport!.sendMessage(request, protocol.RPCResult());
    return RPCResult.from(result);
  }

  @override
  Future<HistoryResult> history(String channel,
      {int limit = 0, StreamPosition? since, bool reverse = false}) async {
    await ready().timeout(_config.timeout);
    final request = protocol.HistoryRequest()..channel = channel;
    request.limit = limit;
    request.reverse = reverse;
    if (since != null) {
      final sp = protocol.StreamPosition();
      sp.offset = since.offset;
      sp.epoch = since.epoch;
      request.since = sp;
    }
    final result = await _transport!.sendMessage(
      request,
      protocol.HistoryResult(),
    );
    return HistoryResult.from(result);
  }

  @override
  Future<PresenceResult> presence(String channel) async {
    await ready().timeout(_config.timeout);
    final request = protocol.PresenceRequest()..channel = channel;
    final result = await _transport!.sendMessage(
      request,
      protocol.PresenceResult(),
    );
    return PresenceResult.from(result);
  }

  @override
  Future<PresenceStatsResult> presenceStats(String channel) async {
    await ready().timeout(_config.timeout);
    final request = protocol.PresenceStatsRequest()..channel = channel;
    final result = await _transport!.sendMessage(
      request,
      protocol.PresenceStatsResult(),
    );
    return PresenceStatsResult.from(result);
  }

  @override
  Future<void> send(List<int> data) async {
    await ready().timeout(_config.timeout);
    final request = protocol.Message()..data = data;
    await _transport!.sendAsyncMessage(request);
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
    if (state == State.disconnected) {
      return;
    }
    _reconnectTimer?.cancel();
    _refreshTimer?.cancel();
    _pingTimer?.cancel();

    final prevState = state;

    if (state == State.connected) {
      _client = null;
      _subscriptions.values
          .forEach((s) => s.moveToSubscribing(subscribingCodeTransportClosed, "transport closed"));

      _serverSubs.forEach((key, value) {
        final event = ServerSubscribingEvent.from(key);
        _subscribingController.add(event);
      });
    }

    if (reconnect) {
      state = State.connecting;
      _scheduleReconnect();
    } else {
      state = State.disconnected;
    }

    final needEvent = prevState != state;

    if (needEvent) {
      if (state == State.connecting) {
        final event = ConnectingEvent(code, reason);
        _connectingController.add(event);
      } else {
        final event = DisconnectedEvent(code, reason);
        _disconnectedController.add(event);
      }
    }

    if (state == State.disconnected) {
      _errorReadyFutures(ClientDisconnectedError());
    }
  }

  void _failUnauthorized() {
    _processDisconnect(code: disconnectedCodeUnauthorized, reason: 'unauthorized', reconnect: false);
    if (_transport == null) {
      return;
    }
    _transport!.close();
  }

  void _scheduleReconnect() {
    final delay = backoffDelay(_reconnectAttempts, _config.minReconnectDelay, _config.maxReconnectDelay);
    _reconnectTimer = Timer(delay, () {
      if (state != State.connecting) {
        return;
      }
      _connect();
    });
    _reconnectAttempts += 1;
  }

  Future<void> _connect() async {
    if (state != State.connecting) {
      return;
    }

    if (_refreshRequired || (_token == null && _config.getToken != null)) {
      final event = ConnectionTokenEvent();
      try {
        final String token = await _config.getToken!(event);
        if (token == "") {
          _failUnauthorized();
          return;
        }
        _token = token;
        _refreshRequired = false;
      } catch (ex) {
        final event = ErrorEvent(RefreshError(ex));
        _errorController.add(event);
        if (_transport != null) {
          await _transport!.close();
        }
        _scheduleReconnect();
        return;
      }
    }

    _transport = _transportBuilder(
        url: _url, config: TransportConfig(headers: _config.headers, timeout: _config.timeout));

    try {
      await _transport!.open(_onPush, onError: (dynamic error) {
        final event = ErrorEvent(TransportError(error));
        _errorController.add(event);
        if (state != State.connected) {
          return;
        }
        _processDisconnect(code: connectingCodeTransportClosed, reason: "connection closed", reconnect: true);
        _transport!.close();
      }, onDone: (code, reason, reconnect) {
        if (state == State.disconnected) {
          return;
        }
        _processDisconnect(code: code, reason: reason, reconnect: reconnect);
      });
    } catch (ex) {
      final event = ErrorEvent(TransportError(ex));
      _errorController.add(event);
      await _transport!.close();
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
      final result = await _transport!.sendMessage(
        request,
        protocol.ConnectResult(),
      );

      state = State.connected;
      _client = result.client;
      _reconnectAttempts = 0;
      final event = ConnectedEvent.from(result);
      _connectedController.add(event);
      _completeReadyFutures();

      result.subs.forEach((key, value) {
        _serverSubs[key] = ServerSubscription(key, value.recoverable, value.offset, value.epoch);
        final event = ServerSubscribedEvent.fromSubscribeResult(key, value);
        _subscribedController.add(event);
        value.publications.forEach((element) {
          final event = ServerPublicationEvent.from(key, element);
          _publicationController.add(event);
          if (_serverSubs[key]!.recoverable && element.offset > 0) {
            _serverSubs[key]!.offset = element.offset;
          }
        });
      });

      _serverSubs.forEach((key, value) {
        if (!result.subs.containsKey(key)) {
          final event = ServerUnsubscribedEvent.from(key);
          _unsubscribedController.add(event);
        }
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

      _sendPong = result.pong;
      if (result.ping > 0) {
        _pingInterval = result.ping;
        _setPingTimer();
      }
    } catch (err) {
      final event = ErrorEvent(ConnectError(err));
      _errorController.add(event);
      if (err is Error) {
        if (err.code == 109) {
          // token expired.
          _refreshRequired = true;
          _scheduleReconnect();
          return;
        } else if (!err.temporary) {
          _processDisconnect(code: err.code, reason: err.message, reconnect: false);
          _transport!.close();
          return;
        } else {
          _processDisconnect(code: err.code, reason: err.message, reconnect: false);
          _transport!.close();
          return;
        }
      } else {
        _scheduleReconnect();
        return;
      }
    }
  }

  void _setPingTimer() {
    _pingTimer = Timer(Duration(seconds: _pingInterval) + _config.maxServerPingDelay, () async {
      if (state != State.connected) {
        return;
      }
      processDisconnect(code: connectingCodeNoPing, reason: 'no ping', reconnect: true);
      await _transport!.close();
    });
  }

  void _refreshToken() async {
    if (_config.getToken == null) {
      return;
    }
    try {
      final event = ConnectionTokenEvent();
      final String token = await _config.getToken!(event);
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
      final result = await _transport!.sendMessage(
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
        _processDisconnect(code: err.code, reason: err.message, reconnect: false);
        _transport!.close();
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
    _readyFutures.clear();
  }

  void _errorReadyFutures(dynamic error) {
    for (var i = 0; i < _readyFutures.length; i++) {
      _readyFutures[i].completeError(error);
    }
    _readyFutures.clear();
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

  void _handleDisconnect(protocol.Disconnect disconnect) {
    final code = disconnect.code;
    final bool reconnect = code < 3500 || code >= 5000 || (code >= 4000 && code < 4500);
    _processDisconnect(code: disconnect.code, reason: disconnect.reason, reconnect: reconnect);
    _transport!.close();
  }

  void _handleSubscribe(String channel, protocol.Subscribe subscribe) {
    final event = ServerSubscribedEvent.fromSubscribePush(channel, subscribe, false);
    _serverSubs[channel] =
        ServerSubscription.from(channel, subscribe.recoverable, subscribe.offset, subscribe.epoch);
    _subscribedController.add(event);
  }

  void _handleUnsubscribe(String channel, protocol.Unsubscribe unsubscribe) {
    final subscription = _subscriptions[channel];
    if (subscription != null) {
      if (unsubscribe.code < 2500) {
        subscription.moveToUnsubscribed(unsubscribe.code, unsubscribe.reason, false);
      } else {
        subscription.moveToSubscribing(unsubscribe.code, unsubscribe.reason);
      }
      return;
    }
    final serverSubscription = _serverSubs[channel];
    if (serverSubscription != null) {
      final event = ServerUnsubscribedEvent.from(channel);
      _serverSubs.remove(channel);
      _unsubscribedController.add(event);
    }
  }

  void _onPing() {
    _pingTimer?.cancel();
    _setPingTimer();

    if (_sendPong) {
      _transport!.sendAsyncMessage(
        protocol.Command(),
      );
    }
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
      _handleUnsubscribe(push.channel, push.unsubscribe);
    } else if (push.hasMessage()) {
      _handleMessage(push.message);
    } else if (push.hasDisconnect()) {
      _handleDisconnect(push.disconnect);
    }
  }

  @internal
  Future<protocol.UnsubscribeResult> sendUnsubscribe(protocol.UnsubscribeRequest request) async {
    return await _transport!.sendMessage(
      request,
      protocol.UnsubscribeResult(),
    );
  }

  @internal
  Future<protocol.SubscribeResult> sendSubscribe(protocol.SubscribeRequest request) async {
    return await _transport!.sendMessage(
      request,
      protocol.SubscribeResult(),
    );
  }

  @internal
  Future<protocol.SubRefreshResult> sendSubRefresh(protocol.SubRefreshRequest request) async {
    return await _transport!.sendMessage(
      request,
      protocol.SubRefreshResult(),
    );
  }

  @internal
  void processDisconnect({required int code, required String reason, required bool reconnect}) async {
    return _processDisconnect(code: code, reason: reason, reconnect: reconnect);
  }

  @internal
  void closeTransport() async => await _transport!.close();
}

final _random = new Random();

Duration backoffDelay(int step, Duration minDelay, Duration maxDelay) {
  // Full jitter technique.
  // https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/
  if (step > 31) {
    step = 31;
  } // Avoid RangeError.
  final val = min(maxDelay.inMilliseconds, minDelay.inMilliseconds * pow(2, step));
  final interval = _random.nextInt(val.toInt());
  final milliseconds = min(maxDelay.inMilliseconds, minDelay.inMilliseconds + interval);
  return Duration(milliseconds: milliseconds);
}
