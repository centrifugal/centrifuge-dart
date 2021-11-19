import 'dart:convert';

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'proto/client.pb.dart' as proto;

class PrivateSubEvent {
  PrivateSubEvent(this.clientID, this.channel);

  final String clientID;
  final String channel;

  @override
  String toString() {
    return 'PrivateSubEvent{clientID: $clientID, channel: $channel}';
  }
}

class ConnectEvent {
  ConnectEvent(this.client, this.version, this.data);

  final String client;
  final String version;
  final List<int> data;

  static ConnectEvent from(proto.ConnectResult result) =>
      ConnectEvent(result.client, result.version, result.data);

  @override
  String toString() {
    return 'ConnectEvent{client: $client, version: $version, data: ${utf8.decode(data, allowMalformed: true)}}';
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

class DisconnectEvent {
  DisconnectEvent(this.reason, this.shouldReconnect);

  final String reason;
  final bool shouldReconnect;

  @override
  String toString() {
    return 'DisconnectEvent{reason: $reason, shouldReconnect: $shouldReconnect}';
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

class PublishEvent {
  PublishEvent(this.data, this.offset, this.info);

  final List<int> data;
  final $fixnum.Int64 offset;
  final ClientInfo? info;

  static PublishEvent from(proto.Publication pub) => PublishEvent(
      pub.data, pub.offset, pub.hasInfo() ? ClientInfo.from(pub.info) : null);

  @override
  String toString() {
    return 'PublishEvent{data: ${utf8.decode(data, allowMalformed: true)}, offset: $offset, info: $info}';
  }
}

class ServerPublishEvent {
  ServerPublishEvent(this.channel, this.data, this.offset, this.info);

  final String channel;
  final List<int> data;
  final $fixnum.Int64 offset;
  final ClientInfo? info;

  static ServerPublishEvent from(String channel, proto.Publication pub) =>
      ServerPublishEvent(channel, pub.data, pub.offset,
          pub.hasInfo() ? ClientInfo.from(pub.info) : null);

  @override
  String toString() {
    return 'ServerPublishEvent{channel: $channel, data: ${utf8.decode(data, allowMalformed: true)}, offset: $offset, info: $info}';
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

  static Publication from(proto.Publication pub) => Publication(
      pub.data, pub.offset, pub.hasInfo() ? ClientInfo.from(pub.info) : null);

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
  PresenceResult(this.presence);

  final Map<String, ClientInfo> presence;

  static PresenceResult from(proto.PresenceResult res) {
    final presence = <String, ClientInfo>{};
    res.presence.forEach((clientId, ci) {
      presence[clientId] = ClientInfo.from(ci);
    });
    return PresenceResult(
      presence,
    );
  }

  @override
  String toString() {
    return 'PresenceResult{num clients: ${presence.length}}';
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

  static JoinEvent from(proto.ClientInfo clientInfo) =>
      JoinEvent(clientInfo.user, clientInfo.client);

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

  static LeaveEvent from(proto.ClientInfo clientInfo) =>
      LeaveEvent(clientInfo.user, clientInfo.client);

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

class SubscribeSuccessEvent {
  SubscribeSuccessEvent(
      this.isResubscribed, this.isRecovered, this.data, this.streamPosition);

  final bool isResubscribed;
  final bool isRecovered;
  final List<int> data;
  final StreamPosition? streamPosition;

  static SubscribeSuccessEvent from(
      proto.SubscribeResult result, bool resubscribed) {
    StreamPosition? streamPosition;
    if (result.positioned) {
      streamPosition = StreamPosition(result.offset, result.epoch);
    }
    return SubscribeSuccessEvent(
        resubscribed, result.recovered, result.data, streamPosition);
  }

  @override
  String toString() {
    return 'SubscribeSuccessEvent{isResubscribed: $isResubscribed, isRecovered: $isRecovered, data: ${utf8.decode(data, allowMalformed: true)}, streamPosition: $streamPosition}';
  }
}

class ServerSubscribeEvent {
  ServerSubscribeEvent(this.channel, this.isResubscribed, this.isRecovered,
      this.data, this.streamPosition);

  final String channel;
  final bool isResubscribed;
  final bool isRecovered;
  final List<int> data;
  final StreamPosition? streamPosition;

  static ServerSubscribeEvent fromSubscribeResult(
      String channel, proto.SubscribeResult result, bool resubscribed) {
    StreamPosition? streamPosition;
    if (result.positioned) {
      streamPosition = StreamPosition(result.offset, result.epoch);
    }
    return ServerSubscribeEvent(
        channel, resubscribed, result.recovered, result.data, streamPosition);
  }

  static ServerSubscribeEvent fromSubscribePush(
      String channel, proto.Subscribe result, bool resubscribed) {
    StreamPosition? streamPosition;
    if (result.positioned) {
      streamPosition = StreamPosition(result.offset, result.epoch);
    }
    return ServerSubscribeEvent(
        channel, resubscribed, false, result.data, streamPosition);
  }

  @override
  String toString() {
    return 'ServerSubscribeEvent{channel: $channel, isResubscribed: $isResubscribed, isRecovered: $isRecovered, data: ${utf8.decode(data, allowMalformed: true)}, streamPosition: $streamPosition}';
  }
}

class StreamPosition {
  StreamPosition(this.offset, this.epoch);

  static StreamPosition from(proto.StreamPosition sp) =>
      StreamPosition(sp.offset, sp.epoch);

  final $fixnum.Int64 offset;
  final String epoch;

  @override
  String toString() {
    return 'StreamPosition{offset: $offset, epoch: $epoch}';
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

class ServerUnsubscribeEvent {
  ServerUnsubscribeEvent(this.channel);

  final String channel;

  static ServerUnsubscribeEvent from(String channel) =>
      ServerUnsubscribeEvent(channel);

  @override
  String toString() {
    return 'ServerUnsubscribeEvent{channel: $channel}';
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
