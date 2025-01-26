//
//  Generated code. Do not modify.
//  source: client.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class Error extends $pb.GeneratedMessage {
  factory Error({
    $core.int? code,
    $core.String? message,
    $core.bool? temporary,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (message != null) {
      $result.message = message;
    }
    if (temporary != null) {
      $result.temporary = temporary;
    }
    return $result;
  }
  Error._() : super();
  factory Error.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Error.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Error', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOB(3, _omitFieldNames ? '' : 'temporary')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Error clone() => Error()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Error copyWith(void Function(Error) updates) => super.copyWith((message) => updates(message as Error)) as Error;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Error create() => Error._();
  Error createEmptyInstance() => create();
  static $pb.PbList<Error> createRepeated() => $pb.PbList<Error>();
  @$core.pragma('dart2js:noInline')
  static Error getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Error>(create);
  static Error? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get temporary => $_getBF(2);
  @$pb.TagNumber(3)
  set temporary($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTemporary() => $_has(2);
  @$pb.TagNumber(3)
  void clearTemporary() => clearField(3);
}

class EmulationRequest extends $pb.GeneratedMessage {
  factory EmulationRequest({
    $core.String? node,
    $core.String? session,
    $core.List<$core.int>? data,
  }) {
    final $result = create();
    if (node != null) {
      $result.node = node;
    }
    if (session != null) {
      $result.session = session;
    }
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  EmulationRequest._() : super();
  factory EmulationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EmulationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EmulationRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'node')
    ..aOS(2, _omitFieldNames ? '' : 'session')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EmulationRequest clone() => EmulationRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EmulationRequest copyWith(void Function(EmulationRequest) updates) => super.copyWith((message) => updates(message as EmulationRequest)) as EmulationRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmulationRequest create() => EmulationRequest._();
  EmulationRequest createEmptyInstance() => create();
  static $pb.PbList<EmulationRequest> createRepeated() => $pb.PbList<EmulationRequest>();
  @$core.pragma('dart2js:noInline')
  static EmulationRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EmulationRequest>(create);
  static EmulationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get node => $_getSZ(0);
  @$pb.TagNumber(1)
  set node($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNode() => $_has(0);
  @$pb.TagNumber(1)
  void clearNode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get session => $_getSZ(1);
  @$pb.TagNumber(2)
  set session($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSession() => $_has(1);
  @$pb.TagNumber(2)
  void clearSession() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get data => $_getN(2);
  @$pb.TagNumber(3)
  set data($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasData() => $_has(2);
  @$pb.TagNumber(3)
  void clearData() => clearField(3);
}

/// Command sent from a client to a server.
/// ProtocolVersion2 uses id and one of the possible request messages.
class Command extends $pb.GeneratedMessage {
  factory Command({
    $core.int? id,
    ConnectRequest? connect,
    SubscribeRequest? subscribe,
    UnsubscribeRequest? unsubscribe,
    PublishRequest? publish,
    PresenceRequest? presence,
    PresenceStatsRequest? presenceStats,
    HistoryRequest? history,
    PingRequest? ping,
    SendRequest? send,
    RPCRequest? rpc,
    RefreshRequest? refresh,
    SubRefreshRequest? subRefresh,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (connect != null) {
      $result.connect = connect;
    }
    if (subscribe != null) {
      $result.subscribe = subscribe;
    }
    if (unsubscribe != null) {
      $result.unsubscribe = unsubscribe;
    }
    if (publish != null) {
      $result.publish = publish;
    }
    if (presence != null) {
      $result.presence = presence;
    }
    if (presenceStats != null) {
      $result.presenceStats = presenceStats;
    }
    if (history != null) {
      $result.history = history;
    }
    if (ping != null) {
      $result.ping = ping;
    }
    if (send != null) {
      $result.send = send;
    }
    if (rpc != null) {
      $result.rpc = rpc;
    }
    if (refresh != null) {
      $result.refresh = refresh;
    }
    if (subRefresh != null) {
      $result.subRefresh = subRefresh;
    }
    return $result;
  }
  Command._() : super();
  factory Command.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Command.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Command', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU3)
    ..aOM<ConnectRequest>(4, _omitFieldNames ? '' : 'connect', subBuilder: ConnectRequest.create)
    ..aOM<SubscribeRequest>(5, _omitFieldNames ? '' : 'subscribe', subBuilder: SubscribeRequest.create)
    ..aOM<UnsubscribeRequest>(6, _omitFieldNames ? '' : 'unsubscribe', subBuilder: UnsubscribeRequest.create)
    ..aOM<PublishRequest>(7, _omitFieldNames ? '' : 'publish', subBuilder: PublishRequest.create)
    ..aOM<PresenceRequest>(8, _omitFieldNames ? '' : 'presence', subBuilder: PresenceRequest.create)
    ..aOM<PresenceStatsRequest>(9, _omitFieldNames ? '' : 'presenceStats', subBuilder: PresenceStatsRequest.create)
    ..aOM<HistoryRequest>(10, _omitFieldNames ? '' : 'history', subBuilder: HistoryRequest.create)
    ..aOM<PingRequest>(11, _omitFieldNames ? '' : 'ping', subBuilder: PingRequest.create)
    ..aOM<SendRequest>(12, _omitFieldNames ? '' : 'send', subBuilder: SendRequest.create)
    ..aOM<RPCRequest>(13, _omitFieldNames ? '' : 'rpc', subBuilder: RPCRequest.create)
    ..aOM<RefreshRequest>(14, _omitFieldNames ? '' : 'refresh', subBuilder: RefreshRequest.create)
    ..aOM<SubRefreshRequest>(15, _omitFieldNames ? '' : 'subRefresh', subBuilder: SubRefreshRequest.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Command clone() => Command()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Command copyWith(void Function(Command) updates) => super.copyWith((message) => updates(message as Command)) as Command;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Command create() => Command._();
  Command createEmptyInstance() => create();
  static $pb.PbList<Command> createRepeated() => $pb.PbList<Command>();
  @$core.pragma('dart2js:noInline')
  static Command getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Command>(create);
  static Command? _defaultInstance;

  /// Id of command to let client match replies to commands.
  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  /// ProtocolVersion2 client can send one of the following requests. Server will
  /// only take the first non-null request out of these and may return an error if
  /// client passed more than one request. We are not using oneof here due to JSON
  /// interoperability concerns.
  @$pb.TagNumber(4)
  ConnectRequest get connect => $_getN(1);
  @$pb.TagNumber(4)
  set connect(ConnectRequest v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasConnect() => $_has(1);
  @$pb.TagNumber(4)
  void clearConnect() => clearField(4);
  @$pb.TagNumber(4)
  ConnectRequest ensureConnect() => $_ensure(1);

  @$pb.TagNumber(5)
  SubscribeRequest get subscribe => $_getN(2);
  @$pb.TagNumber(5)
  set subscribe(SubscribeRequest v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasSubscribe() => $_has(2);
  @$pb.TagNumber(5)
  void clearSubscribe() => clearField(5);
  @$pb.TagNumber(5)
  SubscribeRequest ensureSubscribe() => $_ensure(2);

  @$pb.TagNumber(6)
  UnsubscribeRequest get unsubscribe => $_getN(3);
  @$pb.TagNumber(6)
  set unsubscribe(UnsubscribeRequest v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasUnsubscribe() => $_has(3);
  @$pb.TagNumber(6)
  void clearUnsubscribe() => clearField(6);
  @$pb.TagNumber(6)
  UnsubscribeRequest ensureUnsubscribe() => $_ensure(3);

  @$pb.TagNumber(7)
  PublishRequest get publish => $_getN(4);
  @$pb.TagNumber(7)
  set publish(PublishRequest v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasPublish() => $_has(4);
  @$pb.TagNumber(7)
  void clearPublish() => clearField(7);
  @$pb.TagNumber(7)
  PublishRequest ensurePublish() => $_ensure(4);

  @$pb.TagNumber(8)
  PresenceRequest get presence => $_getN(5);
  @$pb.TagNumber(8)
  set presence(PresenceRequest v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasPresence() => $_has(5);
  @$pb.TagNumber(8)
  void clearPresence() => clearField(8);
  @$pb.TagNumber(8)
  PresenceRequest ensurePresence() => $_ensure(5);

  @$pb.TagNumber(9)
  PresenceStatsRequest get presenceStats => $_getN(6);
  @$pb.TagNumber(9)
  set presenceStats(PresenceStatsRequest v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasPresenceStats() => $_has(6);
  @$pb.TagNumber(9)
  void clearPresenceStats() => clearField(9);
  @$pb.TagNumber(9)
  PresenceStatsRequest ensurePresenceStats() => $_ensure(6);

  @$pb.TagNumber(10)
  HistoryRequest get history => $_getN(7);
  @$pb.TagNumber(10)
  set history(HistoryRequest v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasHistory() => $_has(7);
  @$pb.TagNumber(10)
  void clearHistory() => clearField(10);
  @$pb.TagNumber(10)
  HistoryRequest ensureHistory() => $_ensure(7);

  @$pb.TagNumber(11)
  PingRequest get ping => $_getN(8);
  @$pb.TagNumber(11)
  set ping(PingRequest v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasPing() => $_has(8);
  @$pb.TagNumber(11)
  void clearPing() => clearField(11);
  @$pb.TagNumber(11)
  PingRequest ensurePing() => $_ensure(8);

  @$pb.TagNumber(12)
  SendRequest get send => $_getN(9);
  @$pb.TagNumber(12)
  set send(SendRequest v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasSend() => $_has(9);
  @$pb.TagNumber(12)
  void clearSend() => clearField(12);
  @$pb.TagNumber(12)
  SendRequest ensureSend() => $_ensure(9);

  @$pb.TagNumber(13)
  RPCRequest get rpc => $_getN(10);
  @$pb.TagNumber(13)
  set rpc(RPCRequest v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasRpc() => $_has(10);
  @$pb.TagNumber(13)
  void clearRpc() => clearField(13);
  @$pb.TagNumber(13)
  RPCRequest ensureRpc() => $_ensure(10);

  @$pb.TagNumber(14)
  RefreshRequest get refresh => $_getN(11);
  @$pb.TagNumber(14)
  set refresh(RefreshRequest v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasRefresh() => $_has(11);
  @$pb.TagNumber(14)
  void clearRefresh() => clearField(14);
  @$pb.TagNumber(14)
  RefreshRequest ensureRefresh() => $_ensure(11);

  @$pb.TagNumber(15)
  SubRefreshRequest get subRefresh => $_getN(12);
  @$pb.TagNumber(15)
  set subRefresh(SubRefreshRequest v) { setField(15, v); }
  @$pb.TagNumber(15)
  $core.bool hasSubRefresh() => $_has(12);
  @$pb.TagNumber(15)
  void clearSubRefresh() => clearField(15);
  @$pb.TagNumber(15)
  SubRefreshRequest ensureSubRefresh() => $_ensure(12);
}

/// Reply sent from a server to a client.
/// ProtocolVersion2 uses id and one of the possible concrete result messages.
class Reply extends $pb.GeneratedMessage {
  factory Reply({
    $core.int? id,
    Error? error,
    Push? push,
    ConnectResult? connect,
    SubscribeResult? subscribe,
    UnsubscribeResult? unsubscribe,
    PublishResult? publish,
    PresenceResult? presence,
    PresenceStatsResult? presenceStats,
    HistoryResult? history,
    PingResult? ping,
    RPCResult? rpc,
    RefreshResult? refresh,
    SubRefreshResult? subRefresh,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (error != null) {
      $result.error = error;
    }
    if (push != null) {
      $result.push = push;
    }
    if (connect != null) {
      $result.connect = connect;
    }
    if (subscribe != null) {
      $result.subscribe = subscribe;
    }
    if (unsubscribe != null) {
      $result.unsubscribe = unsubscribe;
    }
    if (publish != null) {
      $result.publish = publish;
    }
    if (presence != null) {
      $result.presence = presence;
    }
    if (presenceStats != null) {
      $result.presenceStats = presenceStats;
    }
    if (history != null) {
      $result.history = history;
    }
    if (ping != null) {
      $result.ping = ping;
    }
    if (rpc != null) {
      $result.rpc = rpc;
    }
    if (refresh != null) {
      $result.refresh = refresh;
    }
    if (subRefresh != null) {
      $result.subRefresh = subRefresh;
    }
    return $result;
  }
  Reply._() : super();
  factory Reply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Reply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Reply', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU3)
    ..aOM<Error>(2, _omitFieldNames ? '' : 'error', subBuilder: Error.create)
    ..aOM<Push>(4, _omitFieldNames ? '' : 'push', subBuilder: Push.create)
    ..aOM<ConnectResult>(5, _omitFieldNames ? '' : 'connect', subBuilder: ConnectResult.create)
    ..aOM<SubscribeResult>(6, _omitFieldNames ? '' : 'subscribe', subBuilder: SubscribeResult.create)
    ..aOM<UnsubscribeResult>(7, _omitFieldNames ? '' : 'unsubscribe', subBuilder: UnsubscribeResult.create)
    ..aOM<PublishResult>(8, _omitFieldNames ? '' : 'publish', subBuilder: PublishResult.create)
    ..aOM<PresenceResult>(9, _omitFieldNames ? '' : 'presence', subBuilder: PresenceResult.create)
    ..aOM<PresenceStatsResult>(10, _omitFieldNames ? '' : 'presenceStats', subBuilder: PresenceStatsResult.create)
    ..aOM<HistoryResult>(11, _omitFieldNames ? '' : 'history', subBuilder: HistoryResult.create)
    ..aOM<PingResult>(12, _omitFieldNames ? '' : 'ping', subBuilder: PingResult.create)
    ..aOM<RPCResult>(13, _omitFieldNames ? '' : 'rpc', subBuilder: RPCResult.create)
    ..aOM<RefreshResult>(14, _omitFieldNames ? '' : 'refresh', subBuilder: RefreshResult.create)
    ..aOM<SubRefreshResult>(15, _omitFieldNames ? '' : 'subRefresh', subBuilder: SubRefreshResult.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Reply clone() => Reply()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Reply copyWith(void Function(Reply) updates) => super.copyWith((message) => updates(message as Reply)) as Reply;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Reply create() => Reply._();
  Reply createEmptyInstance() => create();
  static $pb.PbList<Reply> createRepeated() => $pb.PbList<Reply>();
  @$core.pragma('dart2js:noInline')
  static Reply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Reply>(create);
  static Reply? _defaultInstance;

  /// Id will only be set to a value > 0 for replies to commands. For pushes
  /// it will have zero value.
  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  /// Error can only be set in replies to commands. For pushes it will have zero value.
  @$pb.TagNumber(2)
  Error get error => $_getN(1);
  @$pb.TagNumber(2)
  set error(Error v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => clearField(2);
  @$pb.TagNumber(2)
  Error ensureError() => $_ensure(1);

  /// ProtocolVersion2 server can send one of the following fields. We are not using
  /// oneof here due to JSON interoperability concerns.
  @$pb.TagNumber(4)
  Push get push => $_getN(2);
  @$pb.TagNumber(4)
  set push(Push v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasPush() => $_has(2);
  @$pb.TagNumber(4)
  void clearPush() => clearField(4);
  @$pb.TagNumber(4)
  Push ensurePush() => $_ensure(2);

  @$pb.TagNumber(5)
  ConnectResult get connect => $_getN(3);
  @$pb.TagNumber(5)
  set connect(ConnectResult v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasConnect() => $_has(3);
  @$pb.TagNumber(5)
  void clearConnect() => clearField(5);
  @$pb.TagNumber(5)
  ConnectResult ensureConnect() => $_ensure(3);

  @$pb.TagNumber(6)
  SubscribeResult get subscribe => $_getN(4);
  @$pb.TagNumber(6)
  set subscribe(SubscribeResult v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasSubscribe() => $_has(4);
  @$pb.TagNumber(6)
  void clearSubscribe() => clearField(6);
  @$pb.TagNumber(6)
  SubscribeResult ensureSubscribe() => $_ensure(4);

  @$pb.TagNumber(7)
  UnsubscribeResult get unsubscribe => $_getN(5);
  @$pb.TagNumber(7)
  set unsubscribe(UnsubscribeResult v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasUnsubscribe() => $_has(5);
  @$pb.TagNumber(7)
  void clearUnsubscribe() => clearField(7);
  @$pb.TagNumber(7)
  UnsubscribeResult ensureUnsubscribe() => $_ensure(5);

  @$pb.TagNumber(8)
  PublishResult get publish => $_getN(6);
  @$pb.TagNumber(8)
  set publish(PublishResult v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasPublish() => $_has(6);
  @$pb.TagNumber(8)
  void clearPublish() => clearField(8);
  @$pb.TagNumber(8)
  PublishResult ensurePublish() => $_ensure(6);

  @$pb.TagNumber(9)
  PresenceResult get presence => $_getN(7);
  @$pb.TagNumber(9)
  set presence(PresenceResult v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasPresence() => $_has(7);
  @$pb.TagNumber(9)
  void clearPresence() => clearField(9);
  @$pb.TagNumber(9)
  PresenceResult ensurePresence() => $_ensure(7);

  @$pb.TagNumber(10)
  PresenceStatsResult get presenceStats => $_getN(8);
  @$pb.TagNumber(10)
  set presenceStats(PresenceStatsResult v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasPresenceStats() => $_has(8);
  @$pb.TagNumber(10)
  void clearPresenceStats() => clearField(10);
  @$pb.TagNumber(10)
  PresenceStatsResult ensurePresenceStats() => $_ensure(8);

  @$pb.TagNumber(11)
  HistoryResult get history => $_getN(9);
  @$pb.TagNumber(11)
  set history(HistoryResult v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasHistory() => $_has(9);
  @$pb.TagNumber(11)
  void clearHistory() => clearField(11);
  @$pb.TagNumber(11)
  HistoryResult ensureHistory() => $_ensure(9);

  @$pb.TagNumber(12)
  PingResult get ping => $_getN(10);
  @$pb.TagNumber(12)
  set ping(PingResult v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasPing() => $_has(10);
  @$pb.TagNumber(12)
  void clearPing() => clearField(12);
  @$pb.TagNumber(12)
  PingResult ensurePing() => $_ensure(10);

  @$pb.TagNumber(13)
  RPCResult get rpc => $_getN(11);
  @$pb.TagNumber(13)
  set rpc(RPCResult v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasRpc() => $_has(11);
  @$pb.TagNumber(13)
  void clearRpc() => clearField(13);
  @$pb.TagNumber(13)
  RPCResult ensureRpc() => $_ensure(11);

  @$pb.TagNumber(14)
  RefreshResult get refresh => $_getN(12);
  @$pb.TagNumber(14)
  set refresh(RefreshResult v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasRefresh() => $_has(12);
  @$pb.TagNumber(14)
  void clearRefresh() => clearField(14);
  @$pb.TagNumber(14)
  RefreshResult ensureRefresh() => $_ensure(12);

  @$pb.TagNumber(15)
  SubRefreshResult get subRefresh => $_getN(13);
  @$pb.TagNumber(15)
  set subRefresh(SubRefreshResult v) { setField(15, v); }
  @$pb.TagNumber(15)
  $core.bool hasSubRefresh() => $_has(13);
  @$pb.TagNumber(15)
  void clearSubRefresh() => clearField(15);
  @$pb.TagNumber(15)
  SubRefreshResult ensureSubRefresh() => $_ensure(13);
}

/// Push can be sent to a client as part of Reply in case of bidirectional transport or
/// without additional wrapping in case of unidirectional transports.
/// ProtocolVersion2 uses channel and one of the possible concrete push messages.
class Push extends $pb.GeneratedMessage {
  factory Push({
    $core.String? channel,
    Publication? pub,
    Join? join,
    Leave? leave,
    Unsubscribe? unsubscribe,
    Message? message,
    Subscribe? subscribe,
    Connect? connect,
    Disconnect? disconnect,
    Refresh? refresh,
  }) {
    final $result = create();
    if (channel != null) {
      $result.channel = channel;
    }
    if (pub != null) {
      $result.pub = pub;
    }
    if (join != null) {
      $result.join = join;
    }
    if (leave != null) {
      $result.leave = leave;
    }
    if (unsubscribe != null) {
      $result.unsubscribe = unsubscribe;
    }
    if (message != null) {
      $result.message = message;
    }
    if (subscribe != null) {
      $result.subscribe = subscribe;
    }
    if (connect != null) {
      $result.connect = connect;
    }
    if (disconnect != null) {
      $result.disconnect = disconnect;
    }
    if (refresh != null) {
      $result.refresh = refresh;
    }
    return $result;
  }
  Push._() : super();
  factory Push.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Push.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Push', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOS(2, _omitFieldNames ? '' : 'channel')
    ..aOM<Publication>(4, _omitFieldNames ? '' : 'pub', subBuilder: Publication.create)
    ..aOM<Join>(5, _omitFieldNames ? '' : 'join', subBuilder: Join.create)
    ..aOM<Leave>(6, _omitFieldNames ? '' : 'leave', subBuilder: Leave.create)
    ..aOM<Unsubscribe>(7, _omitFieldNames ? '' : 'unsubscribe', subBuilder: Unsubscribe.create)
    ..aOM<Message>(8, _omitFieldNames ? '' : 'message', subBuilder: Message.create)
    ..aOM<Subscribe>(9, _omitFieldNames ? '' : 'subscribe', subBuilder: Subscribe.create)
    ..aOM<Connect>(10, _omitFieldNames ? '' : 'connect', subBuilder: Connect.create)
    ..aOM<Disconnect>(11, _omitFieldNames ? '' : 'disconnect', subBuilder: Disconnect.create)
    ..aOM<Refresh>(12, _omitFieldNames ? '' : 'refresh', subBuilder: Refresh.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Push clone() => Push()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Push copyWith(void Function(Push) updates) => super.copyWith((message) => updates(message as Push)) as Push;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Push create() => Push._();
  Push createEmptyInstance() => create();
  static $pb.PbList<Push> createRepeated() => $pb.PbList<Push>();
  @$core.pragma('dart2js:noInline')
  static Push getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Push>(create);
  static Push? _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get channel => $_getSZ(0);
  @$pb.TagNumber(2)
  set channel($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(2)
  void clearChannel() => clearField(2);

  /// ProtocolVersion2 server can push one of the following fields to the client. We are
  /// not using oneof here due to JSON interoperability concerns.
  @$pb.TagNumber(4)
  Publication get pub => $_getN(1);
  @$pb.TagNumber(4)
  set pub(Publication v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasPub() => $_has(1);
  @$pb.TagNumber(4)
  void clearPub() => clearField(4);
  @$pb.TagNumber(4)
  Publication ensurePub() => $_ensure(1);

  @$pb.TagNumber(5)
  Join get join => $_getN(2);
  @$pb.TagNumber(5)
  set join(Join v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasJoin() => $_has(2);
  @$pb.TagNumber(5)
  void clearJoin() => clearField(5);
  @$pb.TagNumber(5)
  Join ensureJoin() => $_ensure(2);

  @$pb.TagNumber(6)
  Leave get leave => $_getN(3);
  @$pb.TagNumber(6)
  set leave(Leave v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasLeave() => $_has(3);
  @$pb.TagNumber(6)
  void clearLeave() => clearField(6);
  @$pb.TagNumber(6)
  Leave ensureLeave() => $_ensure(3);

  @$pb.TagNumber(7)
  Unsubscribe get unsubscribe => $_getN(4);
  @$pb.TagNumber(7)
  set unsubscribe(Unsubscribe v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasUnsubscribe() => $_has(4);
  @$pb.TagNumber(7)
  void clearUnsubscribe() => clearField(7);
  @$pb.TagNumber(7)
  Unsubscribe ensureUnsubscribe() => $_ensure(4);

  @$pb.TagNumber(8)
  Message get message => $_getN(5);
  @$pb.TagNumber(8)
  set message(Message v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasMessage() => $_has(5);
  @$pb.TagNumber(8)
  void clearMessage() => clearField(8);
  @$pb.TagNumber(8)
  Message ensureMessage() => $_ensure(5);

  @$pb.TagNumber(9)
  Subscribe get subscribe => $_getN(6);
  @$pb.TagNumber(9)
  set subscribe(Subscribe v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasSubscribe() => $_has(6);
  @$pb.TagNumber(9)
  void clearSubscribe() => clearField(9);
  @$pb.TagNumber(9)
  Subscribe ensureSubscribe() => $_ensure(6);

  @$pb.TagNumber(10)
  Connect get connect => $_getN(7);
  @$pb.TagNumber(10)
  set connect(Connect v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasConnect() => $_has(7);
  @$pb.TagNumber(10)
  void clearConnect() => clearField(10);
  @$pb.TagNumber(10)
  Connect ensureConnect() => $_ensure(7);

  @$pb.TagNumber(11)
  Disconnect get disconnect => $_getN(8);
  @$pb.TagNumber(11)
  set disconnect(Disconnect v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasDisconnect() => $_has(8);
  @$pb.TagNumber(11)
  void clearDisconnect() => clearField(11);
  @$pb.TagNumber(11)
  Disconnect ensureDisconnect() => $_ensure(8);

  @$pb.TagNumber(12)
  Refresh get refresh => $_getN(9);
  @$pb.TagNumber(12)
  set refresh(Refresh v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasRefresh() => $_has(9);
  @$pb.TagNumber(12)
  void clearRefresh() => clearField(12);
  @$pb.TagNumber(12)
  Refresh ensureRefresh() => $_ensure(9);
}

class ClientInfo extends $pb.GeneratedMessage {
  factory ClientInfo({
    $core.String? user,
    $core.String? client,
    $core.List<$core.int>? connInfo,
    $core.List<$core.int>? chanInfo,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    if (client != null) {
      $result.client = client;
    }
    if (connInfo != null) {
      $result.connInfo = connInfo;
    }
    if (chanInfo != null) {
      $result.chanInfo = chanInfo;
    }
    return $result;
  }
  ClientInfo._() : super();
  factory ClientInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ClientInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ClientInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'user')
    ..aOS(2, _omitFieldNames ? '' : 'client')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'connInfo', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'chanInfo', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ClientInfo clone() => ClientInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ClientInfo copyWith(void Function(ClientInfo) updates) => super.copyWith((message) => updates(message as ClientInfo)) as ClientInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClientInfo create() => ClientInfo._();
  ClientInfo createEmptyInstance() => create();
  static $pb.PbList<ClientInfo> createRepeated() => $pb.PbList<ClientInfo>();
  @$core.pragma('dart2js:noInline')
  static ClientInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClientInfo>(create);
  static ClientInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get user => $_getSZ(0);
  @$pb.TagNumber(1)
  set user($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get client => $_getSZ(1);
  @$pb.TagNumber(2)
  set client($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasClient() => $_has(1);
  @$pb.TagNumber(2)
  void clearClient() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get connInfo => $_getN(2);
  @$pb.TagNumber(3)
  set connInfo($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasConnInfo() => $_has(2);
  @$pb.TagNumber(3)
  void clearConnInfo() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get chanInfo => $_getN(3);
  @$pb.TagNumber(4)
  set chanInfo($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasChanInfo() => $_has(3);
  @$pb.TagNumber(4)
  void clearChanInfo() => clearField(4);
}

class Publication extends $pb.GeneratedMessage {
  factory Publication({
    $core.List<$core.int>? data,
    ClientInfo? info,
    $fixnum.Int64? offset,
    $core.Map<$core.String, $core.String>? tags,
    $core.bool? delta,
    $fixnum.Int64? time,
    $core.String? channel,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    if (info != null) {
      $result.info = info;
    }
    if (offset != null) {
      $result.offset = offset;
    }
    if (tags != null) {
      $result.tags.addAll(tags);
    }
    if (delta != null) {
      $result.delta = delta;
    }
    if (time != null) {
      $result.time = time;
    }
    if (channel != null) {
      $result.channel = channel;
    }
    return $result;
  }
  Publication._() : super();
  factory Publication.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Publication.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Publication', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aOM<ClientInfo>(5, _omitFieldNames ? '' : 'info', subBuilder: ClientInfo.create)
    ..a<$fixnum.Int64>(6, _omitFieldNames ? '' : 'offset', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..m<$core.String, $core.String>(7, _omitFieldNames ? '' : 'tags', entryClassName: 'Publication.TagsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('centrifugal.centrifuge.protocol'))
    ..aOB(8, _omitFieldNames ? '' : 'delta')
    ..aInt64(9, _omitFieldNames ? '' : 'time')
    ..aOS(10, _omitFieldNames ? '' : 'channel')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Publication clone() => Publication()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Publication copyWith(void Function(Publication) updates) => super.copyWith((message) => updates(message as Publication)) as Publication;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Publication create() => Publication._();
  Publication createEmptyInstance() => create();
  static $pb.PbList<Publication> createRepeated() => $pb.PbList<Publication>();
  @$core.pragma('dart2js:noInline')
  static Publication getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Publication>(create);
  static Publication? _defaultInstance;

  @$pb.TagNumber(4)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(4)
  set data($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(4)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(4)
  void clearData() => clearField(4);

  @$pb.TagNumber(5)
  ClientInfo get info => $_getN(1);
  @$pb.TagNumber(5)
  set info(ClientInfo v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasInfo() => $_has(1);
  @$pb.TagNumber(5)
  void clearInfo() => clearField(5);
  @$pb.TagNumber(5)
  ClientInfo ensureInfo() => $_ensure(1);

  @$pb.TagNumber(6)
  $fixnum.Int64 get offset => $_getI64(2);
  @$pb.TagNumber(6)
  set offset($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(6)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(6)
  void clearOffset() => clearField(6);

  @$pb.TagNumber(7)
  $core.Map<$core.String, $core.String> get tags => $_getMap(3);

  @$pb.TagNumber(8)
  $core.bool get delta => $_getBF(4);
  @$pb.TagNumber(8)
  set delta($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(8)
  $core.bool hasDelta() => $_has(4);
  @$pb.TagNumber(8)
  void clearDelta() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get time => $_getI64(5);
  @$pb.TagNumber(9)
  set time($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(9)
  $core.bool hasTime() => $_has(5);
  @$pb.TagNumber(9)
  void clearTime() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get channel => $_getSZ(6);
  @$pb.TagNumber(10)
  set channel($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(10)
  $core.bool hasChannel() => $_has(6);
  @$pb.TagNumber(10)
  void clearChannel() => clearField(10);
}

class Join extends $pb.GeneratedMessage {
  factory Join({
    ClientInfo? info,
  }) {
    final $result = create();
    if (info != null) {
      $result.info = info;
    }
    return $result;
  }
  Join._() : super();
  factory Join.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Join.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Join', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOM<ClientInfo>(1, _omitFieldNames ? '' : 'info', subBuilder: ClientInfo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Join clone() => Join()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Join copyWith(void Function(Join) updates) => super.copyWith((message) => updates(message as Join)) as Join;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Join create() => Join._();
  Join createEmptyInstance() => create();
  static $pb.PbList<Join> createRepeated() => $pb.PbList<Join>();
  @$core.pragma('dart2js:noInline')
  static Join getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Join>(create);
  static Join? _defaultInstance;

  @$pb.TagNumber(1)
  ClientInfo get info => $_getN(0);
  @$pb.TagNumber(1)
  set info(ClientInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearInfo() => clearField(1);
  @$pb.TagNumber(1)
  ClientInfo ensureInfo() => $_ensure(0);
}

class Leave extends $pb.GeneratedMessage {
  factory Leave({
    ClientInfo? info,
  }) {
    final $result = create();
    if (info != null) {
      $result.info = info;
    }
    return $result;
  }
  Leave._() : super();
  factory Leave.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Leave.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Leave', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOM<ClientInfo>(1, _omitFieldNames ? '' : 'info', subBuilder: ClientInfo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Leave clone() => Leave()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Leave copyWith(void Function(Leave) updates) => super.copyWith((message) => updates(message as Leave)) as Leave;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Leave create() => Leave._();
  Leave createEmptyInstance() => create();
  static $pb.PbList<Leave> createRepeated() => $pb.PbList<Leave>();
  @$core.pragma('dart2js:noInline')
  static Leave getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Leave>(create);
  static Leave? _defaultInstance;

  @$pb.TagNumber(1)
  ClientInfo get info => $_getN(0);
  @$pb.TagNumber(1)
  set info(ClientInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearInfo() => clearField(1);
  @$pb.TagNumber(1)
  ClientInfo ensureInfo() => $_ensure(0);
}

class Unsubscribe extends $pb.GeneratedMessage {
  factory Unsubscribe({
    $core.int? code,
    $core.String? reason,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    return $result;
  }
  Unsubscribe._() : super();
  factory Unsubscribe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Unsubscribe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Unsubscribe', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'code', $pb.PbFieldType.OU3)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Unsubscribe clone() => Unsubscribe()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Unsubscribe copyWith(void Function(Unsubscribe) updates) => super.copyWith((message) => updates(message as Unsubscribe)) as Unsubscribe;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Unsubscribe create() => Unsubscribe._();
  Unsubscribe createEmptyInstance() => create();
  static $pb.PbList<Unsubscribe> createRepeated() => $pb.PbList<Unsubscribe>();
  @$core.pragma('dart2js:noInline')
  static Unsubscribe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Unsubscribe>(create);
  static Unsubscribe? _defaultInstance;

  @$pb.TagNumber(2)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(2)
  set code($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(2)
  void clearCode() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(3)
  set reason($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(3)
  void clearReason() => clearField(3);
}

class Subscribe extends $pb.GeneratedMessage {
  factory Subscribe({
    $core.bool? recoverable,
    $core.String? epoch,
    $fixnum.Int64? offset,
    $core.bool? positioned,
    $core.List<$core.int>? data,
  }) {
    final $result = create();
    if (recoverable != null) {
      $result.recoverable = recoverable;
    }
    if (epoch != null) {
      $result.epoch = epoch;
    }
    if (offset != null) {
      $result.offset = offset;
    }
    if (positioned != null) {
      $result.positioned = positioned;
    }
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  Subscribe._() : super();
  factory Subscribe.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Subscribe.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Subscribe', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'recoverable')
    ..aOS(4, _omitFieldNames ? '' : 'epoch')
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'offset', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(6, _omitFieldNames ? '' : 'positioned')
    ..a<$core.List<$core.int>>(7, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Subscribe clone() => Subscribe()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Subscribe copyWith(void Function(Subscribe) updates) => super.copyWith((message) => updates(message as Subscribe)) as Subscribe;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Subscribe create() => Subscribe._();
  Subscribe createEmptyInstance() => create();
  static $pb.PbList<Subscribe> createRepeated() => $pb.PbList<Subscribe>();
  @$core.pragma('dart2js:noInline')
  static Subscribe getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Subscribe>(create);
  static Subscribe? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get recoverable => $_getBF(0);
  @$pb.TagNumber(1)
  set recoverable($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRecoverable() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecoverable() => clearField(1);

  @$pb.TagNumber(4)
  $core.String get epoch => $_getSZ(1);
  @$pb.TagNumber(4)
  set epoch($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(4)
  $core.bool hasEpoch() => $_has(1);
  @$pb.TagNumber(4)
  void clearEpoch() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get offset => $_getI64(2);
  @$pb.TagNumber(5)
  set offset($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(5)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(5)
  void clearOffset() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get positioned => $_getBF(3);
  @$pb.TagNumber(6)
  set positioned($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(6)
  $core.bool hasPositioned() => $_has(3);
  @$pb.TagNumber(6)
  void clearPositioned() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<$core.int> get data => $_getN(4);
  @$pb.TagNumber(7)
  set data($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(7)
  $core.bool hasData() => $_has(4);
  @$pb.TagNumber(7)
  void clearData() => clearField(7);
}

class Message extends $pb.GeneratedMessage {
  factory Message({
    $core.List<$core.int>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  Message._() : super();
  factory Message.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Message.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Message', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Message clone() => Message()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Message copyWith(void Function(Message) updates) => super.copyWith((message) => updates(message as Message)) as Message;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Message create() => Message._();
  Message createEmptyInstance() => create();
  static $pb.PbList<Message> createRepeated() => $pb.PbList<Message>();
  @$core.pragma('dart2js:noInline')
  static Message getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Message>(create);
  static Message? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
}

class Connect extends $pb.GeneratedMessage {
  factory Connect({
    $core.String? client,
    $core.String? version,
    $core.List<$core.int>? data,
    $core.Map<$core.String, SubscribeResult>? subs,
    $core.bool? expires,
    $core.int? ttl,
    $core.int? ping,
    $core.bool? pong,
    $core.String? session,
    $core.String? node,
    $fixnum.Int64? time,
  }) {
    final $result = create();
    if (client != null) {
      $result.client = client;
    }
    if (version != null) {
      $result.version = version;
    }
    if (data != null) {
      $result.data = data;
    }
    if (subs != null) {
      $result.subs.addAll(subs);
    }
    if (expires != null) {
      $result.expires = expires;
    }
    if (ttl != null) {
      $result.ttl = ttl;
    }
    if (ping != null) {
      $result.ping = ping;
    }
    if (pong != null) {
      $result.pong = pong;
    }
    if (session != null) {
      $result.session = session;
    }
    if (node != null) {
      $result.node = node;
    }
    if (time != null) {
      $result.time = time;
    }
    return $result;
  }
  Connect._() : super();
  factory Connect.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Connect.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Connect', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'client')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..m<$core.String, SubscribeResult>(4, _omitFieldNames ? '' : 'subs', entryClassName: 'Connect.SubsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: SubscribeResult.create, valueDefaultOrMaker: SubscribeResult.getDefault, packageName: const $pb.PackageName('centrifugal.centrifuge.protocol'))
    ..aOB(5, _omitFieldNames ? '' : 'expires')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'ttl', $pb.PbFieldType.OU3)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'ping', $pb.PbFieldType.OU3)
    ..aOB(8, _omitFieldNames ? '' : 'pong')
    ..aOS(9, _omitFieldNames ? '' : 'session')
    ..aOS(10, _omitFieldNames ? '' : 'node')
    ..aInt64(11, _omitFieldNames ? '' : 'time')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Connect clone() => Connect()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Connect copyWith(void Function(Connect) updates) => super.copyWith((message) => updates(message as Connect)) as Connect;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Connect create() => Connect._();
  Connect createEmptyInstance() => create();
  static $pb.PbList<Connect> createRepeated() => $pb.PbList<Connect>();
  @$core.pragma('dart2js:noInline')
  static Connect getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Connect>(create);
  static Connect? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get client => $_getSZ(0);
  @$pb.TagNumber(1)
  set client($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasClient() => $_has(0);
  @$pb.TagNumber(1)
  void clearClient() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get data => $_getN(2);
  @$pb.TagNumber(3)
  set data($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasData() => $_has(2);
  @$pb.TagNumber(3)
  void clearData() => clearField(3);

  @$pb.TagNumber(4)
  $core.Map<$core.String, SubscribeResult> get subs => $_getMap(3);

  @$pb.TagNumber(5)
  $core.bool get expires => $_getBF(4);
  @$pb.TagNumber(5)
  set expires($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasExpires() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpires() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get ttl => $_getIZ(5);
  @$pb.TagNumber(6)
  set ttl($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTtl() => $_has(5);
  @$pb.TagNumber(6)
  void clearTtl() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get ping => $_getIZ(6);
  @$pb.TagNumber(7)
  set ping($core.int v) { $_setUnsignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasPing() => $_has(6);
  @$pb.TagNumber(7)
  void clearPing() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get pong => $_getBF(7);
  @$pb.TagNumber(8)
  set pong($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasPong() => $_has(7);
  @$pb.TagNumber(8)
  void clearPong() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get session => $_getSZ(8);
  @$pb.TagNumber(9)
  set session($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasSession() => $_has(8);
  @$pb.TagNumber(9)
  void clearSession() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get node => $_getSZ(9);
  @$pb.TagNumber(10)
  set node($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasNode() => $_has(9);
  @$pb.TagNumber(10)
  void clearNode() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get time => $_getI64(10);
  @$pb.TagNumber(11)
  set time($fixnum.Int64 v) { $_setInt64(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasTime() => $_has(10);
  @$pb.TagNumber(11)
  void clearTime() => clearField(11);
}

class Disconnect extends $pb.GeneratedMessage {
  factory Disconnect({
    $core.int? code,
    $core.String? reason,
    $core.bool? reconnect,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    if (reconnect != null) {
      $result.reconnect = reconnect;
    }
    return $result;
  }
  Disconnect._() : super();
  factory Disconnect.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Disconnect.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Disconnect', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aOB(3, _omitFieldNames ? '' : 'reconnect')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Disconnect clone() => Disconnect()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Disconnect copyWith(void Function(Disconnect) updates) => super.copyWith((message) => updates(message as Disconnect)) as Disconnect;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Disconnect create() => Disconnect._();
  Disconnect createEmptyInstance() => create();
  static $pb.PbList<Disconnect> createRepeated() => $pb.PbList<Disconnect>();
  @$core.pragma('dart2js:noInline')
  static Disconnect getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Disconnect>(create);
  static Disconnect? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get reconnect => $_getBF(2);
  @$pb.TagNumber(3)
  set reconnect($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasReconnect() => $_has(2);
  @$pb.TagNumber(3)
  void clearReconnect() => clearField(3);
}

class Refresh extends $pb.GeneratedMessage {
  factory Refresh({
    $core.bool? expires,
    $core.int? ttl,
  }) {
    final $result = create();
    if (expires != null) {
      $result.expires = expires;
    }
    if (ttl != null) {
      $result.ttl = ttl;
    }
    return $result;
  }
  Refresh._() : super();
  factory Refresh.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Refresh.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Refresh', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'expires')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'ttl', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Refresh clone() => Refresh()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Refresh copyWith(void Function(Refresh) updates) => super.copyWith((message) => updates(message as Refresh)) as Refresh;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Refresh create() => Refresh._();
  Refresh createEmptyInstance() => create();
  static $pb.PbList<Refresh> createRepeated() => $pb.PbList<Refresh>();
  @$core.pragma('dart2js:noInline')
  static Refresh getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Refresh>(create);
  static Refresh? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get expires => $_getBF(0);
  @$pb.TagNumber(1)
  set expires($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasExpires() => $_has(0);
  @$pb.TagNumber(1)
  void clearExpires() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get ttl => $_getIZ(1);
  @$pb.TagNumber(2)
  set ttl($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTtl() => $_has(1);
  @$pb.TagNumber(2)
  void clearTtl() => clearField(2);
}

class ConnectRequest extends $pb.GeneratedMessage {
  factory ConnectRequest({
    $core.String? token,
    $core.List<$core.int>? data,
    $core.Map<$core.String, SubscribeRequest>? subs,
    $core.String? name,
    $core.String? version,
    $core.Map<$core.String, $core.String>? headers,
  }) {
    final $result = create();
    if (token != null) {
      $result.token = token;
    }
    if (data != null) {
      $result.data = data;
    }
    if (subs != null) {
      $result.subs.addAll(subs);
    }
    if (name != null) {
      $result.name = name;
    }
    if (version != null) {
      $result.version = version;
    }
    if (headers != null) {
      $result.headers.addAll(headers);
    }
    return $result;
  }
  ConnectRequest._() : super();
  factory ConnectRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConnectRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..m<$core.String, SubscribeRequest>(3, _omitFieldNames ? '' : 'subs', entryClassName: 'ConnectRequest.SubsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: SubscribeRequest.create, valueDefaultOrMaker: SubscribeRequest.getDefault, packageName: const $pb.PackageName('centrifugal.centrifuge.protocol'))
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOS(5, _omitFieldNames ? '' : 'version')
    ..m<$core.String, $core.String>(6, _omitFieldNames ? '' : 'headers', entryClassName: 'ConnectRequest.HeadersEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('centrifugal.centrifuge.protocol'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectRequest clone() => ConnectRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectRequest copyWith(void Function(ConnectRequest) updates) => super.copyWith((message) => updates(message as ConnectRequest)) as ConnectRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectRequest create() => ConnectRequest._();
  ConnectRequest createEmptyInstance() => create();
  static $pb.PbList<ConnectRequest> createRepeated() => $pb.PbList<ConnectRequest>();
  @$core.pragma('dart2js:noInline')
  static ConnectRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectRequest>(create);
  static ConnectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);

  @$pb.TagNumber(3)
  $core.Map<$core.String, SubscribeRequest> get subs => $_getMap(2);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get version => $_getSZ(4);
  @$pb.TagNumber(5)
  set version($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearVersion() => clearField(5);

  @$pb.TagNumber(6)
  $core.Map<$core.String, $core.String> get headers => $_getMap(5);
}

class ConnectResult extends $pb.GeneratedMessage {
  factory ConnectResult({
    $core.String? client,
    $core.String? version,
    $core.bool? expires,
    $core.int? ttl,
    $core.List<$core.int>? data,
    $core.Map<$core.String, SubscribeResult>? subs,
    $core.int? ping,
    $core.bool? pong,
    $core.String? session,
    $core.String? node,
    $fixnum.Int64? time,
  }) {
    final $result = create();
    if (client != null) {
      $result.client = client;
    }
    if (version != null) {
      $result.version = version;
    }
    if (expires != null) {
      $result.expires = expires;
    }
    if (ttl != null) {
      $result.ttl = ttl;
    }
    if (data != null) {
      $result.data = data;
    }
    if (subs != null) {
      $result.subs.addAll(subs);
    }
    if (ping != null) {
      $result.ping = ping;
    }
    if (pong != null) {
      $result.pong = pong;
    }
    if (session != null) {
      $result.session = session;
    }
    if (node != null) {
      $result.node = node;
    }
    if (time != null) {
      $result.time = time;
    }
    return $result;
  }
  ConnectResult._() : super();
  factory ConnectResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConnectResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'client')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOB(3, _omitFieldNames ? '' : 'expires')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'ttl', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..m<$core.String, SubscribeResult>(6, _omitFieldNames ? '' : 'subs', entryClassName: 'ConnectResult.SubsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: SubscribeResult.create, valueDefaultOrMaker: SubscribeResult.getDefault, packageName: const $pb.PackageName('centrifugal.centrifuge.protocol'))
    ..a<$core.int>(7, _omitFieldNames ? '' : 'ping', $pb.PbFieldType.OU3)
    ..aOB(8, _omitFieldNames ? '' : 'pong')
    ..aOS(9, _omitFieldNames ? '' : 'session')
    ..aOS(10, _omitFieldNames ? '' : 'node')
    ..aInt64(11, _omitFieldNames ? '' : 'time')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectResult clone() => ConnectResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectResult copyWith(void Function(ConnectResult) updates) => super.copyWith((message) => updates(message as ConnectResult)) as ConnectResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectResult create() => ConnectResult._();
  ConnectResult createEmptyInstance() => create();
  static $pb.PbList<ConnectResult> createRepeated() => $pb.PbList<ConnectResult>();
  @$core.pragma('dart2js:noInline')
  static ConnectResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectResult>(create);
  static ConnectResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get client => $_getSZ(0);
  @$pb.TagNumber(1)
  set client($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasClient() => $_has(0);
  @$pb.TagNumber(1)
  void clearClient() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get expires => $_getBF(2);
  @$pb.TagNumber(3)
  set expires($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasExpires() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpires() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get ttl => $_getIZ(3);
  @$pb.TagNumber(4)
  set ttl($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTtl() => $_has(3);
  @$pb.TagNumber(4)
  void clearTtl() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get data => $_getN(4);
  @$pb.TagNumber(5)
  set data($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasData() => $_has(4);
  @$pb.TagNumber(5)
  void clearData() => clearField(5);

  @$pb.TagNumber(6)
  $core.Map<$core.String, SubscribeResult> get subs => $_getMap(5);

  @$pb.TagNumber(7)
  $core.int get ping => $_getIZ(6);
  @$pb.TagNumber(7)
  set ping($core.int v) { $_setUnsignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasPing() => $_has(6);
  @$pb.TagNumber(7)
  void clearPing() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get pong => $_getBF(7);
  @$pb.TagNumber(8)
  set pong($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasPong() => $_has(7);
  @$pb.TagNumber(8)
  void clearPong() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get session => $_getSZ(8);
  @$pb.TagNumber(9)
  set session($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasSession() => $_has(8);
  @$pb.TagNumber(9)
  void clearSession() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get node => $_getSZ(9);
  @$pb.TagNumber(10)
  set node($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasNode() => $_has(9);
  @$pb.TagNumber(10)
  void clearNode() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get time => $_getI64(10);
  @$pb.TagNumber(11)
  set time($fixnum.Int64 v) { $_setInt64(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasTime() => $_has(10);
  @$pb.TagNumber(11)
  void clearTime() => clearField(11);
}

class RefreshRequest extends $pb.GeneratedMessage {
  factory RefreshRequest({
    $core.String? token,
  }) {
    final $result = create();
    if (token != null) {
      $result.token = token;
    }
    return $result;
  }
  RefreshRequest._() : super();
  factory RefreshRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RefreshRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RefreshRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RefreshRequest clone() => RefreshRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RefreshRequest copyWith(void Function(RefreshRequest) updates) => super.copyWith((message) => updates(message as RefreshRequest)) as RefreshRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RefreshRequest create() => RefreshRequest._();
  RefreshRequest createEmptyInstance() => create();
  static $pb.PbList<RefreshRequest> createRepeated() => $pb.PbList<RefreshRequest>();
  @$core.pragma('dart2js:noInline')
  static RefreshRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RefreshRequest>(create);
  static RefreshRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);
}

class RefreshResult extends $pb.GeneratedMessage {
  factory RefreshResult({
    $core.String? client,
    $core.String? version,
    $core.bool? expires,
    $core.int? ttl,
  }) {
    final $result = create();
    if (client != null) {
      $result.client = client;
    }
    if (version != null) {
      $result.version = version;
    }
    if (expires != null) {
      $result.expires = expires;
    }
    if (ttl != null) {
      $result.ttl = ttl;
    }
    return $result;
  }
  RefreshResult._() : super();
  factory RefreshResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RefreshResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RefreshResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'client')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOB(3, _omitFieldNames ? '' : 'expires')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'ttl', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RefreshResult clone() => RefreshResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RefreshResult copyWith(void Function(RefreshResult) updates) => super.copyWith((message) => updates(message as RefreshResult)) as RefreshResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RefreshResult create() => RefreshResult._();
  RefreshResult createEmptyInstance() => create();
  static $pb.PbList<RefreshResult> createRepeated() => $pb.PbList<RefreshResult>();
  @$core.pragma('dart2js:noInline')
  static RefreshResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RefreshResult>(create);
  static RefreshResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get client => $_getSZ(0);
  @$pb.TagNumber(1)
  set client($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasClient() => $_has(0);
  @$pb.TagNumber(1)
  void clearClient() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get expires => $_getBF(2);
  @$pb.TagNumber(3)
  set expires($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasExpires() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpires() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get ttl => $_getIZ(3);
  @$pb.TagNumber(4)
  set ttl($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTtl() => $_has(3);
  @$pb.TagNumber(4)
  void clearTtl() => clearField(4);
}

class SubscribeRequest extends $pb.GeneratedMessage {
  factory SubscribeRequest({
    $core.String? channel,
    $core.String? token,
    $core.bool? recover,
    $core.String? epoch,
    $fixnum.Int64? offset,
    $core.List<$core.int>? data,
    $core.bool? positioned,
    $core.bool? recoverable,
    $core.bool? joinLeave,
    $core.String? delta,
  }) {
    final $result = create();
    if (channel != null) {
      $result.channel = channel;
    }
    if (token != null) {
      $result.token = token;
    }
    if (recover != null) {
      $result.recover = recover;
    }
    if (epoch != null) {
      $result.epoch = epoch;
    }
    if (offset != null) {
      $result.offset = offset;
    }
    if (data != null) {
      $result.data = data;
    }
    if (positioned != null) {
      $result.positioned = positioned;
    }
    if (recoverable != null) {
      $result.recoverable = recoverable;
    }
    if (joinLeave != null) {
      $result.joinLeave = joinLeave;
    }
    if (delta != null) {
      $result.delta = delta;
    }
    return $result;
  }
  SubscribeRequest._() : super();
  factory SubscribeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubscribeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubscribeRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'channel')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..aOB(3, _omitFieldNames ? '' : 'recover')
    ..aOS(6, _omitFieldNames ? '' : 'epoch')
    ..a<$fixnum.Int64>(7, _omitFieldNames ? '' : 'offset', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.List<$core.int>>(8, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aOB(9, _omitFieldNames ? '' : 'positioned')
    ..aOB(10, _omitFieldNames ? '' : 'recoverable')
    ..aOB(11, _omitFieldNames ? '' : 'joinLeave')
    ..aOS(12, _omitFieldNames ? '' : 'delta')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubscribeRequest clone() => SubscribeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubscribeRequest copyWith(void Function(SubscribeRequest) updates) => super.copyWith((message) => updates(message as SubscribeRequest)) as SubscribeRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubscribeRequest create() => SubscribeRequest._();
  SubscribeRequest createEmptyInstance() => create();
  static $pb.PbList<SubscribeRequest> createRepeated() => $pb.PbList<SubscribeRequest>();
  @$core.pragma('dart2js:noInline')
  static SubscribeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubscribeRequest>(create);
  static SubscribeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channel => $_getSZ(0);
  @$pb.TagNumber(1)
  set channel($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get recover => $_getBF(2);
  @$pb.TagNumber(3)
  set recover($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRecover() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecover() => clearField(3);

  @$pb.TagNumber(6)
  $core.String get epoch => $_getSZ(3);
  @$pb.TagNumber(6)
  set epoch($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(6)
  $core.bool hasEpoch() => $_has(3);
  @$pb.TagNumber(6)
  void clearEpoch() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get offset => $_getI64(4);
  @$pb.TagNumber(7)
  set offset($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(7)
  $core.bool hasOffset() => $_has(4);
  @$pb.TagNumber(7)
  void clearOffset() => clearField(7);

  @$pb.TagNumber(8)
  $core.List<$core.int> get data => $_getN(5);
  @$pb.TagNumber(8)
  set data($core.List<$core.int> v) { $_setBytes(5, v); }
  @$pb.TagNumber(8)
  $core.bool hasData() => $_has(5);
  @$pb.TagNumber(8)
  void clearData() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get positioned => $_getBF(6);
  @$pb.TagNumber(9)
  set positioned($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(9)
  $core.bool hasPositioned() => $_has(6);
  @$pb.TagNumber(9)
  void clearPositioned() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get recoverable => $_getBF(7);
  @$pb.TagNumber(10)
  set recoverable($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(10)
  $core.bool hasRecoverable() => $_has(7);
  @$pb.TagNumber(10)
  void clearRecoverable() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get joinLeave => $_getBF(8);
  @$pb.TagNumber(11)
  set joinLeave($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(11)
  $core.bool hasJoinLeave() => $_has(8);
  @$pb.TagNumber(11)
  void clearJoinLeave() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get delta => $_getSZ(9);
  @$pb.TagNumber(12)
  set delta($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(12)
  $core.bool hasDelta() => $_has(9);
  @$pb.TagNumber(12)
  void clearDelta() => clearField(12);
}

class SubscribeResult extends $pb.GeneratedMessage {
  factory SubscribeResult({
    $core.bool? expires,
    $core.int? ttl,
    $core.bool? recoverable,
    $core.String? epoch,
    $core.Iterable<Publication>? publications,
    $core.bool? recovered,
    $fixnum.Int64? offset,
    $core.bool? positioned,
    $core.List<$core.int>? data,
    $core.bool? wasRecovering,
    $core.bool? delta,
  }) {
    final $result = create();
    if (expires != null) {
      $result.expires = expires;
    }
    if (ttl != null) {
      $result.ttl = ttl;
    }
    if (recoverable != null) {
      $result.recoverable = recoverable;
    }
    if (epoch != null) {
      $result.epoch = epoch;
    }
    if (publications != null) {
      $result.publications.addAll(publications);
    }
    if (recovered != null) {
      $result.recovered = recovered;
    }
    if (offset != null) {
      $result.offset = offset;
    }
    if (positioned != null) {
      $result.positioned = positioned;
    }
    if (data != null) {
      $result.data = data;
    }
    if (wasRecovering != null) {
      $result.wasRecovering = wasRecovering;
    }
    if (delta != null) {
      $result.delta = delta;
    }
    return $result;
  }
  SubscribeResult._() : super();
  factory SubscribeResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubscribeResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubscribeResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'expires')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'ttl', $pb.PbFieldType.OU3)
    ..aOB(3, _omitFieldNames ? '' : 'recoverable')
    ..aOS(6, _omitFieldNames ? '' : 'epoch')
    ..pc<Publication>(7, _omitFieldNames ? '' : 'publications', $pb.PbFieldType.PM, subBuilder: Publication.create)
    ..aOB(8, _omitFieldNames ? '' : 'recovered')
    ..a<$fixnum.Int64>(9, _omitFieldNames ? '' : 'offset', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(10, _omitFieldNames ? '' : 'positioned')
    ..a<$core.List<$core.int>>(11, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aOB(12, _omitFieldNames ? '' : 'wasRecovering')
    ..aOB(13, _omitFieldNames ? '' : 'delta')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubscribeResult clone() => SubscribeResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubscribeResult copyWith(void Function(SubscribeResult) updates) => super.copyWith((message) => updates(message as SubscribeResult)) as SubscribeResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubscribeResult create() => SubscribeResult._();
  SubscribeResult createEmptyInstance() => create();
  static $pb.PbList<SubscribeResult> createRepeated() => $pb.PbList<SubscribeResult>();
  @$core.pragma('dart2js:noInline')
  static SubscribeResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubscribeResult>(create);
  static SubscribeResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get expires => $_getBF(0);
  @$pb.TagNumber(1)
  set expires($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasExpires() => $_has(0);
  @$pb.TagNumber(1)
  void clearExpires() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get ttl => $_getIZ(1);
  @$pb.TagNumber(2)
  set ttl($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTtl() => $_has(1);
  @$pb.TagNumber(2)
  void clearTtl() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get recoverable => $_getBF(2);
  @$pb.TagNumber(3)
  set recoverable($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRecoverable() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecoverable() => clearField(3);

  @$pb.TagNumber(6)
  $core.String get epoch => $_getSZ(3);
  @$pb.TagNumber(6)
  set epoch($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(6)
  $core.bool hasEpoch() => $_has(3);
  @$pb.TagNumber(6)
  void clearEpoch() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<Publication> get publications => $_getList(4);

  @$pb.TagNumber(8)
  $core.bool get recovered => $_getBF(5);
  @$pb.TagNumber(8)
  set recovered($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(8)
  $core.bool hasRecovered() => $_has(5);
  @$pb.TagNumber(8)
  void clearRecovered() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get offset => $_getI64(6);
  @$pb.TagNumber(9)
  set offset($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(9)
  $core.bool hasOffset() => $_has(6);
  @$pb.TagNumber(9)
  void clearOffset() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get positioned => $_getBF(7);
  @$pb.TagNumber(10)
  set positioned($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(10)
  $core.bool hasPositioned() => $_has(7);
  @$pb.TagNumber(10)
  void clearPositioned() => clearField(10);

  @$pb.TagNumber(11)
  $core.List<$core.int> get data => $_getN(8);
  @$pb.TagNumber(11)
  set data($core.List<$core.int> v) { $_setBytes(8, v); }
  @$pb.TagNumber(11)
  $core.bool hasData() => $_has(8);
  @$pb.TagNumber(11)
  void clearData() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get wasRecovering => $_getBF(9);
  @$pb.TagNumber(12)
  set wasRecovering($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(12)
  $core.bool hasWasRecovering() => $_has(9);
  @$pb.TagNumber(12)
  void clearWasRecovering() => clearField(12);

  @$pb.TagNumber(13)
  $core.bool get delta => $_getBF(10);
  @$pb.TagNumber(13)
  set delta($core.bool v) { $_setBool(10, v); }
  @$pb.TagNumber(13)
  $core.bool hasDelta() => $_has(10);
  @$pb.TagNumber(13)
  void clearDelta() => clearField(13);
}

class SubRefreshRequest extends $pb.GeneratedMessage {
  factory SubRefreshRequest({
    $core.String? channel,
    $core.String? token,
  }) {
    final $result = create();
    if (channel != null) {
      $result.channel = channel;
    }
    if (token != null) {
      $result.token = token;
    }
    return $result;
  }
  SubRefreshRequest._() : super();
  factory SubRefreshRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubRefreshRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubRefreshRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'channel')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubRefreshRequest clone() => SubRefreshRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubRefreshRequest copyWith(void Function(SubRefreshRequest) updates) => super.copyWith((message) => updates(message as SubRefreshRequest)) as SubRefreshRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubRefreshRequest create() => SubRefreshRequest._();
  SubRefreshRequest createEmptyInstance() => create();
  static $pb.PbList<SubRefreshRequest> createRepeated() => $pb.PbList<SubRefreshRequest>();
  @$core.pragma('dart2js:noInline')
  static SubRefreshRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubRefreshRequest>(create);
  static SubRefreshRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channel => $_getSZ(0);
  @$pb.TagNumber(1)
  set channel($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);
}

class SubRefreshResult extends $pb.GeneratedMessage {
  factory SubRefreshResult({
    $core.bool? expires,
    $core.int? ttl,
  }) {
    final $result = create();
    if (expires != null) {
      $result.expires = expires;
    }
    if (ttl != null) {
      $result.ttl = ttl;
    }
    return $result;
  }
  SubRefreshResult._() : super();
  factory SubRefreshResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubRefreshResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubRefreshResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'expires')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'ttl', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubRefreshResult clone() => SubRefreshResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubRefreshResult copyWith(void Function(SubRefreshResult) updates) => super.copyWith((message) => updates(message as SubRefreshResult)) as SubRefreshResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubRefreshResult create() => SubRefreshResult._();
  SubRefreshResult createEmptyInstance() => create();
  static $pb.PbList<SubRefreshResult> createRepeated() => $pb.PbList<SubRefreshResult>();
  @$core.pragma('dart2js:noInline')
  static SubRefreshResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubRefreshResult>(create);
  static SubRefreshResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get expires => $_getBF(0);
  @$pb.TagNumber(1)
  set expires($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasExpires() => $_has(0);
  @$pb.TagNumber(1)
  void clearExpires() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get ttl => $_getIZ(1);
  @$pb.TagNumber(2)
  set ttl($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTtl() => $_has(1);
  @$pb.TagNumber(2)
  void clearTtl() => clearField(2);
}

class UnsubscribeRequest extends $pb.GeneratedMessage {
  factory UnsubscribeRequest({
    $core.String? channel,
  }) {
    final $result = create();
    if (channel != null) {
      $result.channel = channel;
    }
    return $result;
  }
  UnsubscribeRequest._() : super();
  factory UnsubscribeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UnsubscribeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UnsubscribeRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'channel')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UnsubscribeRequest clone() => UnsubscribeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UnsubscribeRequest copyWith(void Function(UnsubscribeRequest) updates) => super.copyWith((message) => updates(message as UnsubscribeRequest)) as UnsubscribeRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnsubscribeRequest create() => UnsubscribeRequest._();
  UnsubscribeRequest createEmptyInstance() => create();
  static $pb.PbList<UnsubscribeRequest> createRepeated() => $pb.PbList<UnsubscribeRequest>();
  @$core.pragma('dart2js:noInline')
  static UnsubscribeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnsubscribeRequest>(create);
  static UnsubscribeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channel => $_getSZ(0);
  @$pb.TagNumber(1)
  set channel($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => clearField(1);
}

class UnsubscribeResult extends $pb.GeneratedMessage {
  factory UnsubscribeResult() => create();
  UnsubscribeResult._() : super();
  factory UnsubscribeResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UnsubscribeResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UnsubscribeResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UnsubscribeResult clone() => UnsubscribeResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UnsubscribeResult copyWith(void Function(UnsubscribeResult) updates) => super.copyWith((message) => updates(message as UnsubscribeResult)) as UnsubscribeResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnsubscribeResult create() => UnsubscribeResult._();
  UnsubscribeResult createEmptyInstance() => create();
  static $pb.PbList<UnsubscribeResult> createRepeated() => $pb.PbList<UnsubscribeResult>();
  @$core.pragma('dart2js:noInline')
  static UnsubscribeResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnsubscribeResult>(create);
  static UnsubscribeResult? _defaultInstance;
}

class PublishRequest extends $pb.GeneratedMessage {
  factory PublishRequest({
    $core.String? channel,
    $core.List<$core.int>? data,
  }) {
    final $result = create();
    if (channel != null) {
      $result.channel = channel;
    }
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  PublishRequest._() : super();
  factory PublishRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PublishRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PublishRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'channel')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PublishRequest clone() => PublishRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PublishRequest copyWith(void Function(PublishRequest) updates) => super.copyWith((message) => updates(message as PublishRequest)) as PublishRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublishRequest create() => PublishRequest._();
  PublishRequest createEmptyInstance() => create();
  static $pb.PbList<PublishRequest> createRepeated() => $pb.PbList<PublishRequest>();
  @$core.pragma('dart2js:noInline')
  static PublishRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PublishRequest>(create);
  static PublishRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channel => $_getSZ(0);
  @$pb.TagNumber(1)
  set channel($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);
}

class PublishResult extends $pb.GeneratedMessage {
  factory PublishResult() => create();
  PublishResult._() : super();
  factory PublishResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PublishResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PublishResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PublishResult clone() => PublishResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PublishResult copyWith(void Function(PublishResult) updates) => super.copyWith((message) => updates(message as PublishResult)) as PublishResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublishResult create() => PublishResult._();
  PublishResult createEmptyInstance() => create();
  static $pb.PbList<PublishResult> createRepeated() => $pb.PbList<PublishResult>();
  @$core.pragma('dart2js:noInline')
  static PublishResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PublishResult>(create);
  static PublishResult? _defaultInstance;
}

class PresenceRequest extends $pb.GeneratedMessage {
  factory PresenceRequest({
    $core.String? channel,
  }) {
    final $result = create();
    if (channel != null) {
      $result.channel = channel;
    }
    return $result;
  }
  PresenceRequest._() : super();
  factory PresenceRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PresenceRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PresenceRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'channel')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PresenceRequest clone() => PresenceRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PresenceRequest copyWith(void Function(PresenceRequest) updates) => super.copyWith((message) => updates(message as PresenceRequest)) as PresenceRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PresenceRequest create() => PresenceRequest._();
  PresenceRequest createEmptyInstance() => create();
  static $pb.PbList<PresenceRequest> createRepeated() => $pb.PbList<PresenceRequest>();
  @$core.pragma('dart2js:noInline')
  static PresenceRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PresenceRequest>(create);
  static PresenceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channel => $_getSZ(0);
  @$pb.TagNumber(1)
  set channel($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => clearField(1);
}

class PresenceResult extends $pb.GeneratedMessage {
  factory PresenceResult({
    $core.Map<$core.String, ClientInfo>? presence,
  }) {
    final $result = create();
    if (presence != null) {
      $result.presence.addAll(presence);
    }
    return $result;
  }
  PresenceResult._() : super();
  factory PresenceResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PresenceResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PresenceResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..m<$core.String, ClientInfo>(1, _omitFieldNames ? '' : 'presence', entryClassName: 'PresenceResult.PresenceEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: ClientInfo.create, valueDefaultOrMaker: ClientInfo.getDefault, packageName: const $pb.PackageName('centrifugal.centrifuge.protocol'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PresenceResult clone() => PresenceResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PresenceResult copyWith(void Function(PresenceResult) updates) => super.copyWith((message) => updates(message as PresenceResult)) as PresenceResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PresenceResult create() => PresenceResult._();
  PresenceResult createEmptyInstance() => create();
  static $pb.PbList<PresenceResult> createRepeated() => $pb.PbList<PresenceResult>();
  @$core.pragma('dart2js:noInline')
  static PresenceResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PresenceResult>(create);
  static PresenceResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.String, ClientInfo> get presence => $_getMap(0);
}

class PresenceStatsRequest extends $pb.GeneratedMessage {
  factory PresenceStatsRequest({
    $core.String? channel,
  }) {
    final $result = create();
    if (channel != null) {
      $result.channel = channel;
    }
    return $result;
  }
  PresenceStatsRequest._() : super();
  factory PresenceStatsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PresenceStatsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PresenceStatsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'channel')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PresenceStatsRequest clone() => PresenceStatsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PresenceStatsRequest copyWith(void Function(PresenceStatsRequest) updates) => super.copyWith((message) => updates(message as PresenceStatsRequest)) as PresenceStatsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PresenceStatsRequest create() => PresenceStatsRequest._();
  PresenceStatsRequest createEmptyInstance() => create();
  static $pb.PbList<PresenceStatsRequest> createRepeated() => $pb.PbList<PresenceStatsRequest>();
  @$core.pragma('dart2js:noInline')
  static PresenceStatsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PresenceStatsRequest>(create);
  static PresenceStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channel => $_getSZ(0);
  @$pb.TagNumber(1)
  set channel($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => clearField(1);
}

class PresenceStatsResult extends $pb.GeneratedMessage {
  factory PresenceStatsResult({
    $core.int? numClients,
    $core.int? numUsers,
  }) {
    final $result = create();
    if (numClients != null) {
      $result.numClients = numClients;
    }
    if (numUsers != null) {
      $result.numUsers = numUsers;
    }
    return $result;
  }
  PresenceStatsResult._() : super();
  factory PresenceStatsResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PresenceStatsResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PresenceStatsResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'numClients', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'numUsers', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PresenceStatsResult clone() => PresenceStatsResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PresenceStatsResult copyWith(void Function(PresenceStatsResult) updates) => super.copyWith((message) => updates(message as PresenceStatsResult)) as PresenceStatsResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PresenceStatsResult create() => PresenceStatsResult._();
  PresenceStatsResult createEmptyInstance() => create();
  static $pb.PbList<PresenceStatsResult> createRepeated() => $pb.PbList<PresenceStatsResult>();
  @$core.pragma('dart2js:noInline')
  static PresenceStatsResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PresenceStatsResult>(create);
  static PresenceStatsResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get numClients => $_getIZ(0);
  @$pb.TagNumber(1)
  set numClients($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNumClients() => $_has(0);
  @$pb.TagNumber(1)
  void clearNumClients() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get numUsers => $_getIZ(1);
  @$pb.TagNumber(2)
  set numUsers($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNumUsers() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumUsers() => clearField(2);
}

class StreamPosition extends $pb.GeneratedMessage {
  factory StreamPosition({
    $fixnum.Int64? offset,
    $core.String? epoch,
  }) {
    final $result = create();
    if (offset != null) {
      $result.offset = offset;
    }
    if (epoch != null) {
      $result.epoch = epoch;
    }
    return $result;
  }
  StreamPosition._() : super();
  factory StreamPosition.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StreamPosition.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StreamPosition', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'offset', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'epoch')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StreamPosition clone() => StreamPosition()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StreamPosition copyWith(void Function(StreamPosition) updates) => super.copyWith((message) => updates(message as StreamPosition)) as StreamPosition;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamPosition create() => StreamPosition._();
  StreamPosition createEmptyInstance() => create();
  static $pb.PbList<StreamPosition> createRepeated() => $pb.PbList<StreamPosition>();
  @$core.pragma('dart2js:noInline')
  static StreamPosition getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StreamPosition>(create);
  static StreamPosition? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get offset => $_getI64(0);
  @$pb.TagNumber(1)
  set offset($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOffset() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffset() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get epoch => $_getSZ(1);
  @$pb.TagNumber(2)
  set epoch($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEpoch() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpoch() => clearField(2);
}

class HistoryRequest extends $pb.GeneratedMessage {
  factory HistoryRequest({
    $core.String? channel,
    $core.int? limit,
    StreamPosition? since,
    $core.bool? reverse,
  }) {
    final $result = create();
    if (channel != null) {
      $result.channel = channel;
    }
    if (limit != null) {
      $result.limit = limit;
    }
    if (since != null) {
      $result.since = since;
    }
    if (reverse != null) {
      $result.reverse = reverse;
    }
    return $result;
  }
  HistoryRequest._() : super();
  factory HistoryRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HistoryRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HistoryRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'channel')
    ..a<$core.int>(7, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..aOM<StreamPosition>(8, _omitFieldNames ? '' : 'since', subBuilder: StreamPosition.create)
    ..aOB(9, _omitFieldNames ? '' : 'reverse')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HistoryRequest clone() => HistoryRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HistoryRequest copyWith(void Function(HistoryRequest) updates) => super.copyWith((message) => updates(message as HistoryRequest)) as HistoryRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HistoryRequest create() => HistoryRequest._();
  HistoryRequest createEmptyInstance() => create();
  static $pb.PbList<HistoryRequest> createRepeated() => $pb.PbList<HistoryRequest>();
  @$core.pragma('dart2js:noInline')
  static HistoryRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HistoryRequest>(create);
  static HistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channel => $_getSZ(0);
  @$pb.TagNumber(1)
  set channel($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => clearField(1);

  @$pb.TagNumber(7)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(7)
  set limit($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(7)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(7)
  void clearLimit() => clearField(7);

  @$pb.TagNumber(8)
  StreamPosition get since => $_getN(2);
  @$pb.TagNumber(8)
  set since(StreamPosition v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasSince() => $_has(2);
  @$pb.TagNumber(8)
  void clearSince() => clearField(8);
  @$pb.TagNumber(8)
  StreamPosition ensureSince() => $_ensure(2);

  @$pb.TagNumber(9)
  $core.bool get reverse => $_getBF(3);
  @$pb.TagNumber(9)
  set reverse($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(9)
  $core.bool hasReverse() => $_has(3);
  @$pb.TagNumber(9)
  void clearReverse() => clearField(9);
}

class HistoryResult extends $pb.GeneratedMessage {
  factory HistoryResult({
    $core.Iterable<Publication>? publications,
    $core.String? epoch,
    $fixnum.Int64? offset,
  }) {
    final $result = create();
    if (publications != null) {
      $result.publications.addAll(publications);
    }
    if (epoch != null) {
      $result.epoch = epoch;
    }
    if (offset != null) {
      $result.offset = offset;
    }
    return $result;
  }
  HistoryResult._() : super();
  factory HistoryResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HistoryResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HistoryResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..pc<Publication>(1, _omitFieldNames ? '' : 'publications', $pb.PbFieldType.PM, subBuilder: Publication.create)
    ..aOS(2, _omitFieldNames ? '' : 'epoch')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'offset', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HistoryResult clone() => HistoryResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HistoryResult copyWith(void Function(HistoryResult) updates) => super.copyWith((message) => updates(message as HistoryResult)) as HistoryResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HistoryResult create() => HistoryResult._();
  HistoryResult createEmptyInstance() => create();
  static $pb.PbList<HistoryResult> createRepeated() => $pb.PbList<HistoryResult>();
  @$core.pragma('dart2js:noInline')
  static HistoryResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HistoryResult>(create);
  static HistoryResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Publication> get publications => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get epoch => $_getSZ(1);
  @$pb.TagNumber(2)
  set epoch($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEpoch() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpoch() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get offset => $_getI64(2);
  @$pb.TagNumber(3)
  set offset($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => clearField(3);
}

class PingRequest extends $pb.GeneratedMessage {
  factory PingRequest() => create();
  PingRequest._() : super();
  factory PingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PingRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PingRequest clone() => PingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PingRequest copyWith(void Function(PingRequest) updates) => super.copyWith((message) => updates(message as PingRequest)) as PingRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PingRequest create() => PingRequest._();
  PingRequest createEmptyInstance() => create();
  static $pb.PbList<PingRequest> createRepeated() => $pb.PbList<PingRequest>();
  @$core.pragma('dart2js:noInline')
  static PingRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PingRequest>(create);
  static PingRequest? _defaultInstance;
}

class PingResult extends $pb.GeneratedMessage {
  factory PingResult() => create();
  PingResult._() : super();
  factory PingResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PingResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PingResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PingResult clone() => PingResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PingResult copyWith(void Function(PingResult) updates) => super.copyWith((message) => updates(message as PingResult)) as PingResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PingResult create() => PingResult._();
  PingResult createEmptyInstance() => create();
  static $pb.PbList<PingResult> createRepeated() => $pb.PbList<PingResult>();
  @$core.pragma('dart2js:noInline')
  static PingResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PingResult>(create);
  static PingResult? _defaultInstance;
}

class RPCRequest extends $pb.GeneratedMessage {
  factory RPCRequest({
    $core.List<$core.int>? data,
    $core.String? method,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    if (method != null) {
      $result.method = method;
    }
    return $result;
  }
  RPCRequest._() : super();
  factory RPCRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RPCRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RPCRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'method')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RPCRequest clone() => RPCRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RPCRequest copyWith(void Function(RPCRequest) updates) => super.copyWith((message) => updates(message as RPCRequest)) as RPCRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RPCRequest create() => RPCRequest._();
  RPCRequest createEmptyInstance() => create();
  static $pb.PbList<RPCRequest> createRepeated() => $pb.PbList<RPCRequest>();
  @$core.pragma('dart2js:noInline')
  static RPCRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RPCRequest>(create);
  static RPCRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get method => $_getSZ(1);
  @$pb.TagNumber(2)
  set method($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMethod() => $_has(1);
  @$pb.TagNumber(2)
  void clearMethod() => clearField(2);
}

class RPCResult extends $pb.GeneratedMessage {
  factory RPCResult({
    $core.List<$core.int>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  RPCResult._() : super();
  factory RPCResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RPCResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RPCResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RPCResult clone() => RPCResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RPCResult copyWith(void Function(RPCResult) updates) => super.copyWith((message) => updates(message as RPCResult)) as RPCResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RPCResult create() => RPCResult._();
  RPCResult createEmptyInstance() => create();
  static $pb.PbList<RPCResult> createRepeated() => $pb.PbList<RPCResult>();
  @$core.pragma('dart2js:noInline')
  static RPCResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RPCResult>(create);
  static RPCResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
}

class SendRequest extends $pb.GeneratedMessage {
  factory SendRequest({
    $core.List<$core.int>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  SendRequest._() : super();
  factory SendRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SendRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SendRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'centrifugal.centrifuge.protocol'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SendRequest clone() => SendRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SendRequest copyWith(void Function(SendRequest) updates) => super.copyWith((message) => updates(message as SendRequest)) as SendRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendRequest create() => SendRequest._();
  SendRequest createEmptyInstance() => create();
  static $pb.PbList<SendRequest> createRepeated() => $pb.PbList<SendRequest>();
  @$core.pragma('dart2js:noInline')
  static SendRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SendRequest>(create);
  static SendRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
