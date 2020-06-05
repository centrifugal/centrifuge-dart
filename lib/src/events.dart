import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'proto/client.pb.dart' as proto;

class PrivateSubEvent {
  const PrivateSubEvent(this.clientID, this.channel);

  final String clientID;
  final String channel;

  @override
  String toString() {
    return 'PrivateSubEvent{clientID: $clientID, channel: $channel}';
  }
}

class ConnectEvent {
  const ConnectEvent(
    this.client,
    this.version,
    this.expires,
    this.ttl,
    this.data,
    this.subs,
  );

  final String client;
  final String version;
  final bool expires;
  final int ttl;
  final List<int> data;
  final Map<String, proto.SubscribeResult> subs;

  static ConnectEvent from(proto.ConnectResult result) {
    return ConnectEvent(
      result.client,
      result.version,
      result.expires,
      result.ttl,
      result.data,
      result.subs,
    );
  }

  @override
  String toString() {
    return 'ConnectEvent{'
        'client: $client, '
        'version: $version, '
        'expires: $expires, '
        'ttl: $ttl, '
        'data: ${utf8.decode(data, allowMalformed: true)}, '
        'subs: $subs'
        '}';
  }
}

class DisconnectEvent {
  const DisconnectEvent(this.reason, this.shouldReconnect);

  final String reason;
  final bool shouldReconnect;

  @override
  String toString() {
    return 'DisconnectEvent{reason: $reason, shouldReconnect: $shouldReconnect}';
  }
}

class MessageEvent {
  const MessageEvent(this.data);

  final List<int> data;

  @override
  String toString() {
    return 'MessageEvent{data: ${utf8.decode(data, allowMalformed: true)}';
  }
}

class PublishEvent {
  const PublishEvent(
    this.seq,
    this.gen,
    this.uid,
    this.clientInfo,
    this.offset,
    this.data,
  );

  @Deprecated('Offset field instead of seq and gen. '
      'With backwards compatibility in mind via global flags that will be '
      'removed in Centrifuge v1 release')
  final int seq;
  @Deprecated('Offset field instead of seq and gen. '
      'With backwards compatibility in mind via global flags that will be '
      'removed in Centrifuge v1 release')
  final int gen;
  final String uid;
  final proto.ClientInfo clientInfo;
  final Int64 offset;
  final List<int> data;

  static PublishEvent from(proto.Publication pub) =>
      PublishEvent(pub.seq, pub.gen, pub.uid, pub.info, pub.offset, pub.data);

  @override
  String toString() {
    return 'PublishEvent{'
        'seq: $seq, '
        'gen: $gen, '
        'uid: $uid, '
        'clientInfo: ${clientInfo.toProto3Json()}, '
        'offset: $offset, '
        'data: $data'
        '}';
  }
}

class HistoryEvent {
  const HistoryEvent(
    this.seq,
    this.gen,
    this.uid,
    this.clientInfo,
    this.offset,
    this.data,
  );

  @Deprecated('Offset field instead of seq and gen. '
      'With backwards compatibility in mind via global flags that will be '
      'removed in Centrifuge v1 release')
  final int seq;
  @Deprecated('Offset field instead of seq and gen. '
      'With backwards compatibility in mind via global flags that will be '
      'removed in Centrifuge v1 release')
  final int gen;
  final String uid;
  final proto.ClientInfo clientInfo;
  final Int64 offset;
  final List<int> data;

  static HistoryEvent from(proto.Publication pub) =>
      HistoryEvent(pub.seq, pub.gen, pub.uid, pub.info, pub.offset, pub.data);

  @override
  String toString() {
    return 'HistoryEvent{'
        'seq: $seq, '
        'gen: $gen, '
        'uid: $uid, '
        'clientInfo: $clientInfo, '
        'offset: $offset, '
        'data: $data'
        '}';
  }
}

class JoinEvent {
  const JoinEvent(this.user, this.client);

  final String user;
  final String client;

  static JoinEvent from(proto.ClientInfo clientInfo) =>
      JoinEvent(clientInfo.user, clientInfo.client);

  @override
  String toString() {
    return 'JoinEvent{user: $user, client: $client}';
  }
}

class LeaveEvent {
  const LeaveEvent(this.user, this.client);

  final String user;
  final String client;

  static LeaveEvent from(proto.ClientInfo clientInfo) =>
      LeaveEvent(clientInfo.user, clientInfo.client);

  @override
  String toString() {
    return 'LeaveEvent{user: $user, client: $client}';
  }
}

class SubscribeSuccessEvent {
  const SubscribeSuccessEvent(
    this.isResubscribed,
    this.isExpires,
    this.ttl,
    this.isRecoverable,
    this.seq,
    this.gen,
    this.epoch,
    this.isRecovered,
    this.offset,
  );

  final bool isResubscribed;
  final bool isExpires;
  final int ttl;
  final bool isRecoverable;
  @Deprecated('Offset field instead of seq and gen. '
      'With backwards compatibility in mind via global flags that will be '
      'removed in Centrifuge v1 release')
  final int seq;
  @Deprecated('Offset field instead of seq and gen. '
      'With backwards compatibility in mind via global flags that will be '
      'removed in Centrifuge v1 release')
  final int gen;
  final String epoch;
  final bool isRecovered;
  final Int64 offset;

  static SubscribeSuccessEvent from(
    proto.SubscribeResult result,
    bool resubscribed,
  ) =>
      SubscribeSuccessEvent(
        resubscribed,
        result.expires,
        result.ttl,
        result.recoverable,
        result.seq,
        result.gen,
        result.epoch,
        result.recovered,
        result.offset,
      );

  @override
  String toString() {
    return 'SubscribeSuccessEvent{'
        'isResubscribed: $isResubscribed, '
        'isExpires: $isExpires, '
        'ttl: $ttl, '
        'recoverable: $isRecoverable, '
        'seq: $seq, '
        'gen: $gen, '
        'epoch: $epoch, '
        'isRecovered: $isRecovered, '
        'offset: $offset'
        '}';
  }
}

class SubscribeErrorEvent {
  SubscribeErrorEvent(this.message, this.code);

  final String message;
  final int code;

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
