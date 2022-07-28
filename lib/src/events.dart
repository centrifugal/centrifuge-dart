import 'dart:convert';

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'proto/client.pb.dart' as proto;

class ConnectionTokenEvent {
  ConnectionTokenEvent();

  @override
  String toString() {
    return 'ConnectionTokenEvent{}';
  }
}

class SubscriptionTokenEvent {
  SubscriptionTokenEvent(this.channel);

  final String channel;

  @override
  String toString() {
    return 'SubscriptionTokenEvent{channel: $channel}';
  }
}

class ErrorEvent {
  ErrorEvent(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'ErrorEvent{error: $error}';
  }
}

class ConnectingEvent {
  ConnectingEvent(this.code, this.reason);

  final int code;
  final String reason;

  @override
  String toString() {
    return 'ConnectingEvent{code: $code, reason: $reason}';
  }
}

class ConnectedEvent {
  ConnectedEvent(this.client, this.version, this.data);

  final String client;
  final String version;
  final List<int> data;

  static ConnectedEvent from(proto.ConnectResult result) =>
      ConnectedEvent(result.client, result.version, result.data);

  @override
  String toString() {
    return 'ConnectedEvent{client: $client, version: $version, data: ${utf8.decode(data, allowMalformed: true)}}';
  }
}

class DisconnectedEvent {
  DisconnectedEvent(this.code, this.reason);

  final int code;
  final String reason;

  @override
  String toString() {
    return 'DisconnectEvent{code: $code, reason: $reason}';
  }
}

class MessageEvent {
  MessageEvent(this.data);

  final List<int> data;

  @override
  String toString() {
    return 'MessageEvent{data: ${utf8.decode(data, allowMalformed: true)}';
  }
}

class PublicationEvent {
  PublicationEvent(this.data, this.offset, this.info, this.tags);

  final List<int> data;
  final $fixnum.Int64 offset;
  final ClientInfo? info;
  final Map<String, String> tags;

  static PublicationEvent from(proto.Publication pub) =>
      PublicationEvent(pub.data, pub.offset, pub.hasInfo() ? ClientInfo.from(pub.info) : null, pub.tags);

  @override
  String toString() {
    return 'PublicationEvent{data: ${utf8.decode(data, allowMalformed: true)}, offset: $offset, info: $info}';
  }
}

class ServerPublicationEvent {
  ServerPublicationEvent(this.channel, this.data, this.offset, this.info, this.tags);

  final String channel;
  final List<int> data;
  final $fixnum.Int64 offset;
  final ClientInfo? info;
  final Map<String, String> tags;

  static ServerPublicationEvent from(String channel, proto.Publication pub) => ServerPublicationEvent(
      channel, pub.data, pub.offset, pub.hasInfo() ? ClientInfo.from(pub.info) : null, pub.tags);

  @override
  String toString() {
    return 'ServerPublicationEvent{channel: $channel, data: ${utf8.decode(data, allowMalformed: true)}, offset: $offset, info: $info}';
  }
}

class ClientInfo {
  ClientInfo(this.client, this.user, this.connInfo, this.chanInfo);

  static ClientInfo from(proto.ClientInfo info) =>
      ClientInfo(info.client, info.user, info.connInfo, info.chanInfo);

  final String client;
  final String user;
  final List<int>? connInfo;
  final List<int>? chanInfo;

  @override
  String toString() {
    return 'ClientInfo{client: $client, user: $user}';
  }
}

class Publication {
  Publication(this.data, this.offset, this.info);

  static Publication from(proto.Publication pub) =>
      Publication(pub.data, pub.offset, pub.hasInfo() ? ClientInfo.from(pub.info) : null);

  final List<int> data;
  final $fixnum.Int64 offset;
  final ClientInfo? info;
}

class HistoryResult {
  HistoryResult(this.publications, this.offset, this.epoch);

  final List<Publication> publications;
  final $fixnum.Int64 offset;
  final String epoch;

  static HistoryResult from(proto.HistoryResult res) {
    final pubs = <Publication>[];
    res.publications.forEach((element) {
      pubs.add(Publication.from(element));
    });
    return HistoryResult(pubs, res.offset, res.epoch);
  }

  @override
  String toString() {
    return 'HistoryResult{num pubs: ${publications.length}, offset: $offset, epoch: $epoch}';
  }
}

class PresenceResult {
  PresenceResult(this.clients);

  final Map<String, ClientInfo> clients;

  static PresenceResult from(proto.PresenceResult res) {
    final clients = <String, ClientInfo>{};
    res.presence.forEach((clientId, ci) {
      clients[clientId] = ClientInfo.from(ci);
    });
    return PresenceResult(
      clients,
    );
  }

  @override
  String toString() {
    return 'PresenceResult{num clients: ${clients.length}}';
  }
}

class PresenceStatsResult {
  PresenceStatsResult(this.numClients, this.numUsers);

  final int numClients;
  final int numUsers;

  static PresenceStatsResult from(proto.PresenceStatsResult res) {
    return PresenceStatsResult(res.numClients, res.numUsers);
  }

  @override
  String toString() {
    return 'PresenceStatsResult{num clients: $numClients, num users: $numUsers}';
  }
}

class JoinEvent {
  JoinEvent(this.user, this.client);

  final String user;
  final String client;

  static JoinEvent from(proto.ClientInfo clientInfo) => JoinEvent(clientInfo.user, clientInfo.client);

  @override
  String toString() {
    return 'JoinEvent{user: $user, client: $client}';
  }
}

class ServerJoinEvent {
  ServerJoinEvent(this.channel, this.user, this.client);

  final String channel;
  final String user;
  final String client;

  static ServerJoinEvent from(String channel, proto.ClientInfo clientInfo) =>
      ServerJoinEvent(channel, clientInfo.user, clientInfo.client);

  @override
  String toString() {
    return 'ServerJoinEvent{channel: $channel, user: $user, client: $client}';
  }
}

class LeaveEvent {
  LeaveEvent(this.user, this.client);

  final String user;
  final String client;

  static LeaveEvent from(proto.ClientInfo clientInfo) => LeaveEvent(clientInfo.user, clientInfo.client);

  @override
  String toString() {
    return 'LeaveEvent{user: $user, client: $client}';
  }
}

class ServerLeaveEvent {
  ServerLeaveEvent(this.channel, this.user, this.client);

  final String channel;
  final String user;
  final String client;

  static ServerLeaveEvent from(String channel, proto.ClientInfo clientInfo) =>
      ServerLeaveEvent(channel, clientInfo.user, clientInfo.client);

  @override
  String toString() {
    return 'ServerLeaveEvent{channel: $channel, user: $user, client: $client}';
  }
}

class SubscribedEvent {
  SubscribedEvent(
      this.wasRecovering, this.recovered, this.data, this.streamPosition, this.positioned, this.recoverable);

  final bool recovered;
  final bool wasRecovering;
  final bool positioned;
  final bool recoverable;
  final List<int> data;
  final StreamPosition? streamPosition;

  static SubscribedEvent from(proto.SubscribeResult result) {
    StreamPosition? streamPosition;
    if (result.positioned || result.recoverable) {
      streamPosition = StreamPosition(result.offset, result.epoch);
    }
    return SubscribedEvent(result.wasRecovering, result.recovered, result.data, streamPosition,
        result.positioned, result.recoverable);
  }

  @override
  String toString() {
    return 'SubscribedEvent{wasRecovering: $wasRecovering, recovered: $recovered, data: ${utf8.decode(data, allowMalformed: true)}, streamPosition: $streamPosition}';
  }
}

class ServerSubscribedEvent {
  ServerSubscribedEvent(this.channel, this.wasRecovering, this.recovered, this.data, this.streamPosition,
      this.positioned, this.recoverable);

  final String channel;
  final bool recovered;
  final bool wasRecovering;
  final bool positioned;
  final bool recoverable;
  final List<int> data;
  final StreamPosition? streamPosition;

  static ServerSubscribedEvent fromSubscribeResult(String channel, proto.SubscribeResult result) {
    StreamPosition? streamPosition;
    if (result.positioned || result.recoverable) {
      streamPosition = StreamPosition(result.offset, result.epoch);
    }
    return ServerSubscribedEvent(channel, result.wasRecovering, result.recovered, result.data, streamPosition,
        result.positioned, result.recoverable);
  }

  static ServerSubscribedEvent fromSubscribePush(String channel, proto.Subscribe result, bool resubscribed) {
    StreamPosition? streamPosition;
    if (result.positioned || result.recoverable) {
      streamPosition = StreamPosition(result.offset, result.epoch);
    }
    return ServerSubscribedEvent(
        channel, false, false, result.data, streamPosition, result.positioned, result.recoverable);
  }

  @override
  String toString() {
    return 'ServerSubscribedEvent{channel: $channel, wasRecovering: $wasRecovering, recovered: $recovered, data: ${utf8.decode(data, allowMalformed: true)}, streamPosition: $streamPosition}';
  }
}

class StreamPosition {
  StreamPosition(this.offset, this.epoch);

  static StreamPosition from(proto.StreamPosition sp) => StreamPosition(sp.offset, sp.epoch);

  final $fixnum.Int64 offset;
  final String epoch;

  @override
  String toString() {
    return 'StreamPosition{offset: $offset, epoch: $epoch}';
  }
}

class SubscriptionErrorEvent {
  final dynamic error;

  SubscriptionErrorEvent(this.error);

  @override
  String toString() {
    return 'SubscriptionErrorEvent{error: $error}';
  }
}

class SubscribingEvent {
  final int code;
  final String reason;

  SubscribingEvent(this.code, this.reason);

  @override
  String toString() {
    return 'SubscribingEvent{code: $code, reason: $reason}';
  }
}

class UnsubscribedEvent {
  final int code;
  final String reason;

  UnsubscribedEvent(this.code, this.reason);

  @override
  String toString() {
    return 'UnsubscribedEvent{code $code, reason: $reason}';
  }
}

class ServerSubscribingEvent {
  ServerSubscribingEvent(this.channel);

  final String channel;

  static ServerSubscribingEvent from(String channel) => ServerSubscribingEvent(channel);

  @override
  String toString() {
    return 'ServerSubscribingEvent{channel: $channel}';
  }
}

class ServerUnsubscribedEvent {
  ServerUnsubscribedEvent(this.channel);

  final String channel;

  static ServerUnsubscribedEvent from(String channel) => ServerUnsubscribedEvent(channel);

  @override
  String toString() {
    return 'ServerUnsubscribedEvent{channel: $channel}';
  }
}

class RPCResult {
  RPCResult(this.data);

  final List<int> data;

  static RPCResult from(proto.RPCResult result) => RPCResult(result.data);

  @override
  String toString() {
    return 'RPCResult{data: ${utf8.decode(data, allowMalformed: true)}}';
  }
}

class PublishResult {
  static PublishResult from(proto.PublishResult result) => PublishResult();

  @override
  String toString() {
    return 'PublishResult{}';
  }
}
