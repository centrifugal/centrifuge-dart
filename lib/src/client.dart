import 'dart:async';
import 'dart:math';

import 'package:centrifuge/centrifuge.dart';
import 'package:centrifuge/src/codes.dart';
import 'package:centrifuge/src/server_subscription.dart';
import 'package:centrifuge/src/transport.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:meta/meta.dart';

import 'event_controller.dart';
import 'platform/vm.dart' if (dart.library.js_interop) 'platform/js.dart';
import 'proto/client.pb.dart' as protocol;
import 'subscription.dart';

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
  /// Throws [ConfigurationError], without changing the state, if the endpoint
  /// can't be a websocket URL: on the VM it must be a ws:// or wss:// URL, and
  /// browsers also take http:// and https:// URLs and URLs relative to the page.
  Future<void> connect();

  /// Disconnect from the server.
  ///
  Future<void> disconnect();

  /// Close the client, disconnect from the server and release resources.
  /// The client is unusable after this call — every subsequent method throws
  /// [ClientClosedError]. Use [disconnect] for a temporary disconnect that
  /// keeps the client usable.
  Future<void> close();

  /// Set allows updating connection token.
  ///
  void setToken(String token);

  /// Set allows updating connection headers.
  ///
  void setHeaders(Map<String, String> headers);

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
  Future<void> removeSubscription(Subscription subscription);

  /// Get an unmodifiable copy of the map with all registered client-side
  /// subscriptions.
  Map<String, Subscription> subscriptions();
}

class ClientImpl implements Client {
  ClientImpl(this._url, this._config, this._transportBuilder) {
    _token = _config.token;
    _data = _config.data;
    _headers = Map<String, String>.of(_config.headers);
  }

  final TransportBuilder _transportBuilder;
  final _subscriptions = <String, SubscriptionImpl>{};
  // Channel compaction: numeric channel ID → subscription, used to route
  // pushes that carry an ID instead of the string channel name.
  final _subscriptionsById = <int, SubscriptionImpl>{};
  final _serverSubs = <String, ServerSubscription>{};

  Transport? _transport;

  final String _url;
  ClientConfig _config;
  ClientConfig get config => _config;

  Map<String, String> _headers = {};
  String _token = '';
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
  // Identifies the current connect attempt. Bumped when an attempt starts and
  // on every disconnect, so a superseded attempt stops at its next await
  // instead of acting on a newer session, and the callbacks of a torn down
  // transport are ignored.
  int _connectAttemptId = 0;
  // Transport of the attempt in progress, until it becomes _transport, so a
  // disconnect can close it too.
  Transport? _connectingTransport;
  bool _closed = false;

  @override
  State state = State.disconnected;

  final _readyFutures = <Completer<void>>[];

  final _connectedController = EventController<ConnectedEvent>();
  final _disconnectedController = EventController<DisconnectedEvent>();
  final _connectingController = EventController<ConnectingEvent>();
  final _errorController = EventController<ErrorEvent>();
  final _messageController = EventController<MessageEvent>();
  final _subscribedController = EventController<ServerSubscribedEvent>();
  final _subscribingController = EventController<ServerSubscribingEvent>();
  final _unsubscribedController = EventController<ServerUnsubscribedEvent>();
  final _publicationController = EventController<ServerPublicationEvent>();
  final _joinController = EventController<ServerJoinEvent>();
  final _leaveController = EventController<ServerLeaveEvent>();

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
    _checkNotClosed();
    if (state == State.connected) {
      return;
    }
    if (state == State.connecting) {
      // Waits for the attempt in progress, but like the call that started it
      // doesn't fail if the client disconnects instead: an app calling
      // connect() again without awaiting it would get an uncaught error.
      return _waitReady().catchError((Object _) {});
    }
    // An endpoint no retry can fix: fail before the state changes, so the
    // client stays disconnected and no token or data is loaded.
    final invalidEndpoint = endpointError(_url);
    if (invalidEndpoint != null) {
      throw ConfigurationError(invalidEndpoint);
    }
    state = State.connecting;
    _reconnectAttempts = 0;
    final attemptId = _connectAttemptId;
    final event = ConnectingEvent(connectingCodeConnectCalled, 'connect called');
    _connectingController.add(event);
    if (attemptId != _connectAttemptId) {
      // A connecting listener disconnected, and may have started an attempt of
      // its own.
      return;
    }
    await _connect();
  }

  void _checkNotClosed() {
    if (_closed) {
      throw ClientClosedError();
    }
  }

  @override
  void setToken(String token) {
    _token = token;
    if (_config.getToken == null) {
      // The only way to replace a token that expired or was invalidated. With
      // getToken, a new token is still requested: the one set may be stale.
      _refreshRequired = false;
    }
  }

  @override
  void setHeaders(Map<String, String> headers) {
    _headers = Map<String, String>.of(headers);
  }

  @override
  Future<void> disconnect() async {
    _checkNotClosed();
    _reconnectAttempts = 0;
    await _processDisconnect(
        code: disconnectedCodeDisconnectCalled, reason: 'disconnect called', reconnect: false);
  }

  @override
  Future<void> close() async {
    if (_closed) {
      return;
    }
    _closed = true;
    _reconnectAttempts = 0;
    await _processDisconnect(
        code: disconnectedCodeClientClosed, reason: 'client closed', reconnect: false);
    // A copy: an onDone handler of a subscription stream may remove its
    // subscription.
    for (final subscription in _subscriptions.values.toList()) {
      subscription.close();
    }
    _subscriptions.clear();
    _subscriptionsById.clear();
    _serverSubs.clear();
    await Future.wait<void>([
      _connectedController.close(),
      _disconnectedController.close(),
      _connectingController.close(),
      _errorController.close(),
      _messageController.close(),
      _subscribedController.close(),
      _subscribingController.close(),
      _unsubscribedController.close(),
      _publicationController.close(),
      _joinController.close(),
      _leaveController.close(),
    ]);
  }

  @override
  Future<void> ready() => _waitReady();

  /// [ready] for a call, with its [timeout]: a call that times out stops
  /// waiting.
  Future<void> _waitReady([Duration? timeout]) {
    // Failures are returned, not thrown, so they also reach a caller that
    // handles the future with catchError.
    if (_closed) {
      return Future.error(ClientClosedError());
    }
    if (state == State.connected) {
      return Future.value();
    }
    if (state == State.disconnected) {
      return Future.error(ClientDisconnectedError());
    }
    final completer = new Completer<void>();
    _readyFutures.add(completer);
    // A zero timeout means no timeout, as for the transport.
    if (timeout == null || timeout <= Duration.zero) {
      return completer.future;
    }
    return completer.future.timeout(timeout, onTimeout: () {
      _readyFutures.remove(completer);
      throw TimeoutException('Future not completed', timeout);
    });
  }

  /// The transport after `await ready()`, which yields: a disconnect may have
  /// happened in between.
  Transport _connectedTransport() {
    final transport = _transport;
    if (transport == null) {
      throw ClientDisconnectedError();
    }
    return transport;
  }

  @override
  Future<PublishResult> publish(String channel, List<int> data) async {
    await _waitReady(_config.timeout);
    final request = protocol.PublishRequest()
      ..channel = channel
      ..data = data;
    final result = await _connectedTransport().sendMessage(
      request,
      protocol.PublishResult(),
    );
    return PublishResult.from(result);
  }

  @override
  Future<RPCResult> rpc(String method, List<int> data) async {
    await _waitReady(_config.timeout);
    final request = protocol.RPCRequest();
    request.method = method;
    request.data = data;
    final result = await _connectedTransport().sendMessage(request, protocol.RPCResult());
    return RPCResult.from(result);
  }

  @override
  Future<HistoryResult> history(String channel,
      {int limit = 0, StreamPosition? since, bool reverse = false}) async {
    await _waitReady(_config.timeout);
    final request = protocol.HistoryRequest()..channel = channel;
    request.limit = limit;
    request.reverse = reverse;
    if (since != null) {
      final sp = protocol.StreamPosition();
      sp.offset = since.offset;
      sp.epoch = since.epoch;
      request.since = sp;
    }
    final result = await _connectedTransport().sendMessage(
      request,
      protocol.HistoryResult(),
    );
    return HistoryResult.from(result);
  }

  @override
  Future<PresenceResult> presence(String channel) async {
    await _waitReady(_config.timeout);
    final request = protocol.PresenceRequest()..channel = channel;
    final result = await _connectedTransport().sendMessage(
      request,
      protocol.PresenceResult(),
    );
    return PresenceResult.from(result);
  }

  @override
  Future<PresenceStatsResult> presenceStats(String channel) async {
    await _waitReady(_config.timeout);
    final request = protocol.PresenceStatsRequest()..channel = channel;
    final result = await _connectedTransport().sendMessage(
      request,
      protocol.PresenceStatsResult(),
    );
    return PresenceStatsResult.from(result);
  }

  @override
  Future<void> send(List<int> data) async {
    await _waitReady(_config.timeout);
    final request = protocol.SendRequest()..data = data;
    await _connectedTransport().sendAsyncMessage(request);
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
    _checkNotClosed();
    if (_subscriptions.containsKey(channel)) {
      throw Exception("Subscription to a channel already exists in client's internal registry");
    }
    final subscription = SubscriptionImpl(channel, this, config ?? SubscriptionConfig());
    _subscriptions[channel] = subscription;
    return subscription;
  }

  @override
  Future<void> removeSubscription(Subscription subscription) async {
    final String channel = subscription.channel;
    // A subscription removed before may have been replaced by a newer one for
    // its channel, which must stay.
    if (!identical(_subscriptions[channel], subscription)) {
      return;
    }
    // Unregistered at once: a new subscription to the channel can be created
    // while the cleanup Unsubscribe is pending, and is sent after it.
    await _subscriptions.remove(channel)!.remove();
  }

  @override
  Map<String, Subscription> subscriptions() {
    // A copy: code iterating over it may remove subscriptions.
    return Map.unmodifiable(_subscriptions);
  }

  Future<void> _processDisconnect(
      {required int code, required String reason, required bool reconnect}) async {
    if (state == State.disconnected) {
      return;
    }
    final attemptId = ++_connectAttemptId;
    // Captured before any event: a listener may start a new attempt, whose
    // transport must stay open.
    final transport = _transport;
    final connectingTransport = _connectingTransport;
    if (code == 3014) {
      // State invalidated: drop the connection token so the next connect
      // calls getToken again, and reset all subscription state so each
      // resubscribe starts from scratch. Centrifugo can deliver 3014 either
      // as a protocol Disconnect push or as the raw WebSocket close code,
      // so the handling lives here to cover both paths. Without getToken there
      // is no new token to get: the client reconnects with the token it has
      // (or anonymously), and the server rejects it if it's no longer valid.
      if (_config.getToken != null) {
        _token = '';
        _refreshRequired = true;
      }
      for (final s in _subscriptions.values) {
        s.invalidateState();
      }
      // Server-side subscriptions aren't tracked by SubscriptionImpl, but their
      // cached recovery position must be invalidated too - otherwise the next
      // connect request keeps asking the server to recover from the now-stale
      // pre-invalidation offset/epoch, defeating the point of state invalidation.
      // The recoverable flag is left untouched, matching invalidateState() above.
      for (final s in _serverSubs.values) {
        s.offset = $fixnum.Int64(0);
        s.epoch = '_';
      }
    }
    _reconnectTimer?.cancel();
    _refreshTimer?.cancel();
    _pingTimer?.cancel();

    final prevState = state;
    // Changed before any event: listeners see the new state, and a
    // disconnect() or connect() they call acts on it.
    state = reconnect ? State.connecting : State.disconnected;

    if (prevState == State.connected) {
      _client = null;
      // Channel compaction IDs are scoped to a server session — drop the
      // routing registry; each resubscribe re-registers a fresh ID.
      _subscriptionsById.clear();
      // Listeners may add or remove subscriptions: iterate over copies.
      for (final s in _subscriptions.values.toList()) {
        s.moveToSubscribingOnDisconnect();
      }
      for (final channel in _serverSubs.keys.toList()) {
        final event = ServerSubscribingEvent.from(channel);
        _subscribingController.add(event);
      }
    }

    // Skipped when a listener above already disconnected or started a new
    // attempt, which emitted its own events.
    if (attemptId == _connectAttemptId && prevState != state) {
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
    } else if (state == State.connecting && attemptId == _connectAttemptId) {
      // Skipped when a listener above already started a new attempt.
      _scheduleReconnect();
    }

    if (identical(_transport, transport)) {
      _transport = null;
    }
    if (identical(_connectingTransport, connectingTransport)) {
      _connectingTransport = null;
    }
    await transport?.close();
    await connectingTransport?.close();
  }

  // An exception while handling a push, e.g. a delta publication that can't be
  // applied, may have left the client or the application state inconsistent.
  // The error is reported as uncaught, as before, and the client stops in a
  // state the application can see: it disconnects without reconnecting, so no
  // later message is processed.
  void _pushFailed(Object error, StackTrace stackTrace) {
    Zone.current.handleUncaughtError(error, stackTrace);
    _processDisconnect(
        code: disconnectCodeBadProtocol,
        reason: 'exception during message handling: $error',
        reconnect: false);
  }

  Future<void> _failUnauthorized() async {
    await _processDisconnect(
        code: disconnectedCodeUnauthorized, reason: 'unauthorized', reconnect: false);
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
    // A new attempt supersedes one still in progress, which stops at its next
    // await (see _isActiveAttempt).
    final attemptId = ++_connectAttemptId;
    try {
      await _connectInner(attemptId);
    } on UnauthorizedException {
      if (_isActiveAttempt(attemptId)) {
        await _failUnauthorized();
      }
    }
  }

  bool _isActiveAttempt(int attemptId) => attemptId == _connectAttemptId && state == State.connecting;

  Future<void> _connectInner(int attemptId) async {
    if (_refreshRequired && _config.getToken == null) {
      // The token expired or was invalidated, and there is no way to get a
      // new one: retrying with it would fail forever.
      final event = ErrorEvent(
          ConfigurationError('token expired but no getToken function set in the configuration'));
      _errorController.add(event);
      throw UnauthorizedException();
    }
    if (_config.getToken != null && (_refreshRequired || _token == '')) {
      final event = ConnectionTokenEvent();
      final String token;
      try {
        token = await _config.getToken!(event);
      } catch (ex) {
        if (ex is UnauthorizedException) {
          // Handled by _connect.
          rethrow;
        }
        if (!_isActiveAttempt(attemptId)) return;
        final event = ErrorEvent(RefreshError(ex));
        _errorController.add(event);
        // Not after an error listener disconnected or started a new attempt.
        if (!_isActiveAttempt(attemptId)) return;
        _scheduleReconnect();
        return;
      }
      if (!_isActiveAttempt(attemptId)) {
        // Superseded while getToken was in flight: this token must not
        // overwrite one set for a newer attempt.
        return;
      }
      _token = token;
      _refreshRequired = false;
    }

    if (!_isActiveAttempt(attemptId)) {
      return;
    }

    final transport = _transportBuilder(
        url: _url,
        config: TransportConfig(
            headers: _headers,
            timeout: _config.timeout,
            tlsSkipVerify: _config.tlsSkipVerify));
    _connectingTransport = transport;

    try {
      await transport.open((push, isPing) {
        if (attemptId != _connectAttemptId) {
          // The rest of a message after its transport was torn down.
          return;
        }
        try {
          _onPush(push, isPing);
        } catch (error, stackTrace) {
          _pushFailed(error, stackTrace);
        }
      }, onError: (dynamic error) {
        if (attemptId != _connectAttemptId) return;
        final event = ErrorEvent(TransportError(error));
        _errorController.add(event);
        // Not after an error listener disconnected or started a new attempt.
        if (attemptId != _connectAttemptId) return;
        // The connection can't be trusted after data that isn't the protocol,
        // also while connecting: close it and reconnect now rather than after
        // the connect timeout.
        _processDisconnect(code: connectingCodeTransportClosed, reason: "connection closed", reconnect: true);
      }, onDone: (code, reason, reconnect) {
        // Ignore the close of a transport that was already torn down or whose
        // attempt was superseded.
        if (attemptId != _connectAttemptId) return;
        _processDisconnect(code: code, reason: reason, reconnect: reconnect);
      });
    } catch (ex) {
      if (!_isActiveAttempt(attemptId)) return;
      _connectingTransport = null;
      final event = ErrorEvent(TransportError(ex));
      _errorController.add(event);
      if (!_isActiveAttempt(attemptId)) return;
      _scheduleReconnect();
      return;
    }

    if (!_isActiveAttempt(attemptId)) {
      await transport.close();
      return;
    }

    final request = protocol.ConnectRequest();
    if (_token != '') {
      request.token = _token;
    }
    List<int>? data;
    if (_config.getData != null) {
      try {
        data = await _config.getData!();
      } catch (ex) {
        if (!_isActiveAttempt(attemptId)) {
          await transport.close();
          return;
        }
        final event = ErrorEvent(TransportError(ex));
        _errorController.add(event);
        if (!_isActiveAttempt(attemptId)) {
          await transport.close();
          return;
        }
        await _processDisconnect(code: connectingCodeTransportClosed, reason: "connection closed", reconnect: true);
        return;
      }
      if (!_isActiveAttempt(attemptId)) {
        // Superseded while getData was in flight, e.g. the transport closed
        // and its reconnect is already scheduled.
        await transport.close();
        return;
      }
    } else {
      data = _data;
    }
    if (data != null) {
      request.data = data;
    }
    request.name = _config.name;
    request.version = _config.version;

    if (isWeb) {
      // Use headers emulation in web context.
      request.headers.addAll(_headers);
    }

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
      final result = await transport.sendMessage(
        request,
        protocol.ConnectResult(),
      );

      if (!_isActiveAttempt(attemptId)) {
        await transport.close();
        return;
      }

      _connectingTransport = null;
      _transport = transport;
      state = State.connected;
      _client = result.client;
      _reconnectAttempts = 0;

      // Timers are armed before the connected event, so a listener tearing
      // the connection down cancels them.
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

      final event = ConnectedEvent.from(result);
      _connectedController.add(event);
      if (attemptId != _connectAttemptId) {
        // A connected listener disconnected, which failed the ready futures:
        // those added since wait for a new attempt.
        return;
      }
      _completeReadyFutures();

      // Listeners may disconnect: the rest of this reply must not be delivered
      // after that.
      for (final entry in result.subs.entries) {
        final key = entry.key;
        final value = entry.value;
        _serverSubs[key] = ServerSubscription(key, value.recoverable, value.offset, value.epoch);
        final event = ServerSubscribedEvent.fromSubscribeResult(key, value);
        _subscribedController.add(event);
        for (final pub in value.publications) {
          if (attemptId != _connectAttemptId) {
            return;
          }
          final event = ServerPublicationEvent.from(key, pub);
          _publicationController.add(event);
          if (_serverSubs[key]!.recoverable && pub.offset > 0) {
            _serverSubs[key]!.offset = pub.offset;
          }
        }
        if (attemptId != _connectAttemptId) {
          return;
        }
      }

      for (final key in _serverSubs.keys.toList()) {
        if (!result.subs.containsKey(key)) {
          _serverSubs.remove(key);
          final event = ServerUnsubscribedEvent.from(key);
          _unsubscribedController.add(event);
          if (attemptId != _connectAttemptId) {
            return;
          }
        }
      }

      for (final subscription in _subscriptions.values.toList()) {
        subscription.resubscribeOnConnect();
      }
    } catch (err) {
      if (!_isActiveAttempt(attemptId) || err is ClientDisconnectedError) {
        // Superseded by a disconnect, or the transport closed while the
        // connect command was in flight: the transport's onDone, which runs
        // before pending commands fail, handled that with the server's close
        // code (e.g. 3500 invalid token).
        return;
      }
      if (err is Error && err.code == 109) {
        // Token expired: set before the error event, so a connect() from its
        // listener gets a new token.
        _refreshRequired = true;
      }
      final event = ErrorEvent(ConnectError(err));
      _errorController.add(event);
      if (!_isActiveAttempt(attemptId)) {
        // An error listener disconnected or started a new attempt.
        return;
      }
      if (err is Error) {
        await _processDisconnect(
            code: err.code, reason: err.message, reconnect: err.code == 109 || err.temporary);
        return;
      }
      await _processDisconnect(
          code: connectingCodeTransportClosed, reason: "connection closed", reconnect: true);
      return;
    }
    if (state != State.connected) {
      await transport.close();
      return;
    }
  }

  void _setPingTimer() {
    late final Timer timer;
    timer = Timer(Duration(seconds: _pingInterval) + _config.maxServerPingDelay, () {
      // A ping may have been received but not processed yet, e.g. when a
      // suspended process resumes and runs this overdue timer before the data
      // waiting in the socket. Let that data be processed first.
      Timer.run(() async {
        // A ping processed meanwhile armed a new timer.
        if (!identical(_pingTimer, timer) || state != State.connected) {
          return;
        }
        await processDisconnect(code: connectingCodeNoPing, reason: 'no ping', reconnect: true);
      });
    });
    _pingTimer = timer;
  }

  void _refreshToken() async {
    if (_config.getToken == null) {
      return;
    }
    // A refresh belongs to the connection it started on: after a reconnect,
    // the new connection runs its own refresh chain.
    final attemptId = _connectAttemptId;
    bool isCurrentConnection() => attemptId == _connectAttemptId && state == State.connected;
    final String token;
    try {
      final event = ConnectionTokenEvent();
      token = await _config.getToken!(event);
    } catch (ex) {
      if (!isCurrentConnection()) {
        return;
      }
      if (ex is UnauthorizedException) {
        await _failUnauthorized();
        return;
      }
      final event = ErrorEvent(RefreshError(ex));
      _errorController.add(event);
      if (!isCurrentConnection()) {
        return;
      }
      _refreshTimer = Timer(backoffDelay(0, Duration(seconds: 5), Duration(seconds: 10)), () {
        if (state != State.connected) {
          return;
        }
        _refreshToken();
      });
      return;
    }

    if (!isCurrentConnection()) {
      return;
    }
    if (token == '') {
      // An empty token from getToken during refresh means the user is not
      // authenticated anymore, so disconnect instead of sending a token-less
      // RefreshRequest. Note this only applies to refresh - an empty token on
      // the initial connect still means "connect as anonymous".
      await _failUnauthorized();
      return;
    }
    _token = token;

    final request = protocol.RefreshRequest()..token = _token;

    try {
      final result = await _connectedTransport().sendMessage(
        request,
        protocol.RefreshResult(),
      );
      if (!isCurrentConnection()) {
        return;
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
      if (!isCurrentConnection()) {
        return;
      }
      final event = ErrorEvent(RefreshError(err));
      _errorController.add(event);
      if (!isCurrentConnection()) {
        return;
      }
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
        await _processDisconnect(code: err.code, reason: err.message, reconnect: false);
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

  /// Resolve a client-side subscription for a push: by numeric channel ID
  /// when channel compaction is in use (the push then has no channel name),
  /// by channel name otherwise.
  SubscriptionImpl? _subscriptionForPush(String channel, int id) {
    if (id > 0) {
      return _subscriptionsById[id];
    }
    return _subscriptions[channel];
  }

  void _handlePub(String channel, protocol.Publication pub, int id) {
    final subscription = _subscriptionForPush(channel, id);
    if (subscription != null) {
      subscription.handlePublication(pub);
      return;
    }
    final serverSubscription = _serverSubs[channel];
    // Not after a listener disconnected earlier in the same message.
    if (serverSubscription != null && state == State.connected) {
      final event = ServerPublicationEvent.from(channel, pub);
      _publicationController.add(event);
      if (serverSubscription.recoverable && pub.offset > 0) {
        serverSubscription.offset = pub.offset;
      }
    }
  }

  void _handleJoin(String channel, protocol.Join join, int id) {
    final subscription = _subscriptionForPush(channel, id);
    if (subscription != null) {
      subscription.handleJoin(join);
      return;
    }
    final serverSubscription = _serverSubs[channel];
    if (serverSubscription != null && state == State.connected) {
      final event = ServerJoinEvent.from(channel, join.info);
      _joinController.add(event);
    }
  }

  void _handleLeave(String channel, protocol.Leave leave, int id) {
    final subscription = _subscriptionForPush(channel, id);
    if (subscription != null) {
      subscription.handleLeave(leave);
      return;
    }
    final serverSubscription = _serverSubs[channel];
    if (serverSubscription != null && state == State.connected) {
      final event = ServerLeaveEvent.from(channel, leave.info);
      _leaveController.add(event);
    }
  }

  void _handleMessage(protocol.Message message) {
    final event = MessageEvent(message.data);
    _messageController.add(event);
  }

  Future<void> _handleDisconnect(protocol.Disconnect disconnect) async {
    final code = disconnect.code;
    final bool reconnect = code < 3500 || code >= 5000 || (code >= 4000 && code < 4500);
    await _processDisconnect(code: disconnect.code, reason: disconnect.reason, reconnect: reconnect);
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
      if (subscription.state != SubscriptionState.subscribed) {
        // It ends a previous subscription, e.g. one that raced unsubscribe()
        // and subscribe(): the server sends the push also for a channel the
        // connection isn't subscribed to, and unsubscribes a subscription in
        // progress only after replying to its subscribe. It must neither end
        // nor invalidate a subscribe in progress.
        return;
      }
      if (unsubscribe.code == 2502) {
        // State invalidated for this subscription: drop sub-level token and
        // recovery position so the resubscribe gets a fresh token and does
        // a full re-sync from the current head.
        subscription.invalidateState();
        subscription.moveToSubscribing(unsubscribe.code, unsubscribe.reason);
        subscription.resubscribeOnConnect();
        return;
      }
      if (unsubscribe.code < 2500) {
        subscription.moveToUnsubscribed(unsubscribe.code, unsubscribe.reason, false);
      } else {
        // Temporary server-side unsubscribe: client stays connected so we must
        // trigger a resubscribe immediately rather than waiting for a reconnect.
        subscription.moveToSubscribing(unsubscribe.code, unsubscribe.reason);
        subscription.resubscribeOnConnect();
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
      try {
        _transport?.sendAsyncMessage(
          protocol.Command(),
        );
      } on ClientDisconnectedError {
        // No need to handle in a special way - pong can't be sent but connection is closed anyway.
      }
    }
  }

  void _onPush(protocol.Push push, bool isPing) {
    if (isPing) {
      _onPing();
      return;
    }
    if (push.hasPub()) {
      _handlePub(push.channel, push.pub, push.id.toInt());
    } else if (push.hasJoin()) {
      _handleJoin(push.channel, push.join, push.id.toInt());
    } else if (push.hasLeave()) {
      _handleLeave(push.channel, push.leave, push.id.toInt());
    } else if (push.hasSubscribe()) {
      _handleSubscribe(push.channel, push.subscribe);
    } else if (push.hasUnsubscribe()) {
      _handleUnsubscribe(push.channel, push.unsubscribe);
    } else if (push.hasMessage()) {
      _handleMessage(push.message);
    } else if (push.hasDisconnect()) {
      // Fire-and-forget: state changes inside _processDisconnect happen
      // synchronously; only transport.close() runs detached. The websocket
      // onDone callback that follows the server-initiated close is idempotent.
      _handleDisconnect(push.disconnect);
    }
  }

  /// Update the channel compaction registry for [subscription]: remove the
  /// old numeric ID mapping (if it still points to this subscription) and
  /// register the new one. Either ID may be 0 meaning "no mapping".
  @internal
  void updateSubscriptionPushId(SubscriptionImpl subscription, int oldId, int newId) {
    if (oldId > 0 && identical(_subscriptionsById[oldId], subscription)) {
      _subscriptionsById.remove(oldId);
    }
    if (newId > 0) {
      _subscriptionsById[newId] = subscription;
    }
  }

  @internal
  Future<protocol.UnsubscribeResult> sendUnsubscribe(protocol.UnsubscribeRequest request) async {
    if (_transport == null) {
      throw ClientDisconnectedError();
    }
    return await _connectedTransport().sendMessage(
      request,
      protocol.UnsubscribeResult(),
    );
  }

  @internal
  Future<protocol.SubscribeResult> sendSubscribe(protocol.SubscribeRequest request) async {
    if (_transport == null) {
      throw ClientDisconnectedError();
    }
    return await _connectedTransport().sendMessage(
      request,
      protocol.SubscribeResult(),
    );
  }

  @internal
  Future<protocol.SubRefreshResult> sendSubRefresh(protocol.SubRefreshRequest request) async {
    if (_transport == null) {
      throw ClientDisconnectedError();
    }
    return await _connectedTransport().sendMessage(
      request,
      protocol.SubRefreshResult(),
    );
  }

  @internal
  Future<void> processDisconnect(
      {required int code, required String reason, required bool reconnect}) {
    return _processDisconnect(code: code, reason: reason, reconnect: reconnect);
  }
}

final _random = new Random();

Duration backoffDelay(int step, Duration minDelay, Duration maxDelay) {
  // Full jitter technique.
  // https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/
  if (step > 31) {
    step = 31;
  } // Avoid RangeError.
  final val = min(maxDelay.inMilliseconds, minDelay.inMilliseconds * pow(2, step));
  if (val.toInt() <= 0) return minDelay;
  final interval = _random.nextInt(val.toInt());
  final milliseconds = min(maxDelay.inMilliseconds, minDelay.inMilliseconds + interval);
  return Duration(milliseconds: milliseconds);
}
