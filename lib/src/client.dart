import 'dart:async';

import 'package:centrifuge/src/transport.dart';
import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart';

import 'client_config.dart';
import 'error.dart' as errors;
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
  Future<void> connect();

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
  Future<void> disconnect();

  /// Start collecting private channels to create bulk authentication
  /// Call config.onPrivateSub when stopSubscribeBatching will be called
  void startSubscribeBatching();

  /// Call config.onPrivateSub with collected private channels
  /// to ask if this client can subscribe on each channel
  Future<void> stopSubscribeBatching();

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

  Transport _transport;
  String _token;

  final _privateChannels = <String>{};
  Set<String> get privateChannels => _privateChannels;

  bool _isSubscribeBatching = false;
  bool get isSubscribeBatching => _isSubscribeBatching;

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
  Future<void> connect() async => _connect();

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

    await _transport.sendMessages([
      TransportMessage(
        req: request,
        res: PublishResult(),
      ),
    ]);
  }

  @override
  Future<RPCResult> rpc(List<int> data) async {
    final result = await _transport.sendMessages([
      TransportMessage(
        req: RPCRequest()..data = data,
        res: RPCResult(),
      ),
    ]);
    return result[0];
  }

  @override
  @alwaysThrows
  Future<void> send(List<int> data) async {
    throw UnimplementedError;
  }

  @override
  Future<void> disconnect() async {
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
      return _subscriptions[channel];
    }

    final subscription = SubscriptionImpl(channel, this);

    _subscriptions[channel] = subscription;

    return subscription;
  }

  @override
  Future<void> removeSubscription(Subscription subscription) async {
    if (subscription != null) {
      final String channel = subscription.channel;
      subscription.unsubscribe();
      _subscriptions.remove(channel);
    }
  }

  Future<UnsubscribeEvent> unsubscribe(String channel) async {
    final request = UnsubscribeRequest()..channel = channel;
    await _transport.sendMessages([
      TransportMessage(
        req: request,
        res: UnsubscribeResult(),
      )
    ]);
    return UnsubscribeEvent();
  }

  @override
  Future<List<Res>>
      sendMessages<Req extends GeneratedMessage, Res extends GeneratedMessage>(
              List<TransportMessage<Req, Res>> messages) =>
          _transport.sendMessages(messages);

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

      final result = await _transport.sendMessages([
        TransportMessage(
          req: request,
          res: ConnectResult(),
        )
      ]);

      _clientID = result[0].client;
      _retryCount = 0;
      _state = _ClientState.connected;
      _connectController.add(ConnectEvent.from(result[0]));

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
        if (subscription != null) {
          subscription.addPublish(event);
        }
        break;
      case PushType.LEAVE:
        final leave = Leave.fromBuffer(push.data);
        final event = LeaveEvent.from(leave.info);
        final subscription = _subscriptions[push.channel];
        if (subscription != null) {
          subscription.addLeave(event);
        }
        break;
      case PushType.JOIN:
        final join = Join.fromBuffer(push.data);
        final event = JoinEvent.from(join.info);
        final subscription = _subscriptions[push.channel];
        if (subscription != null) {
          subscription.addJoin(event);
        }
        break;
      case PushType.MESSAGE:
        final message = Message.fromBuffer(push.data);
        final event = MessageEvent(message.data);

        _messageController.add(event);
        break;
      case PushType.UNSUB:
        final event = UnsubscribeEvent();
        final subscription = _subscriptions[push.channel];
        if (subscription != null) {
          subscription.addUnsubscribe(event);
        }
        break;
    }
  }

  @override
  void startSubscribeBatching() {
    _isSubscribeBatching = true;
  }

  @override
  Future<void> stopSubscribeBatching() async {
    _isSubscribeBatching = false;
    final authChannels = _privateChannels.toList();
    _privateChannels.clear();

    final event = PrivateSubEvent(_clientID, authChannels);
    final sign = await _onPrivateSub(event);

    final messages = <TransportMessage>[];
    for (final ch in sign.channels) {
      final req = SubscribeRequest()
        ..channel = ch.channel
        ..token = ch.token;

      final SubscriptionImpl sub = getSubscription(ch.channel);

      final msg = TransportMessage(
        req: req,
        res: SubscribeResult(),
        onError: (code, message) {
          sub.onSubscribeError(SubscribeErrorEvent(message, code));
        },
      );

      messages.add(msg);
    }

    try {
      final replies = await _transport.sendMessages(messages);
      for (var i = 0; i < authChannels.length; i++) {
        final result = replies[i];
        if (result == null) {
          continue;
        }
        final event = SubscribeSuccessEvent.from(result, false);
        final channel = authChannels[i];
        final SubscriptionImpl sub = getSubscription(channel);
        sub.onSubscribeSuccess(event);
        sub.recover(result);
      }
    } catch (exception) {
      print(exception);
    }
  }

  Future<PrivateSubSign> _onPrivateSub(PrivateSubEvent event) =>
      _config.onPrivateSub(event);
}

enum _ClientState { connected, disconnected, connecting }
