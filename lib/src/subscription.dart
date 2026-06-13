import 'dart:async';
import 'dart:typed_data';

import 'package:centrifuge/src/fossil.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:meta/meta.dart';

import 'client.dart';
import 'codes.dart';
import 'error.dart';
import 'events.dart';
import 'filter.dart';
import 'proto/client.pb.dart' as protocol;
import 'subscription_config.dart';

enum SubscriptionState { unsubscribed, subscribing, subscribed }

abstract class Subscription {
  String get channel;

  SubscriptionState get state;

  Stream<SubscribingEvent> get subscribing;
  Stream<SubscribedEvent> get subscribed;
  Stream<UnsubscribedEvent> get unsubscribed;

  Stream<SubscriptionErrorEvent> get error;

  Stream<PublicationEvent> get publication;
  Stream<JoinEvent> get join;
  Stream<LeaveEvent> get leave;

  Future<void> subscribe();
  Future<void> unsubscribe();

  /// Sets the server-side publication tags filter. Applied on the next
  /// subscribe attempt, not the current one. Pass null to clear it. Cannot be
  /// combined with delta compression. Build with the [Filter] helpers.
  void setTagsFilter(FilterNode? tagsFilter);

  Future<PublishResult> publish(List<int> data);
  Future<PresenceResult> presence();
  Future<PresenceStatsResult> presenceStats();
  Future<HistoryResult> history({int limit = 0, StreamPosition? since, bool reverse = false});

  /// Ready resolves when subscription successfully subscribed.
  /// Throws exceptions if called not in subscribing or subscribed state.
  Future<void> ready();
}

class SubscriptionImpl implements Subscription {
  String _token = '';
  List<int>? _data;
  FilterNode? _tagsFilter;
  Timer? _refreshTimer;
  Timer? _resubscribeTimer;
  int _resubscribeAttempts = 0;
  bool _recover = false;
  $fixnum.Int64? _offset;
  String? _epoch;
  bool _positioned = false;
  bool _recoverable = false;
  bool _joinLeave = false;
  bool _deltaNegotiated = false;
  List<int>? _prevData;
  // Numeric channel ID assigned by the server when channel compaction is
  // negotiated. Pushes then carry this ID instead of the channel name.
  int _pushId = 0;
  // True while a SubscribeRequest is on the wire awaiting a reply. Used by
  // moveToUnsubscribed to decide whether the server-side subscription needs
  // an explicit cleanup UnsubscribeRequest if the user cancels mid-flight.
  bool _inflight = false;
  bool _resubscribing = false;
  bool _closed = false;

  SubscriptionImpl(this.channel, this._client, this._config) {
    _token = _config.token;
    _data = _config.data;
    _tagsFilter = _config.tagsFilter;
    _positioned = _config.positioned;
    _recoverable = _config.recoverable;
    _joinLeave = _config.joinLeave;
    if (_config.since != null) {
      _recover = true;
      _offset = _config.since!.offset;
      _epoch = _config.since!.epoch;
    }
  }

  @override
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
    if (_closed) {
      throw ClientClosedError();
    }
    if (state == SubscriptionState.subscribed) {
      return;
    }
    if (state == SubscriptionState.subscribing) {
      return ready();
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

  @override
  void setTagsFilter(FilterNode? tagsFilter) {
    if (tagsFilter != null && _config.delta == DeltaType.fossil) {
      throw ArgumentError('cannot use delta and tagsFilter together');
    }
    _tagsFilter = tagsFilter;
  }

  @internal
  void close() {
    _closed = true;
    _setPushId(0);
    _resubscribeTimer?.cancel();
    _refreshTimer?.cancel();
    _errorReadyFutures(SubscriptionUnsubscribedError());
    state = SubscriptionState.unsubscribed;
    _publicationController.close();
    _joinController.close();
    _leaveController.close();
    _unsubscribedController.close();
    _errorController.close();
    _subscribedController.close();
    _subscribingController.close();
  }

  /// Drop all per-subscription state that depends on the server having a
  /// matching session: token, recovery position, and delta baseline. The
  /// next subscribe will re-fetch a fresh token and do a full re-sync.
  /// Used when the server signals state invalidation (e.g. unsubscribe code
  /// 2502 for this channel, or disconnect code 3014 at the connection level).
  @internal
  void invalidateState() {
    _token = '';
    _offset = null;
    _epoch = null;
    _recover = false;
    _prevData = null;
    _setPushId(0);
  }

  @internal
  Future<void> moveToUnsubscribed(int code, String reason, bool sendUnsubscribe) async {
    if (state == SubscriptionState.unsubscribed) {
      return;
    }
    _resubscribeTimer?.cancel();
    final prevState = state;
    final wasInflight = _inflight;
    _inflight = false;
    state = SubscriptionState.unsubscribed;
    _setPushId(0);
    _errorReadyFutures(SubscriptionUnsubscribedError());
    if (prevState == SubscriptionState.subscribed) {
      _clearSubscribedState();
    }
    // Send a cleanup Unsubscribe to the server when:
    //   - we were Subscribed (the normal case), or
    //   - we were Subscribing AND a SubscribeRequest is currently in flight,
    //     because the server may already have created (or be about to create)
    //     a subscription from that request and would otherwise keep pushing
    //     publications to a sub that the client has cancelled.
    final shouldSend = sendUnsubscribe &&
        _client.state == State.connected &&
        (prevState == SubscriptionState.subscribed ||
            (prevState == SubscriptionState.subscribing && wasInflight));
    if (shouldSend) {
      try {
        await _client.sendUnsubscribe(protocol.UnsubscribeRequest()..channel = channel);
      } catch (_) {
        // Sub was Subscribed and the cleanup Unsubscribe failed — connection
        // and server-side state may have diverged, so trigger a reconnect to
        // resync. For the inflight-cancel case (was Subscribing) we let it
        // slide: if the server-side sub was created at all, the server will
        // tear it down on the next disconnect or treat any stray pubs as
        // unknown channels.
        if (prevState == SubscriptionState.subscribed) {
          await _client.processDisconnect(
              code: connectingCodeUnsubscribeError, reason: 'unsubscribe error', reconnect: true);
          await _client.closeTransport();
          _addUnsubscribe(UnsubscribedEvent(code, reason));
          return;
        }
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

  void _addUnsubscribe(UnsubscribedEvent event) {
    if (!_closed) _unsubscribedController.add(event);
  }

  /// Update the channel compaction ID registration in the client's push
  /// routing registry. Pass 0 to clear (no compaction / sub gone).
  ///
  /// Always re-registers even when the ID is unchanged: the client drops the
  /// whole registry on disconnect, and on reconnect the server commonly
  /// assigns the same ID again — the registration must be restored.
  void _setPushId(int id) {
    if (id == 0 && _pushId == 0) return;
    _client.updateSubscriptionPushId(this, _pushId, id);
    _pushId = id;
  }

  void _addSubscribing(SubscribingEvent event) => _subscribingController.add(event);

  void _refreshToken() async {
    try {
      final event = SubscriptionTokenEvent(channel);
      final String token = await _config.getToken!(event);
      _token = token;
    } catch (ex) {
      if (state != SubscriptionState.subscribed) {
        return;
      }
      if (ex is UnauthorizedException) {
        _failUnauthorized();
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
        ..token = _token;
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
    if (_resubscribing) return;
    _resubscribing = true;
    try {
      // getState: ask the app for its current state position. Only called
      // when we don't have a saved position (first subscribe or after a
      // position reset due to unrecoverable position error 112). On normal
      // reconnects with a valid saved position we skip getState and let the
      // server try recovery — getState is only called again if recovery fails.
      if (_config.getState != null && _offset == null) {
        final StreamPosition position;
        try {
          position = await _config.getState!();
        } catch (err) {
          if (state != SubscriptionState.subscribing || _client.state != State.connected) {
            return;
          }
          final event = SubscriptionErrorEvent(SubscriptionGetStateError(err));
          _errorController.add(event);
          _scheduleResubscribe();
          return;
        }
        if (state != SubscriptionState.subscribing) {
          // unsubscribe() arrived during the getState await.
          return;
        }
        _offset = position.offset;
        _epoch = position.epoch;
        _recover = true;
        if (_client.state != State.connected) {
          // disconnect() arrived during the getState await. Keep the loaded
          // position (matches centrifuge-js/-go): the resubscribe on reconnect
          // recovers from it instead of calling getState again.
          return;
        }
      }
      var token = _token;
      if (token == '' && _config.getToken != null) {
        final event = SubscriptionTokenEvent(channel);
        token = await _config.getToken!(event);
        if (token == "") {
          _failUnauthorized();
          return;
        }
        _token = token;
      }
      if (state != SubscriptionState.subscribing || _client.state != State.connected) {
        // unsubscribe() or disconnect() arrived during the getToken await.
        return;
      }
      final request = protocol.SubscribeRequest()
        ..channel = channel
        ..token = token;
      if (_data != null) {
        request..data = _data!;
      }
      if (_recover && _offset != null && _epoch != null) {
        request.recover = true;
        request.offset = _offset!;
        request.epoch = _epoch!;
      }
      if (_config.delta == DeltaType.fossil) {
        request.delta = "fossil";
      }
      if (_tagsFilter != null) {
        request.tf = _tagsFilter!.proto;
      }
      request.positioned = _positioned;
      request.recoverable = _recoverable;
      request.joinLeave = _joinLeave;
      // Always offer channel compaction: when the server supports and allows
      // it, the subscribe result carries a numeric channel ID and subsequent
      // pushes use that ID instead of the string channel name.
      var flag = subscriptionFlagChannelCompaction;
      if (_config.getState != null) {
        // Ask the server to reject the subscribe with error 112 when recovery
        // from the provided position is impossible, instead of returning
        // recovered=false — so we can call getState again to reload state.
        flag |= subscriptionFlagRejectUnrecovered;
      }
      request.flag = $fixnum.Int64(flag);
      _inflight = true;
      final protocol.SubscribeResult result;
      try {
        result = await _client.sendSubscribe(request);
      } finally {
        _inflight = false;
      }
      if (state != SubscriptionState.subscribing || _client.state != State.connected) {
        // Concurrent unsubscribe / disconnect happened while we were awaiting
        // the subscribe reply. moveToUnsubscribed already sent a cleanup
        // Unsubscribe to the server (it saw _inflight=true), so the server
        // won't keep this sub around. Drop the result on the floor.
        return;
      }
      if (result.recoverable) {
        _recover = true;
        _epoch = result.epoch;
        _offset = result.offset;
      }
      _deltaNegotiated = result.delta;
      // Channel compaction: register the numeric channel ID assigned by the
      // server (0 when not negotiated — also clears a stale ID from a
      // previous subscribe session).
      _setPushId(result.id.toInt());
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
      await _client.processDisconnect(
          code: connectingCodeSubscribeTimeout, reason: 'subscribe timeout', reconnect: true);
      await _client.closeTransport();
      return;
    } catch (err) {
      if (state != SubscriptionState.subscribing || _client.state != State.connected) {
        return;
      }
      if (err is UnauthorizedException) {
        _failUnauthorized();
        return;
      }
      if (err is Error && err.code == errorCodeUnrecoverablePosition && _config.getState != null) {
        // Unrecoverable position with getState: reset position so the next
        // subscribe attempt calls getState() to reload app state from scratch.
        _offset = null;
        _epoch = null;
        _recover = false;
        _prevData = null;
        _scheduleResubscribe();
        return;
      }
      final event = SubscriptionErrorEvent(SubscriptionSubscribeError(err));
      _errorController.add(event);
      if (err is Error) {
        if (err.code == 109 || err.temporary) {
          if (err.code == 109) {
            // Token expired error.
            _token = '';
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
    } finally {
      _resubscribing = false;
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
    var event = PublicationEvent.from(pub);
    if (_deltaNegotiated) {
      if (pub.delta) {
        final newData = applyDelta(Uint8List.fromList(_prevData!), Uint8List.fromList(pub.data));
        event = event.copyWith(data: newData);
      }
      _prevData = event.data;
    }
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
