import 'dart:async';

import 'client.dart';
import 'proto/client.pb.dart' hide Error;
import 'proto/client.pb.dart' as proto show Error;

abstract class Subscription {
  final String channel;

  Subscription(this.channel);

  Stream<PublishEvent> get publishStream;

  Stream<JoinEvent> get joinStream;

  Stream<LeaveEvent> get leaveStream;

  Stream<SubscribeSuccessEvent> get subscribeSuccessStream;

  Stream<SubscribeErrorEvent> get subscribeErrorStream;

  Stream<UnsubscribeEvent> get unsubscribeStream;

  Future subscribe();

  Future unsubscribe();

  Future publish(List<int> data);
}

class SubscriptionImpl implements Subscription {
  @override
  final String channel;
  final ClientImpl _client;

  SubscriptionImpl(this.channel, this._client);

  final _publishController =
      StreamController<PublishEvent>.broadcast(sync: true);
  final _joinController = StreamController<JoinEvent>.broadcast(sync: true);
  final _leaveController = StreamController<LeaveEvent>.broadcast(sync: true);
  final _subscribeSuccessController =
      StreamController<SubscribeSuccessEvent>.broadcast(sync: true);
  final _subscribeErrorController =
      StreamController<SubscribeErrorEvent>.broadcast(sync: true);
  final _unsubscribeController =
      StreamController<UnsubscribeEvent>.broadcast(sync: true);

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

  void onPublish(PublishEvent event) => _publishController.add(event);

  void onJoin(JoinEvent event) => _joinController.add(event);

  void onLeave(LeaveEvent event) => _leaveController.add(event);

  void onSubscribeSuccess(SubscribeSuccessEvent event) =>
      _subscribeSuccessController.add(event);

  void onSubscribeError(SubscribeErrorEvent event) =>
      _subscribeErrorController.add(event);

  void onUnsubscribe(UnsubscribeEvent event) =>
      _unsubscribeController.add(event);

  @override
  Future publish(List<int> data) => _client.publish(channel, data);

  @override
  Future subscribe() => resubscribe(false);

  @override
  Future unsubscribe() async {
    await _client.sendUnsubscribe(channel);
    final event = UnsubscribeEvent();
    onUnsubscribe(event);
  }

  Future resubscribe(bool isResubscribe) async {
    try {
      final result = await _client.sendSubscribe(channel);
      final event = SubscribeSuccessEvent.from(result, isResubscribe);
      onSubscribeSuccess(event);
      _recover(result);
    } catch (exception) {
      if (exception is proto.Error) {
        onSubscribeError(SubscribeErrorEvent.from(exception));
      } else {
        onSubscribeError(SubscribeErrorEvent._(exception.toString(), -1));
      }
    }
  }

  void _recover(SubscribeResult result) {
    for (Publication publication in result.publications) {
      final event = PublishEvent.from(publication);
      onPublish(event);
    }
  }
}

class PublishEvent {
  final String uid;
  final List<int> data;

  PublishEvent._(this.uid, this.data);

  static PublishEvent from(Publication pub) =>
      PublishEvent._(pub.uid, pub.data);

  @override
  String toString() {
    return 'PublishEvent{uid: $uid, data: $data}';
  }
}

class JoinEvent {
  final String user;
  final String client;

  JoinEvent._(this.user, this.client);

  static JoinEvent from(ClientInfo clientInfo) =>
      JoinEvent._(clientInfo.user, clientInfo.client);

  @override
  String toString() {
    return 'JoinEvent{user: $user, client: $client}';
  }
}

class LeaveEvent {
  final String user;
  final String client;

  LeaveEvent._(this.user, this.client);

  static LeaveEvent from(ClientInfo clientInfo) =>
      LeaveEvent._(clientInfo.user, clientInfo.client);

  @override
  String toString() {
    return 'LeaveEvent{user: $user, client: $client}';
  }
}

class SubscribeSuccessEvent {
  final bool resubscribed;
  final bool recovered;

  SubscribeSuccessEvent._(this.resubscribed, this.recovered);

  static SubscribeSuccessEvent from(
          SubscribeResult result, bool resubscribed) =>
      SubscribeSuccessEvent._(resubscribed, result.recovered);

  @override
  String toString() {
    return 'SubscribeSuccessEvent{resubscribed: $resubscribed, recovered: $recovered}';
  }
}

class SubscribeErrorEvent {
  final String message;
  final int code;

  SubscribeErrorEvent._(this.message, this.code);

  static SubscribeErrorEvent from(proto.Error error) =>
      SubscribeErrorEvent._(error.message, error.code);

  @override
  String toString() {
    return 'SubscribeErrorEvent{message: $message, code: $code}';
  }
}

class UnsubscribeEvent {
  @override
  String toString() {
    return 'UnsubscribeEvent{}';
  }
}
