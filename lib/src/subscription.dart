import 'dart:async';

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:meta/meta.dart';

import 'client.dart';
import 'codes.dart';
import 'error.dart';
import 'events.dart';
import 'proto/client.pb.dart' as protocol;
import 'subscription_config.dart';

enum SubscriptionState { unsubscribed, subscribing, subscribed }

abstract class Subscription {
  String get channel;

  Stream<SubscribingEvent> get subscribing;
  Stream<SubscribedEvent> get subscribed;
  Stream<UnsubscribedEvent> get unsubscribed;

  Stream<SubscriptionErrorEvent> get error;

  Stream<PublicationEvent> get publication;
  Stream<JoinEvent> get join;
  Stream<LeaveEvent> get leave;

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
  bool _positioned = false;
  bool _recoverable = false;
  bool _joinLeave = false;

  SubscriptionImpl(this.channel, this._client, this._config) {
    _token = _config.token;
    _data = _config.data;
    _positioned = _config.positioned;
    _recoverable = _config.recoverable;
    _joinLeave = _config.joinLeave;
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
  final _subscribingController = StreamController<SubscribingEvent>.broadcast(sync: true);
  final _subscribedController = StreamController<SubscribedEvent>.broadcast(sync: true);
  final _unsubscribedController = StreamController<UnsubscribedEvent>.broadcast(sync: true);
  final _errorController = StreamController<SubscriptionErrorEvent>.broadcast(sync: true);

  final _readyFutures = <Completer<void>>[];

  @override
  Stream<PublicationEvent> get publication => _publicationController.stream;

  @override
  Stream<JoinEvent> get join => _joinController.stream;

  @override
  Stream<LeaveEvent> get leave => _leaveController.stream;

  @override
  Stream<SubscribingEvent> get subscribing => _subscribingController.stream;

  @override
  Stream<SubscribedEvent> get subscribed => _subscribedController.stream;

  @override
  Stream<UnsubscribedEvent> get unsubscribed => _unsubscribedController.stream;

  @override
  Stream<SubscriptionErrorEvent> get error => _errorController.stream;

  @override
  Future<void> subscribe() async {
    if (state == SubscriptionState.subscribed) {
      return;
    }
    if (state == SubscriptionState.subscribing) {
      throw SubscriptionSubscribingError();
    }
    _resubscribeAttempts = 0;
    state = SubscriptionState.subscribing;
    final event = SubscribingEvent(subscribingCodeSubscribeCalled, 'subscribe called');
    _subscribingController.add(event);
    await _subscribe();
  }

  @override
  Future<void> unsubscribe() async {
    return moveToUnsubscribed(unsubscribedCodeUnsubscribeCalled, 'unsubscribe called', true);
  }

  @internal
  Future<void> moveToUnsubscribed(int code, String reason, bool sendUnsubscribe) async {
    if (state == SubscriptionState.unsubscribed) {
      return;
    }
    _resubscribeTimer?.cancel();
    final prevState = state;
    state = SubscriptionState.unsubscribed;
    _errorReadyFutures(SubscriptionUnsubscribedError());
    if (prevState == SubscriptionState.subscribed) {
      _clearSubscribedState();
    }
    if (sendUnsubscribe && prevState == SubscriptionState.subscribed && _client.state == State.connected) {
      try {
        await _client.sendUnsubscribe(protocol.UnsubscribeRequest()..channel = channel);
      } on Exception {
        _client.processDisconnect(
            code: connectingCodeUnsubscribeError, reason: 'unsubscribe error', reconnect: true);
        _client.closeTransport();
        return;
      }
    }
    _addUnsubscribe(UnsubscribedEvent(code, reason));
  }

  @override
  Future<void> ready() {
    if (state == SubscriptionState.subscribed) {
      return Future.value();
    }
    if (state != SubscriptionState.subscribing) {
      throw SubscriptionUnsubscribedError();
    }
    final completer = new Completer<void>();
    _readyFutures.add(completer);
    return completer.future;
  }

  @override
  Future<PublishResult> publish(List<int> data) async {
    await ready().timeout(_client.config.timeout);
    return _client.publish(channel, data);
  }

  @override
  Future<HistoryResult> history({int limit = 0, StreamPosition? since, bool reverse = false}) async {
    await ready().timeout(_client.config.timeout);
    return _client.history(channel, limit: limit, since: since, reverse: reverse);
  }

  @override
  Future<PresenceResult> presence() async {
    await ready().timeout(_client.config.timeout);
    return _client.presence(channel);
  }

  @override
  Future<PresenceStatsResult> presenceStats() async {
    await ready().timeout(_client.config.timeout);
    return _client.presenceStats(channel);
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

  void _clearSubscribedState() {
    _refreshTimer?.cancel();
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

  void _addUnsubscribe(UnsubscribedEvent event) => _unsubscribedController.add(event);

  void _addSubscribing(SubscribingEvent event) => _subscribingController.add(event);

  void _refreshToken() async {
    try {
      final event = SubscriptionTokenEvent(channel);
      final String token = await _config.getToken!(event);
      if (token == "") {
        _failUnauthorized();
        return;
      }
      _token = token;
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
        moveToUnsubscribed(err.code, err.message, true);
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
      if (token == null && _config.getToken != null) {
        final event = SubscriptionTokenEvent(channel);
        token = await _config.getToken!(event);
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
      request.positioned = _positioned;
      request.recoverable = _recoverable;
      request.joinLeave = _joinLeave;
      final result = await _client.sendSubscribe(request);
      if (result.recoverable) {
        _recover = true;
        _epoch = result.epoch;
        _offset = result.offset;
      }
      final event = SubscribedEvent.from(result);
      state = SubscriptionState.subscribed;
      _subscribedController.add(event);
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
      if (result.publications.isNotEmpty) {
        for (protocol.Publication pub in result.publications) {
          handlePublication(pub);
        }
      }
    } on TimeoutException {
      _client.processDisconnect(
          code: connectingCodeSubscribeTimeout, reason: 'subscribe timeout', reconnect: true);
      _client.closeTransport();
      return;
    } catch (err) {
      if (state != SubscriptionState.subscribing || _client.state != State.connected) {
        return;
      }
      final event = SubscriptionErrorEvent(SubscriptionSubscribeError(err));
      _errorController.add(event);
      if (err is Error) {
        if (err.code == 109 || err.temporary) {
          if (err.code == 109) {
            // Token expired error.
            _token = null;
          }
          _scheduleResubscribe();
          return;
        } else {
          moveToUnsubscribed(err.code, err.message, false);
          return;
        }
      }
      _scheduleResubscribe();
      return;
    }
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

  void _failUnauthorized() {
    moveToUnsubscribed(unsubscribedCodeUnauthorized, 'unauthorized', true);
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

  @internal
  void resubscribeOnConnect() {
    if (state != SubscriptionState.subscribing) {
      return;
    }
    _resubscribe();
  }

  @internal
  void moveToSubscribing(int code, String reason) {
    _resubscribeTimer?.cancel();
    if (state != SubscriptionState.subscribed) {
      return;
    }
    _clearSubscribedState();
    state = SubscriptionState.subscribing;
    final event = SubscribingEvent(code, reason);
    _addSubscribing(event);
  }
}
