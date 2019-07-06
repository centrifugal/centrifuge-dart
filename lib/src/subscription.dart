import 'dart:async';

import 'package:meta/meta.dart';

import 'client.dart';
import 'error.dart' as errors;
import 'events.dart';
import 'proto/client.pb.dart';

abstract class Subscription {
  String get channel;

  Stream<PublishEvent> get publishStream;

  Stream<JoinEvent> get joinStream;

  Stream<LeaveEvent> get leaveStream;

  Stream<SubscribeSuccessEvent> get subscribeSuccessStream;

  Stream<SubscribeErrorEvent> get subscribeErrorStream;

  Stream<UnsubscribeEvent> get unsubscribeStream;

  Future subscribe();

  Future unsubscribe();

  Future publish(List<int> data);

  Future<List<HistoryEvent>> history();
}

class SubscriptionImpl implements Subscription {
  SubscriptionImpl(this.channel, this._client);

  @override
  final String channel;
  final ClientImpl _client;

  final _publishController = StreamController<PublishEvent>.broadcast();
  final _joinController = StreamController<JoinEvent>.broadcast();
  final _leaveController = StreamController<LeaveEvent>.broadcast();
  final _subscribeSuccessController =
      StreamController<SubscribeSuccessEvent>.broadcast();
  final _subscribeErrorController =
      StreamController<SubscribeErrorEvent>.broadcast();
  final _unsubscribeController = StreamController<UnsubscribeEvent>.broadcast();

  var _state = _SubscriptionState.unsubscribed;

  @override
  Stream<PublishEvent> get publishStream => _publishController.stream;

  @override
  Stream<JoinEvent> get joinStream => _joinController.stream;

  @override
  Stream<LeaveEvent> get leaveStream => _leaveController.stream;

  @override
  Stream<SubscribeSuccessEvent> get subscribeSuccessStream =>
      _subscribeSuccessController.stream;

  @override
  Stream<SubscribeErrorEvent> get subscribeErrorStream =>
      _subscribeErrorController.stream;

  @override
  Stream<UnsubscribeEvent> get unsubscribeStream =>
      _unsubscribeController.stream;

  @override
  Future publish(List<int> data) => _client.publish(channel, data);

  @override
  Future subscribe() {
    _state = _SubscriptionState.subscribed;
    if (!_client.connected) {
      return Future<void>.value(null);
    }
    return _resubscribe(isResubscribed: false);
  }

  Future resubscribeIfNeeded() {
    if (_state != _SubscriptionState.subscribed) {
      return Future<void>.value(null);
    }
    return _resubscribe(isResubscribed: true);
  }

  @override
  Future unsubscribe() async {
    if (_state != _SubscriptionState.subscribed) {
      return Future<void>.value(null);
    }
    _state = _SubscriptionState.unsubscribed;

    final request = UnsubscribeRequest()..channel = channel;
    await _client.sendMessage(request, UnsubscribeResult());
    final event = UnsubscribeEvent();
    addUnsubscribe(event);
  }

  void sendUnsubscribeEventIfNeeded() {
    if (_state != _SubscriptionState.subscribed) {
      return;
    }
    final event = UnsubscribeEvent();
    addUnsubscribe(event);
  }

  @override
  Future<List<HistoryEvent>> history() async {
    final request = HistoryRequest()..channel = channel;
    final result = await _client.sendMessage(request, HistoryResult());
    final events = result.publications.map(HistoryEvent.from).toList();
    return events;
  }

  void addPublish(PublishEvent event) => _publishController.add(event);

  void addJoin(JoinEvent event) => _joinController.add(event);

  void addLeave(LeaveEvent event) => _leaveController.add(event);

  void _onSubscribeSuccess(SubscribeSuccessEvent event) =>
      _subscribeSuccessController.add(event);

  void _onSubscribeError(SubscribeErrorEvent event) =>
      _subscribeErrorController.add(event);

  void addUnsubscribe(UnsubscribeEvent event) =>
      _unsubscribeController.add(event);

  Future _resubscribe({@required bool isResubscribed}) async {
    try {
      final request = SubscribeRequest()
        ..channel = channel
        ..token = _client.getToken(channel) ?? '';

      final result = await _client.sendMessage(request, SubscribeResult());
      final event = SubscribeSuccessEvent.from(result, isResubscribed);
      _onSubscribeSuccess(event);
      _recover(result);
    } catch (exception) {
      if (exception is errors.Error) {
        _onSubscribeError(
            SubscribeErrorEvent(exception.message, exception.code));
      } else {
        _onSubscribeError(SubscribeErrorEvent(exception.toString(), -1));
      }
    }
  }

  void _recover(SubscribeResult result) {
    for (Publication publication in result.publications) {
      final event = PublishEvent.from(publication);
      addPublish(event);
    }
  }
}

enum _SubscriptionState { subscribed, unsubscribed }
