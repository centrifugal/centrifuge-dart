import 'dart:async';
import 'dart:typed_data';

import 'package:centrifuge/src/fossil.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:meta/meta.dart';

import 'client.dart';
import 'codes.dart';
import 'error.dart';
import 'event_controller.dart';
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
  // Identifies the current subscribe attempt and subscribed session. Bumped by
  // unsubscribe and when leaving subscribed, so an attempt still waiting for
  // getState, getToken or its subscribe reply, or a token refresh in flight,
  // stops instead of acting on a newer session.
  int _subscribeAttemptId = 0;
  // The attempt in progress, so a second one isn't started for the same id.
  int? _runningAttemptId;
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

  final _publicationController = EventController<PublicationEvent>();
  final _joinController = EventController<JoinEvent>();
  final _leaveController = EventController<LeaveEvent>();
  final _subscribingController = EventController<SubscribingEvent>();
  final _subscribedController = EventController<SubscribedEvent>();
  final _unsubscribedController = EventController<UnsubscribedEvent>();
  final _errorController = EventController<SubscriptionErrorEvent>();

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

  /// Unsubscribes and closes the subscription removed from the client. It
  /// can't be subscribed again meanwhile, even from its unsubscribed listener,
  /// which would leave a subscription on the server.
  @internal
  Future<void> remove() async {
    _closed = true;
    await unsubscribe();
    // Not from inside an event: the listeners after one that removes the
    // subscription still get that event.
    close();
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
  ///
  /// Clears the token when getToken can provide a new one, the fossil delta
  /// base and channel-compaction ID, and resets
  /// a recovery position the subscription has to a sentinel epoch ("_") the
  /// server can never match (offset 0); a subscription without a position
  /// still calls getState on its next subscribe. The recover flag is left
  /// untouched, so a recoverable
  /// subscription resubscribes with wasRecovering=true, recovered=false —
  /// letting the app reload via its existing recovery-failure path instead of
  /// treating it as a brand-new first subscribe — while a non-recoverable
  /// subscription just resubscribes (the sentinel is not sent). The real
  /// epoch/offset are adopted from the subscribe reply.
  @internal
  void invalidateState() {
    // Without getToken there is no new token to get: the subscription keeps
    // the one it has, and the server rejects it if it's no longer valid.
    if (_config.getToken != null) {
      _token = '';
    }
    if (_offset != null) {
      _offset = $fixnum.Int64(0);
      _epoch = '_';
    }
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
    _subscribeAttemptId++;
    state = SubscriptionState.unsubscribed;
    _setPushId(0);
    _errorReadyFutures(SubscriptionUnsubscribedError());
    if (prevState == SubscriptionState.subscribed) {
      _clearSubscribedState();
    }
    // Send a cleanup Unsubscribe to the server when:
    //   - we were Subscribed and the unsubscribe is not the server's own, or
    //   - we were Subscribing AND a SubscribeRequest is currently in flight,
    //     because the server may already have created (or be about to create)
    //     a subscription from that request and would otherwise keep pushing
    //     publications to a sub that the client has cancelled. This includes a
    //     server unsubscribe push: it may refer to the previous server-side
    //     subscription, not to the one the in-flight request creates.
    final shouldSend = _client.state == State.connected &&
        ((sendUnsubscribe && prevState == SubscriptionState.subscribed) ||
            (prevState == SubscriptionState.subscribing && wasInflight));
    // Written before the unsubscribed event, so a subscribe() from a listener
    // reaches the server after it.
    final unsubscribeResult =
        shouldSend ? _client.sendUnsubscribe(protocol.UnsubscribeRequest()..channel = channel) : null;
    // Its failure is handled below, after the event. A listener that
    // disconnects the client fails it before then, which must not be reported
    // as an uncaught error.
    unsubscribeResult?.ignore();
    // Emitted before the cleanup Unsubscribe is awaited, like the state change:
    // publications arriving meanwhile are already dropped.
    _addUnsubscribe(UnsubscribedEvent(code, reason));
    if (unsubscribeResult == null) {
      return;
    }
    try {
      await unsubscribeResult;
    } catch (_) {
      // Sub was Subscribed and the cleanup Unsubscribe failed — connection
      // and server-side state may have diverged, so trigger a reconnect to
      // resync. For the inflight-cancel case (was Subscribing) we let it
      // slide: if the server-side sub was created at all, the server will
      // tear it down on the next disconnect or treat any stray pubs as
      // unknown channels. No reconnect either when the client already
      // disconnected, which ended the server-side subscription.
      if (prevState == SubscriptionState.subscribed && _client.state == State.connected) {
        await _client.processDisconnect(
            code: connectingCodeUnsubscribeError, reason: 'unsubscribe error', reconnect: true);
      }
    }
  }

  @override
  Future<void> ready() => _waitReady();

  /// [ready] for a call, with its [timeout]: a call that times out stops
  /// waiting.
  Future<void> _waitReady([Duration? timeout]) {
    if (state == SubscriptionState.subscribed) {
      return Future.value();
    }
    if (state != SubscriptionState.subscribing) {
      // Returned, not thrown, so it also reaches a caller that handles the
      // future with catchError.
      return Future.error(SubscriptionUnsubscribedError());
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

  @override
  Future<PublishResult> publish(List<int> data) async {
    await _waitReady(_client.config.timeout);
    return _client.publish(channel, data);
  }

  @override
  Future<HistoryResult> history({int limit = 0, StreamPosition? since, bool reverse = false}) async {
    await _waitReady(_client.config.timeout);
    return _client.history(channel, limit: limit, since: since, reverse: reverse);
  }

  @override
  Future<PresenceResult> presence() async {
    await _waitReady(_client.config.timeout);
    return _client.presence(channel);
  }

  @override
  Future<PresenceStatsResult> presenceStats() async {
    await _waitReady(_client.config.timeout);
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
    _subscribeAttemptId++;
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
    if (!_unsubscribedController.isClosed) _unsubscribedController.add(event);
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
    if (_config.getToken == null) {
      return;
    }
    // A refresh belongs to the subscribed session it started in: after a
    // resubscribe, the new session runs its own refresh chain.
    final attemptId = _subscribeAttemptId;
    bool isCurrentSubscription() =>
        attemptId == _subscribeAttemptId && state == SubscriptionState.subscribed;
    final String token;
    try {
      final event = SubscriptionTokenEvent(channel);
      token = await _config.getToken!(event);
    } catch (ex) {
      if (!isCurrentSubscription()) {
        return;
      }
      if (ex is UnauthorizedException) {
        _failUnauthorized();
        return;
      }
      final event = SubscriptionErrorEvent(SubscriptionRefreshError(ex));
      _errorController.add(event);
      // Not after an error listener unsubscribed or disconnected.
      if (!isCurrentSubscription()) {
        return;
      }
      _refreshTimer = Timer(backoffDelay(0, Duration(seconds: 5), Duration(seconds: 10)), () {
        if (state != SubscriptionState.subscribed) {
          return;
        }
        _refreshToken();
      });
      return;
    }

    if (!isCurrentSubscription()) {
      // unsubscribe() or a disconnect arrived while getToken was in flight.
      return;
    }
    if (token == '') {
      // Documented contract: an empty token means the user has no permission
      // to stay in the channel anymore, so unsubscribe instead of sending a
      // token-less SubRefreshRequest. The stored token is deliberately kept
      // untouched - the subscription is going away.
      _failUnauthorized();
      return;
    }
    _token = token;

    try {
      final request = protocol.SubRefreshRequest()
        ..channel = channel
        ..token = _token;
      final result = await _client.sendSubRefresh(request);
      if (!isCurrentSubscription()) {
        return;
      }
      if (result.expires) {
        _refreshTimer = Timer(Duration(seconds: result.ttl), () {
          if (state != SubscriptionState.subscribed) {
            return;
          }
          _refreshToken();
        });
      }
    } catch (err) {
      if (!isCurrentSubscription()) {
        return;
      }
      final event = SubscriptionErrorEvent(SubscriptionRefreshError(err));
      _errorController.add(event);
      if (!isCurrentSubscription()) {
        return;
      }
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

  bool _isActiveAttempt(int attemptId) =>
      attemptId == _subscribeAttemptId &&
      state == SubscriptionState.subscribing &&
      _client.state == State.connected;

  Future _resubscribe() async {
    if (_runningAttemptId == _subscribeAttemptId) return;
    final attemptId = _subscribeAttemptId;
    _runningAttemptId = attemptId;
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
          if (!_isActiveAttempt(attemptId)) {
            return;
          }
          final event = SubscriptionErrorEvent(SubscriptionGetStateError(err));
          _errorController.add(event);
          if (!_isActiveAttempt(attemptId)) {
            return;
          }
          _scheduleResubscribe();
          return;
        }
        if (attemptId != _subscribeAttemptId || state != SubscriptionState.subscribing) {
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
        if (attemptId != _subscribeAttemptId || state != SubscriptionState.subscribing) {
          // unsubscribe() arrived during the getToken await.
          return;
        }
        if (token == "") {
          _failUnauthorized();
          return;
        }
        _token = token;
      }
      if (!_isActiveAttempt(attemptId)) {
        // disconnect() arrived during the getToken await.
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
      } on TimeoutException {
        if (!_isActiveAttempt(attemptId)) {
          return;
        }
        // The server didn't reply: the request is abandoned with its
        // connection, and the next connection subscribes again instead of
        // waiting for this attempt to end.
        _inflight = false;
        _subscribeAttemptId++;
        await _client.processDisconnect(
            code: connectingCodeSubscribeTimeout, reason: 'subscribe timeout', reconnect: true);
        return;
      } finally {
        if (attemptId == _subscribeAttemptId) {
          _inflight = false;
        }
      }
      if (!_isActiveAttempt(attemptId)) {
        // Concurrent unsubscribe / disconnect happened while we were awaiting
        // the subscribe reply, possibly followed by a new subscribe().
        // moveToUnsubscribed already sent a cleanup Unsubscribe to the server
        // (it saw _inflight=true), so the server won't keep this sub around.
        // Drop the result on the floor.
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
      state = SubscriptionState.subscribed;
      _resubscribeAttempts = 0;
      // Armed before the subscribed event, so a listener tearing the
      // subscription down cancels it.
      if (result.expires) {
        _refreshTimer = Timer(Duration(seconds: result.ttl), () {
          if (state != SubscriptionState.subscribed) {
            return;
          }
          _refreshToken();
        });
      }
      final event = SubscribedEvent.from(result);
      _subscribedController.add(event);
      if (attemptId != _subscribeAttemptId || state != SubscriptionState.subscribed) {
        // A subscribed listener tore the subscription down, which failed the
        // ready futures or left them for the next subscribe, and recovered
        // publications must not be delivered.
        return;
      }
      _completeReadyFutures();
      // A publication listener may tear the subscription down: the rest of
      // the recovered publications must not be delivered.
      for (final pub in result.publications) {
        if (state != SubscriptionState.subscribed) {
          break;
        }
        handlePublication(pub);
      }
    } catch (err) {
      if (!_isActiveAttempt(attemptId)) {
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
      if (err is Error && err.code == 109) {
        // Token expired: cleared before the error event, so a subscribe() from
        // its listener gets a new token.
        _token = '';
      }
      final event = SubscriptionErrorEvent(SubscriptionSubscribeError(err));
      _errorController.add(event);
      if (!_isActiveAttempt(attemptId)) {
        // An error listener unsubscribed or disconnected.
        return;
      }
      if (err is Error && err.code != 109 && !err.temporary) {
        moveToUnsubscribed(err.code, err.message, false);
        return;
      }
      _scheduleResubscribe();
      return;
    } finally {
      if (_runningAttemptId == attemptId) {
        _runningAttemptId = null;
      }
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
    if (state != SubscriptionState.subscribed) {
      // E.g. sent before the server handled unsubscribe(), or the rest of a
      // message after a listener tore the subscription down. It must not
      // move the position either.
      return;
    }
    var event = PublicationEvent.from(pub);
    if (_deltaNegotiated) {
      if (pub.delta) {
        final newData = applyDelta(Uint8List.fromList(_prevData!), Uint8List.fromList(pub.data));
        event = event.copyWith(data: newData);
      }
      _prevData = event.data;
    }
    // Before the event, so a subscribe from its listener recovers after this
    // publication.
    if (pub.offset > 0) {
      _offset = pub.offset;
    }
    _publicationController.add(event);
  }

  @internal
  void handleJoin(protocol.Join join) {
    if (state != SubscriptionState.subscribed) {
      return;
    }
    final event = JoinEvent.from(join.info);
    _joinController.add(event);
  }

  @internal
  void handleLeave(protocol.Leave leave) {
    if (state != SubscriptionState.subscribed) {
      return;
    }
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

  /// Moves to subscribing when the client's connection is lost.
  @internal
  void moveToSubscribingOnDisconnect() {
    if (state == SubscriptionState.subscribing && _inflight) {
      // The pending subscribe request went away with its connection: its
      // attempt must not act on the next connection, which subscribes again.
      _subscribeAttemptId++;
      _inflight = false;
    }
    moveToSubscribing(subscribingCodeTransportClosed, "transport closed");
  }

  @internal
  void moveToSubscribing(int code, String reason) {
    _resubscribeTimer?.cancel();
    if (state != SubscriptionState.subscribed) {
      return;
    }
    _clearSubscribedState();
    // Channel compaction: the numeric channel ID is scoped to the server-side
    // subscription that just went away, so drop it here too — not only in
    // moveToUnsubscribed. Matters for a temporary server-initiated unsubscribe
    // (code >= 2500), where the connection stays up and the ID registry is not
    // cleared: without this, a push carrying the freed ID would still be routed
    // to this subscription while it is only Subscribing. The next subscribe
    // reply re-establishes the ID (the server may reuse the same one).
    _setPushId(0);
    state = SubscriptionState.subscribing;
    final event = SubscribingEvent(code, reason);
    _addSubscribing(event);
  }
}
