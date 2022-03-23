import 'dart:async';

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:meta/meta.dart';

import 'client.dart';
import 'error.dart';
import 'events.dart';
import 'proto/client.pb.dart' as protocol;
import 'subscription_config.dart';

enum SubscriptionState { unsubscribed, subscribing, subscribed, failed }

enum SubscriptionFailReason { clientFailed, subscribeFailed, refreshFailed, unauthorized, unrecoverable }

abstract class Subscription {
  String get channel;

  Stream<SubscribeEvent> get subscribeStream;
  Stream<UnsubscribeEvent> get unsubscribeStream;
  Stream<SubscriptionFailEvent> get failStream;
  Stream<PublicationEvent> get publicationStream;
  Stream<JoinEvent> get joinStream;
  Stream<LeaveEvent> get leaveStream;
  Stream<SubscriptionErrorEvent> get errorStream;

  Future<void> subscribe();
  Future<void> unsubscribe();

  Future<PublishResult> publish(List<int> data);
  Future<PresenceResult> presence();
  Future<PresenceStatsResult> presenceStats();
  Future<HistoryResult> history({int limit = 0, StreamPosition? since, bool reverse = false});

  /// Ready resolves when subscription successfully subscribed.
  /// Throws exceptions if called not in subscribing or suscribed state.
  Future<void> ready();
}

class SubscriptionImpl implements Subscription {
  String? _token;
  List<int>? _data;
  Timer? _refreshTimer;
  Timer? _resubscribeTimer;
  int _resubscribeAttempts = 0;
  bool _recover = false;
  $fixnum.Int64? _offset;
  String? _epoch;

  SubscriptionImpl(this.channel, this._client, this._config) {
    _token = _config.token;
    _data = _config.data;
    if (_config.since != null) {
      _recover = true;
      _offset = _config.since!.offset;
      _epoch = _config.since!.epoch;
    }
  }

  var state = SubscriptionState.unsubscribed;

  @override
  final String channel;
  final ClientImpl _client;
  final SubscriptionConfig _config;

  final _publicationController = StreamController<PublicationEvent>.broadcast(sync: true);
  final _joinController = StreamController<JoinEvent>.broadcast(sync: true);
  final _leaveController = StreamController<LeaveEvent>.broadcast(sync: true);
  final _subscribeController = StreamController<SubscribeEvent>.broadcast(sync: true);
  final _errorController = StreamController<SubscriptionErrorEvent>.broadcast(sync: true);
  final _unsubscribeController = StreamController<UnsubscribeEvent>.broadcast(sync: true);
  final _failController = StreamController<SubscriptionFailEvent>.broadcast(sync: true);

  final _readyFutures = <Completer<void>>[];

  @override
  Stream<PublicationEvent> get publicationStream => _publicationController.stream;

  @override
  Stream<JoinEvent> get joinStream => _joinController.stream;

  @override
  Stream<LeaveEvent> get leaveStream => _leaveController.stream;

  @override
  Stream<SubscribeEvent> get subscribeStream => _subscribeController.stream;

  @override
  Stream<SubscriptionErrorEvent> get errorStream => _errorController.stream;

  @override
  Stream<UnsubscribeEvent> get unsubscribeStream => _unsubscribeController.stream;

  @override
  Stream<SubscriptionFailEvent> get failStream => _failController.stream;

  @override
  Future<PublishResult> publish(List<int> data) => _client.publish(channel, data);

  @override
  Future<void> ready() {
    if (state == SubscriptionState.subscribed) {
      return Future.value();
    }
    if (state != SubscriptionState.subscribing) {
      if (state == SubscriptionState.unsubscribed) {
        throw SubscriptionUnsubscribedError();
      }
      throw SubscriptionFailedError();
    }
    final completer = new Completer<void>();
    _readyFutures.add(completer);
    return completer.future;
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

  @override
  Future<void> subscribe() async {
    if (state == SubscriptionState.subscribed) {
      return;
    }
    if (state == SubscriptionState.subscribing) {
      throw SubscriptionSubscribingError();
    }
    state = SubscriptionState.subscribing;
    await _subscribe();
  }

  Future<void> _subscribe() async {
    if (state != SubscriptionState.subscribing) {
      return;
    }
    if (_client.state != State.connected) {
      return;
    }
    await _resubscribe();
  }

  void resubscribeOnConnect() {
    if (state != SubscriptionState.subscribing) {
      return;
    }
    _resubscribe();
  }

  void _clearSuscribedState() {
    _refreshTimer?.cancel();
  }

  @override
  Future<void> unsubscribe() async {
    _resubscribeTimer?.cancel();
    final prevState = state;
    state = SubscriptionState.unsubscribed;
    _errorReadyFutures(SubscriptionUnsubscribedError());
    if (prevState == SubscriptionState.subscribed) {
      _clearSuscribedState();
    }
    if (prevState != SubscriptionState.subscribed) {
      return;
    }
    if (_client.state != State.connected) {
      addUnsubscribe(UnsubscribeEvent());
      return;
    }
    await _client.sendUnsubscribe(channel);
    addUnsubscribe(UnsubscribeEvent());
  }

  void unsubscribeOnDisconnect() {
    _resubscribeTimer?.cancel();
    if (state != SubscriptionState.subscribed) {
      return;
    }
    _clearSuscribedState();
    state = SubscriptionState.subscribing;
    final event = UnsubscribeEvent();
    addUnsubscribe(event);
  }

  @override
  Future<HistoryResult> history({int limit = 0, StreamPosition? since, bool reverse = false}) =>
      _client.history(channel, limit: limit, since: since, reverse: reverse);

  @override
  Future<PresenceResult> presence() => _client.presence(channel);

  @override
  Future<PresenceStatsResult> presenceStats() => _client.presenceStats(channel);

  void _addSubscribe(SubscribeEvent event) {
    _subscribeController.add(event);
  }

  void addUnsubscribe(UnsubscribeEvent event) => _unsubscribeController.add(event);

  void _refreshToken() async {
    final String? clientId = _client.client;
    if (clientId == null) {
      return;
    }
    try {
      final event = SubscriptionTokenEvent(clientId, channel);
      final String token = await _client.config.onSubscriptionToken(event);
      if (token == "") {
        _failUnauthorized();
        return;
      }
      if (!_config.tokenUniquePerConnection) {
        _token = token;
      }
    } catch (ex) {
      if (state != SubscriptionState.subscribed) {
        return;
      }
      final event = SubscriptionErrorEvent(SubscriptionRefreshError(ex));
      _errorController.add(event);
      _refreshTimer = Timer(backoffDelay(0, Duration(seconds: 5), Duration(seconds: 10)), () {
        if (state != SubscriptionState.subscribed) {
          return;
        }
        _refreshToken();
      });
      return;
    }

    try {
      final request = protocol.SubRefreshRequest()
        ..channel = channel
        ..token = _token ?? '';
      final result = await _client.sendSubRefresh(request);
      if (result.expires) {
        _refreshTimer = Timer(Duration(seconds: result.ttl), () {
          if (state != SubscriptionState.subscribed) {
            return;
          }
          _refreshToken();
        });
      }
    } catch (err) {
      if (state != SubscriptionState.subscribed) {
        return;
      }
      final event = SubscriptionErrorEvent(SubscriptionRefreshError(err));
      _errorController.add(event);
      if (err is Error) {
        if (err.temporary) {
          _refreshTimer = Timer(backoffDelay(0, Duration(seconds: 5), Duration(seconds: 10)), () {
            if (state != SubscriptionState.subscribed) {
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
        if (state != SubscriptionState.subscribed) {
          return;
        }
        _refreshToken();
      });
    }
  }

  Future _resubscribe() async {
    try {
      var token = _token;
      if (token == null && _client.isPrivateChannel(channel)) {
        final event = SubscriptionTokenEvent(_client.client!, channel);
        token = await _client.config.onSubscriptionToken(event);
        if (token == "") {
          _failUnauthorized();
          return;
        }
        _token = token;
      }
      final request = protocol.SubscribeRequest()
        ..channel = channel
        ..token = token ?? '';
      if (_data != null) {
        request..data = _data!;
      }
      if (_recover && _offset != null && _epoch != null) {
        request.recover = true;
        request.offset = _offset!;
        request.epoch = _epoch!;
      }
      final result = await _client.sendSubscribe(request);
      final event = SubscribeEvent.from(result);
      state = SubscriptionState.subscribed;
      _addSubscribe(event);
      _completeReadyFutures();
      _resubscribeAttempts = 0;
      if (result.expires) {
        _refreshTimer = Timer(Duration(seconds: result.ttl), () {
          if (state != SubscriptionState.subscribed) {
            return;
          }
          _refreshToken();
        });
      }
      _recoverPublications(result);
    } on TimeoutException {
      _client.processDisconnect(code: 10, reason: 'subscribe timeout', reconnect: true);
      _client.closeTransport();
      return;
    } catch (err) {
      if (state != SubscriptionState.subscribing || _client.state != State.connected) {
        return;
      }
      final event = SubscriptionErrorEvent(SubscriptionSubscribeError(err));
      _errorController.add(event);
      if (err is Error) {
        if (err.code == 112) {
          _clearPositionState();
          _failUnrecoverable();
          return;
        } else if (err.code == 109 || err.temporary) {
          if (err.code == 109) {
            // Token expired error.
            _token = null;
          }
          _scheduleResubscribe();
          return;
        } else {
          _subscribeFailed();
          return;
        }
      }
      _scheduleResubscribe();
      return;
    }
  }

  void _recoverPublications(protocol.SubscribeResult result) {
    if (result.recoverable) {
      _recover = true;
    }
    if (result.publications.isNotEmpty) {
      for (protocol.Publication pub in result.publications) {
        handlePublication(pub);
      }
    } else {
      _offset = result.offset;
    }
    _epoch = result.epoch;
  }

  void _fail(SubscriptionFailReason reason) async {
    unsubscribe();
    state = SubscriptionState.failed;
    final event = SubscriptionFailEvent(reason);
    _failController.add(event);
  }

  void _subscribeFailed() {
    _fail(SubscriptionFailReason.subscribeFailed);
  }

  void _refreshFailed() {
    _fail(SubscriptionFailReason.refreshFailed);
  }

  void _failUnauthorized() {
    _fail(SubscriptionFailReason.unauthorized);
  }

  void _failUnrecoverable() {
    _clearPositionState();
    _fail(SubscriptionFailReason.unrecoverable);
  }

  @internal
  void failUnrecoverable() {
    _failUnrecoverable();
  }

  @internal
  void failClient() {
    _failClient();
  }

  void _failClient() {
    _fail(SubscriptionFailReason.clientFailed);
  }

  void _scheduleResubscribe() {
    final Duration delay =
        backoffDelay(_resubscribeAttempts, _config.minResubscribeDelay, _config.maxResubscribeDelay);
    _resubscribeTimer = Timer(delay, () {
      if (state != SubscriptionState.subscribing) {
        return;
      }
      _subscribe();
    });
    _resubscribeAttempts++;
  }

  void _clearPositionState() {
    _recover = false;
    _offset = null;
    _epoch = null;
  }

  @internal
  void handlePublication(protocol.Publication pub) {
    final event = PublicationEvent.from(pub);
    _publicationController.add(event);
    if (pub.offset > 0) {
      _offset = pub.offset;
    }
  }

  @internal
  void handleJoin(protocol.Join join) {
    final event = JoinEvent.from(join.info);
    _joinController.add(event);
  }

  @internal
  void handleLeave(protocol.Leave leave) {
    final event = LeaveEvent.from(leave.info);
    _leaveController.add(event);
  }
}
