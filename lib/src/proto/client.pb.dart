///
//  Generated code. Do not modify.
//  source: client.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'client.pbenum.dart';

export 'client.pbenum.dart';

class Error extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Error',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..a<$core.int>(1, 'code', $pb.PbFieldType.OU3)
    ..aOS(2, 'message')
    ..hasRequiredFields = false;

  Error._() : super();
  factory Error() => create();
  factory Error.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Error.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Error clone() => Error()..mergeFromMessage(this);
  Error copyWith(void Function(Error) updates) =>
      super.copyWith((message) => updates(message as Error));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Error create() => Error._();
  Error createEmptyInstance() => create();
  static $pb.PbList<Error> createRepeated() => $pb.PbList<Error>();
  @$core.pragma('dart2js:noInline')
  static Error getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Error>(create);
  static Error _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class Command extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Command',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..a<$core.int>(1, 'id', $pb.PbFieldType.OU3)
    ..e<MethodType>(2, 'method', $pb.PbFieldType.OE,
        defaultOrMaker: MethodType.CONNECT,
        valueOf: MethodType.valueOf,
        enumValues: MethodType.values)
    ..a<$core.List<$core.int>>(3, 'params', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  Command._() : super();
  factory Command() => create();
  factory Command.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Command.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Command clone() => Command()..mergeFromMessage(this);
  Command copyWith(void Function(Command) updates) =>
      super.copyWith((message) => updates(message as Command));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Command create() => Command._();
  Command createEmptyInstance() => create();
  static $pb.PbList<Command> createRepeated() => $pb.PbList<Command>();
  @$core.pragma('dart2js:noInline')
  static Command getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Command>(create);
  static Command _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  MethodType get method => $_getN(1);
  @$pb.TagNumber(2)
  set method(MethodType v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMethod() => $_has(1);
  @$pb.TagNumber(2)
  void clearMethod() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get params => $_getN(2);
  @$pb.TagNumber(3)
  set params($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasParams() => $_has(2);
  @$pb.TagNumber(3)
  void clearParams() => clearField(3);
}

class Reply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Reply',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..a<$core.int>(1, 'id', $pb.PbFieldType.OU3)
    ..aOM<Error>(2, 'error', subBuilder: Error.create)
    ..a<$core.List<$core.int>>(3, 'result', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  Reply._() : super();
  factory Reply() => create();
  factory Reply.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Reply.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Reply clone() => Reply()..mergeFromMessage(this);
  Reply copyWith(void Function(Reply) updates) =>
      super.copyWith((message) => updates(message as Reply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Reply create() => Reply._();
  Reply createEmptyInstance() => create();
  static $pb.PbList<Reply> createRepeated() => $pb.PbList<Reply>();
  @$core.pragma('dart2js:noInline')
  static Reply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Reply>(create);
  static Reply _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  Error get error => $_getN(1);
  @$pb.TagNumber(2)
  set error(Error v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => clearField(2);
  @$pb.TagNumber(2)
  Error ensureError() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.List<$core.int> get result => $_getN(2);
  @$pb.TagNumber(3)
  set result($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasResult() => $_has(2);
  @$pb.TagNumber(3)
  void clearResult() => clearField(3);
}

class Push extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Push',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..e<PushType>(1, 'type', $pb.PbFieldType.OE,
        defaultOrMaker: PushType.PUBLICATION,
        valueOf: PushType.valueOf,
        enumValues: PushType.values)
    ..aOS(2, 'channel')
    ..a<$core.List<$core.int>>(3, 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  Push._() : super();
  factory Push() => create();
  factory Push.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Push.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Push clone() => Push()..mergeFromMessage(this);
  Push copyWith(void Function(Push) updates) =>
      super.copyWith((message) => updates(message as Push));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Push create() => Push._();
  Push createEmptyInstance() => create();
  static $pb.PbList<Push> createRepeated() => $pb.PbList<Push>();
  @$core.pragma('dart2js:noInline')
  static Push getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Push>(create);
  static Push _defaultInstance;

  @$pb.TagNumber(1)
  PushType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(PushType v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get channel => $_getSZ(1);
  @$pb.TagNumber(2)
  set channel($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasChannel() => $_has(1);
  @$pb.TagNumber(2)
  void clearChannel() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get data => $_getN(2);
  @$pb.TagNumber(3)
  set data($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasData() => $_has(2);
  @$pb.TagNumber(3)
  void clearData() => clearField(3);
}

class ClientInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ClientInfo',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..aOS(1, 'user')
    ..aOS(2, 'client')
    ..a<$core.List<$core.int>>(3, 'connInfo', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(4, 'chanInfo', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  ClientInfo._() : super();
  factory ClientInfo() => create();
  factory ClientInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ClientInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  ClientInfo clone() => ClientInfo()..mergeFromMessage(this);
  ClientInfo copyWith(void Function(ClientInfo) updates) =>
      super.copyWith((message) => updates(message as ClientInfo));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ClientInfo create() => ClientInfo._();
  ClientInfo createEmptyInstance() => create();
  static $pb.PbList<ClientInfo> createRepeated() => $pb.PbList<ClientInfo>();
  @$core.pragma('dart2js:noInline')
  static ClientInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClientInfo>(create);
  static ClientInfo _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get user => $_getSZ(0);
  @$pb.TagNumber(1)
  set user($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get client => $_getSZ(1);
  @$pb.TagNumber(2)
  set client($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasClient() => $_has(1);
  @$pb.TagNumber(2)
  void clearClient() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get connInfo => $_getN(2);
  @$pb.TagNumber(3)
  set connInfo($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasConnInfo() => $_has(2);
  @$pb.TagNumber(3)
  void clearConnInfo() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get chanInfo => $_getN(3);
  @$pb.TagNumber(4)
  set chanInfo($core.List<$core.int> v) {
    $_setBytes(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasChanInfo() => $_has(3);
  @$pb.TagNumber(4)
  void clearChanInfo() => clearField(4);
}

class Publication extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Publication',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..a<$core.int>(1, 'seq', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, 'gen', $pb.PbFieldType.OU3)
    ..aOS(3, 'uid')
    ..a<$core.List<$core.int>>(4, 'data', $pb.PbFieldType.OY)
    ..aOM<ClientInfo>(5, 'info', subBuilder: ClientInfo.create)
    ..a<$fixnum.Int64>(6, 'offset', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  Publication._() : super();
  factory Publication() => create();
  factory Publication.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Publication.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Publication clone() => Publication()..mergeFromMessage(this);
  Publication copyWith(void Function(Publication) updates) =>
      super.copyWith((message) => updates(message as Publication));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Publication create() => Publication._();
  Publication createEmptyInstance() => create();
  static $pb.PbList<Publication> createRepeated() => $pb.PbList<Publication>();
  @$core.pragma('dart2js:noInline')
  static Publication getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Publication>(create);
  static Publication _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seq => $_getIZ(0);
  @$pb.TagNumber(1)
  set seq($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSeq() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeq() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get gen => $_getIZ(1);
  @$pb.TagNumber(2)
  set gen($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasGen() => $_has(1);
  @$pb.TagNumber(2)
  void clearGen() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get uid => $_getSZ(2);
  @$pb.TagNumber(3)
  set uid($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasUid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUid() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get data => $_getN(3);
  @$pb.TagNumber(4)
  set data($core.List<$core.int> v) {
    $_setBytes(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasData() => $_has(3);
  @$pb.TagNumber(4)
  void clearData() => clearField(4);

  @$pb.TagNumber(5)
  ClientInfo get info => $_getN(4);
  @$pb.TagNumber(5)
  set info(ClientInfo v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasInfo() => $_has(4);
  @$pb.TagNumber(5)
  void clearInfo() => clearField(5);
  @$pb.TagNumber(5)
  ClientInfo ensureInfo() => $_ensure(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get offset => $_getI64(5);
  @$pb.TagNumber(6)
  set offset($fixnum.Int64 v) {
    $_setInt64(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasOffset() => $_has(5);
  @$pb.TagNumber(6)
  void clearOffset() => clearField(6);
}

class Join extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Join',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..aOM<ClientInfo>(1, 'info', subBuilder: ClientInfo.create)
    ..hasRequiredFields = false;

  Join._() : super();
  factory Join() => create();
  factory Join.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Join.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Join clone() => Join()..mergeFromMessage(this);
  Join copyWith(void Function(Join) updates) =>
      super.copyWith((message) => updates(message as Join));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Join create() => Join._();
  Join createEmptyInstance() => create();
  static $pb.PbList<Join> createRepeated() => $pb.PbList<Join>();
  @$core.pragma('dart2js:noInline')
  static Join getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Join>(create);
  static Join _defaultInstance;

  @$pb.TagNumber(1)
  ClientInfo get info => $_getN(0);
  @$pb.TagNumber(1)
  set info(ClientInfo v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearInfo() => clearField(1);
  @$pb.TagNumber(1)
  ClientInfo ensureInfo() => $_ensure(0);
}

class Leave extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Leave',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..aOM<ClientInfo>(1, 'info', subBuilder: ClientInfo.create)
    ..hasRequiredFields = false;

  Leave._() : super();
  factory Leave() => create();
  factory Leave.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Leave.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Leave clone() => Leave()..mergeFromMessage(this);
  Leave copyWith(void Function(Leave) updates) =>
      super.copyWith((message) => updates(message as Leave));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Leave create() => Leave._();
  Leave createEmptyInstance() => create();
  static $pb.PbList<Leave> createRepeated() => $pb.PbList<Leave>();
  @$core.pragma('dart2js:noInline')
  static Leave getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Leave>(create);
  static Leave _defaultInstance;

  @$pb.TagNumber(1)
  ClientInfo get info => $_getN(0);
  @$pb.TagNumber(1)
  set info(ClientInfo v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearInfo() => clearField(1);
  @$pb.TagNumber(1)
  ClientInfo ensureInfo() => $_ensure(0);
}

class Unsub extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Unsub',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..aOB(1, 'resubscribe')
    ..hasRequiredFields = false;

  Unsub._() : super();
  factory Unsub() => create();
  factory Unsub.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Unsub.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Unsub clone() => Unsub()..mergeFromMessage(this);
  Unsub copyWith(void Function(Unsub) updates) =>
      super.copyWith((message) => updates(message as Unsub));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Unsub create() => Unsub._();
  Unsub createEmptyInstance() => create();
  static $pb.PbList<Unsub> createRepeated() => $pb.PbList<Unsub>();
  @$core.pragma('dart2js:noInline')
  static Unsub getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Unsub>(create);
  static Unsub _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get resubscribe => $_getBF(0);
  @$pb.TagNumber(1)
  set resubscribe($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasResubscribe() => $_has(0);
  @$pb.TagNumber(1)
  void clearResubscribe() => clearField(1);
}

class Sub extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Sub',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..aOB(1, 'recoverable')
    ..a<$core.int>(2, 'seq', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, 'gen', $pb.PbFieldType.OU3)
    ..aOS(4, 'epoch')
    ..a<$fixnum.Int64>(5, 'offset', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  Sub._() : super();
  factory Sub() => create();
  factory Sub.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Sub.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Sub clone() => Sub()..mergeFromMessage(this);
  Sub copyWith(void Function(Sub) updates) =>
      super.copyWith((message) => updates(message as Sub));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Sub create() => Sub._();
  Sub createEmptyInstance() => create();
  static $pb.PbList<Sub> createRepeated() => $pb.PbList<Sub>();
  @$core.pragma('dart2js:noInline')
  static Sub getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Sub>(create);
  static Sub _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get recoverable => $_getBF(0);
  @$pb.TagNumber(1)
  set recoverable($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasRecoverable() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecoverable() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get seq => $_getIZ(1);
  @$pb.TagNumber(2)
  set seq($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSeq() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeq() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get gen => $_getIZ(2);
  @$pb.TagNumber(3)
  set gen($core.int v) {
    $_setUnsignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasGen() => $_has(2);
  @$pb.TagNumber(3)
  void clearGen() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get epoch => $_getSZ(3);
  @$pb.TagNumber(4)
  set epoch($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasEpoch() => $_has(3);
  @$pb.TagNumber(4)
  void clearEpoch() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get offset => $_getI64(4);
  @$pb.TagNumber(5)
  set offset($fixnum.Int64 v) {
    $_setInt64(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasOffset() => $_has(4);
  @$pb.TagNumber(5)
  void clearOffset() => clearField(5);
}

class Message extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Message',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  Message._() : super();
  factory Message() => create();
  factory Message.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Message.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Message clone() => Message()..mergeFromMessage(this);
  Message copyWith(void Function(Message) updates) =>
      super.copyWith((message) => updates(message as Message));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Message create() => Message._();
  Message createEmptyInstance() => create();
  static $pb.PbList<Message> createRepeated() => $pb.PbList<Message>();
  @$core.pragma('dart2js:noInline')
  static Message getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Message>(create);
  static Message _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
}

class ConnectRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ConnectRequest',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..aOS(1, 'token')
    ..a<$core.List<$core.int>>(2, 'data', $pb.PbFieldType.OY)
    ..m<$core.String, SubscribeRequest>(3, 'subs',
        entryClassName: 'ConnectRequest.SubsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: SubscribeRequest.create,
        packageName: const $pb.PackageName('protocol'))
    ..hasRequiredFields = false;

  ConnectRequest._() : super();
  factory ConnectRequest() => create();
  factory ConnectRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ConnectRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  ConnectRequest clone() => ConnectRequest()..mergeFromMessage(this);
  ConnectRequest copyWith(void Function(ConnectRequest) updates) =>
      super.copyWith((message) => updates(message as ConnectRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConnectRequest create() => ConnectRequest._();
  ConnectRequest createEmptyInstance() => create();
  static $pb.PbList<ConnectRequest> createRepeated() =>
      $pb.PbList<ConnectRequest>();
  @$core.pragma('dart2js:noInline')
  static ConnectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectRequest>(create);
  static ConnectRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);

  @$pb.TagNumber(3)
  $core.Map<$core.String, SubscribeRequest> get subs => $_getMap(2);
}

class ConnectResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ConnectResult',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..aOS(1, 'client')
    ..aOS(2, 'version')
    ..aOB(3, 'expires')
    ..a<$core.int>(4, 'ttl', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(5, 'data', $pb.PbFieldType.OY)
    ..m<$core.String, SubscribeResult>(6, 'subs',
        entryClassName: 'ConnectResult.SubsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: SubscribeResult.create,
        packageName: const $pb.PackageName('protocol'))
    ..hasRequiredFields = false;

  ConnectResult._() : super();
  factory ConnectResult() => create();
  factory ConnectResult.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ConnectResult.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  ConnectResult clone() => ConnectResult()..mergeFromMessage(this);
  ConnectResult copyWith(void Function(ConnectResult) updates) =>
      super.copyWith((message) => updates(message as ConnectResult));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConnectResult create() => ConnectResult._();
  ConnectResult createEmptyInstance() => create();
  static $pb.PbList<ConnectResult> createRepeated() =>
      $pb.PbList<ConnectResult>();
  @$core.pragma('dart2js:noInline')
  static ConnectResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectResult>(create);
  static ConnectResult _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get client => $_getSZ(0);
  @$pb.TagNumber(1)
  set client($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasClient() => $_has(0);
  @$pb.TagNumber(1)
  void clearClient() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get expires => $_getBF(2);
  @$pb.TagNumber(3)
  set expires($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasExpires() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpires() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get ttl => $_getIZ(3);
  @$pb.TagNumber(4)
  set ttl($core.int v) {
    $_setUnsignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasTtl() => $_has(3);
  @$pb.TagNumber(4)
  void clearTtl() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get data => $_getN(4);
  @$pb.TagNumber(5)
  set data($core.List<$core.int> v) {
    $_setBytes(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasData() => $_has(4);
  @$pb.TagNumber(5)
  void clearData() => clearField(5);

  @$pb.TagNumber(6)
  $core.Map<$core.String, SubscribeResult> get subs => $_getMap(5);
}

class RefreshRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RefreshRequest',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..aOS(1, 'token')
    ..hasRequiredFields = false;

  RefreshRequest._() : super();
  factory RefreshRequest() => create();
  factory RefreshRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RefreshRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  RefreshRequest clone() => RefreshRequest()..mergeFromMessage(this);
  RefreshRequest copyWith(void Function(RefreshRequest) updates) =>
      super.copyWith((message) => updates(message as RefreshRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RefreshRequest create() => RefreshRequest._();
  RefreshRequest createEmptyInstance() => create();
  static $pb.PbList<RefreshRequest> createRepeated() =>
      $pb.PbList<RefreshRequest>();
  @$core.pragma('dart2js:noInline')
  static RefreshRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefreshRequest>(create);
  static RefreshRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);
}

class RefreshResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RefreshResult',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..aOS(1, 'client')
    ..aOS(2, 'version')
    ..aOB(3, 'expires')
    ..a<$core.int>(4, 'ttl', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  RefreshResult._() : super();
  factory RefreshResult() => create();
  factory RefreshResult.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RefreshResult.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  RefreshResult clone() => RefreshResult()..mergeFromMessage(this);
  RefreshResult copyWith(void Function(RefreshResult) updates) =>
      super.copyWith((message) => updates(message as RefreshResult));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RefreshResult create() => RefreshResult._();
  RefreshResult createEmptyInstance() => create();
  static $pb.PbList<RefreshResult> createRepeated() =>
      $pb.PbList<RefreshResult>();
  @$core.pragma('dart2js:noInline')
  static RefreshResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefreshResult>(create);
  static RefreshResult _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get client => $_getSZ(0);
  @$pb.TagNumber(1)
  set client($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasClient() => $_has(0);
  @$pb.TagNumber(1)
  void clearClient() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get expires => $_getBF(2);
  @$pb.TagNumber(3)
  set expires($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasExpires() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpires() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get ttl => $_getIZ(3);
  @$pb.TagNumber(4)
  set ttl($core.int v) {
    $_setUnsignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasTtl() => $_has(3);
  @$pb.TagNumber(4)
  void clearTtl() => clearField(4);
}

class SubscribeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SubscribeRequest',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..aOS(1, 'channel')
    ..aOS(2, 'token')
    ..aOB(3, 'recover')
    ..a<$core.int>(4, 'seq', $pb.PbFieldType.OU3)
    ..a<$core.int>(5, 'gen', $pb.PbFieldType.OU3)
    ..aOS(6, 'epoch')
    ..a<$fixnum.Int64>(7, 'offset', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  SubscribeRequest._() : super();
  factory SubscribeRequest() => create();
  factory SubscribeRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SubscribeRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  SubscribeRequest clone() => SubscribeRequest()..mergeFromMessage(this);
  SubscribeRequest copyWith(void Function(SubscribeRequest) updates) =>
      super.copyWith((message) => updates(message as SubscribeRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SubscribeRequest create() => SubscribeRequest._();
  SubscribeRequest createEmptyInstance() => create();
  static $pb.PbList<SubscribeRequest> createRepeated() =>
      $pb.PbList<SubscribeRequest>();
  @$core.pragma('dart2js:noInline')
  static SubscribeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubscribeRequest>(create);
  static SubscribeRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channel => $_getSZ(0);
  @$pb.TagNumber(1)
  set channel($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get recover => $_getBF(2);
  @$pb.TagNumber(3)
  set recover($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRecover() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecover() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get seq => $_getIZ(3);
  @$pb.TagNumber(4)
  set seq($core.int v) {
    $_setUnsignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSeq() => $_has(3);
  @$pb.TagNumber(4)
  void clearSeq() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get gen => $_getIZ(4);
  @$pb.TagNumber(5)
  set gen($core.int v) {
    $_setUnsignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasGen() => $_has(4);
  @$pb.TagNumber(5)
  void clearGen() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get epoch => $_getSZ(5);
  @$pb.TagNumber(6)
  set epoch($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasEpoch() => $_has(5);
  @$pb.TagNumber(6)
  void clearEpoch() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get offset => $_getI64(6);
  @$pb.TagNumber(7)
  set offset($fixnum.Int64 v) {
    $_setInt64(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasOffset() => $_has(6);
  @$pb.TagNumber(7)
  void clearOffset() => clearField(7);
}

class SubscribeResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SubscribeResult',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..aOB(1, 'expires')
    ..a<$core.int>(2, 'ttl', $pb.PbFieldType.OU3)
    ..aOB(3, 'recoverable')
    ..a<$core.int>(4, 'seq', $pb.PbFieldType.OU3)
    ..a<$core.int>(5, 'gen', $pb.PbFieldType.OU3)
    ..aOS(6, 'epoch')
    ..pc<Publication>(7, 'publications', $pb.PbFieldType.PM,
        subBuilder: Publication.create)
    ..aOB(8, 'recovered')
    ..a<$fixnum.Int64>(9, 'offset', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  SubscribeResult._() : super();
  factory SubscribeResult() => create();
  factory SubscribeResult.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SubscribeResult.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  SubscribeResult clone() => SubscribeResult()..mergeFromMessage(this);
  SubscribeResult copyWith(void Function(SubscribeResult) updates) =>
      super.copyWith((message) => updates(message as SubscribeResult));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SubscribeResult create() => SubscribeResult._();
  SubscribeResult createEmptyInstance() => create();
  static $pb.PbList<SubscribeResult> createRepeated() =>
      $pb.PbList<SubscribeResult>();
  @$core.pragma('dart2js:noInline')
  static SubscribeResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubscribeResult>(create);
  static SubscribeResult _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get expires => $_getBF(0);
  @$pb.TagNumber(1)
  set expires($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasExpires() => $_has(0);
  @$pb.TagNumber(1)
  void clearExpires() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get ttl => $_getIZ(1);
  @$pb.TagNumber(2)
  set ttl($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTtl() => $_has(1);
  @$pb.TagNumber(2)
  void clearTtl() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get recoverable => $_getBF(2);
  @$pb.TagNumber(3)
  set recoverable($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRecoverable() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecoverable() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get seq => $_getIZ(3);
  @$pb.TagNumber(4)
  set seq($core.int v) {
    $_setUnsignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSeq() => $_has(3);
  @$pb.TagNumber(4)
  void clearSeq() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get gen => $_getIZ(4);
  @$pb.TagNumber(5)
  set gen($core.int v) {
    $_setUnsignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasGen() => $_has(4);
  @$pb.TagNumber(5)
  void clearGen() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get epoch => $_getSZ(5);
  @$pb.TagNumber(6)
  set epoch($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasEpoch() => $_has(5);
  @$pb.TagNumber(6)
  void clearEpoch() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<Publication> get publications => $_getList(6);

  @$pb.TagNumber(8)
  $core.bool get recovered => $_getBF(7);
  @$pb.TagNumber(8)
  set recovered($core.bool v) {
    $_setBool(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasRecovered() => $_has(7);
  @$pb.TagNumber(8)
  void clearRecovered() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get offset => $_getI64(8);
  @$pb.TagNumber(9)
  set offset($fixnum.Int64 v) {
    $_setInt64(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasOffset() => $_has(8);
  @$pb.TagNumber(9)
  void clearOffset() => clearField(9);
}

class SubRefreshRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SubRefreshRequest',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..aOS(1, 'channel')
    ..aOS(2, 'token')
    ..hasRequiredFields = false;

  SubRefreshRequest._() : super();
  factory SubRefreshRequest() => create();
  factory SubRefreshRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SubRefreshRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  SubRefreshRequest clone() => SubRefreshRequest()..mergeFromMessage(this);
  SubRefreshRequest copyWith(void Function(SubRefreshRequest) updates) =>
      super.copyWith((message) => updates(message as SubRefreshRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SubRefreshRequest create() => SubRefreshRequest._();
  SubRefreshRequest createEmptyInstance() => create();
  static $pb.PbList<SubRefreshRequest> createRepeated() =>
      $pb.PbList<SubRefreshRequest>();
  @$core.pragma('dart2js:noInline')
  static SubRefreshRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubRefreshRequest>(create);
  static SubRefreshRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channel => $_getSZ(0);
  @$pb.TagNumber(1)
  set channel($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);
}

class SubRefreshResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SubRefreshResult',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..aOB(1, 'expires')
    ..a<$core.int>(2, 'ttl', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  SubRefreshResult._() : super();
  factory SubRefreshResult() => create();
  factory SubRefreshResult.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SubRefreshResult.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  SubRefreshResult clone() => SubRefreshResult()..mergeFromMessage(this);
  SubRefreshResult copyWith(void Function(SubRefreshResult) updates) =>
      super.copyWith((message) => updates(message as SubRefreshResult));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SubRefreshResult create() => SubRefreshResult._();
  SubRefreshResult createEmptyInstance() => create();
  static $pb.PbList<SubRefreshResult> createRepeated() =>
      $pb.PbList<SubRefreshResult>();
  @$core.pragma('dart2js:noInline')
  static SubRefreshResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubRefreshResult>(create);
  static SubRefreshResult _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get expires => $_getBF(0);
  @$pb.TagNumber(1)
  set expires($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasExpires() => $_has(0);
  @$pb.TagNumber(1)
  void clearExpires() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get ttl => $_getIZ(1);
  @$pb.TagNumber(2)
  set ttl($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTtl() => $_has(1);
  @$pb.TagNumber(2)
  void clearTtl() => clearField(2);
}

class UnsubscribeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UnsubscribeRequest',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..aOS(1, 'channel')
    ..hasRequiredFields = false;

  UnsubscribeRequest._() : super();
  factory UnsubscribeRequest() => create();
  factory UnsubscribeRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory UnsubscribeRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  UnsubscribeRequest clone() => UnsubscribeRequest()..mergeFromMessage(this);
  UnsubscribeRequest copyWith(void Function(UnsubscribeRequest) updates) =>
      super.copyWith((message) => updates(message as UnsubscribeRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UnsubscribeRequest create() => UnsubscribeRequest._();
  UnsubscribeRequest createEmptyInstance() => create();
  static $pb.PbList<UnsubscribeRequest> createRepeated() =>
      $pb.PbList<UnsubscribeRequest>();
  @$core.pragma('dart2js:noInline')
  static UnsubscribeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnsubscribeRequest>(create);
  static UnsubscribeRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channel => $_getSZ(0);
  @$pb.TagNumber(1)
  set channel($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => clearField(1);
}

class UnsubscribeResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UnsubscribeResult',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  UnsubscribeResult._() : super();
  factory UnsubscribeResult() => create();
  factory UnsubscribeResult.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory UnsubscribeResult.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  UnsubscribeResult clone() => UnsubscribeResult()..mergeFromMessage(this);
  UnsubscribeResult copyWith(void Function(UnsubscribeResult) updates) =>
      super.copyWith((message) => updates(message as UnsubscribeResult));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UnsubscribeResult create() => UnsubscribeResult._();
  UnsubscribeResult createEmptyInstance() => create();
  static $pb.PbList<UnsubscribeResult> createRepeated() =>
      $pb.PbList<UnsubscribeResult>();
  @$core.pragma('dart2js:noInline')
  static UnsubscribeResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnsubscribeResult>(create);
  static UnsubscribeResult _defaultInstance;
}

class PublishRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PublishRequest',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..aOS(1, 'channel')
    ..a<$core.List<$core.int>>(2, 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  PublishRequest._() : super();
  factory PublishRequest() => create();
  factory PublishRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PublishRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  PublishRequest clone() => PublishRequest()..mergeFromMessage(this);
  PublishRequest copyWith(void Function(PublishRequest) updates) =>
      super.copyWith((message) => updates(message as PublishRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PublishRequest create() => PublishRequest._();
  PublishRequest createEmptyInstance() => create();
  static $pb.PbList<PublishRequest> createRepeated() =>
      $pb.PbList<PublishRequest>();
  @$core.pragma('dart2js:noInline')
  static PublishRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishRequest>(create);
  static PublishRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channel => $_getSZ(0);
  @$pb.TagNumber(1)
  set channel($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);
}

class PublishResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PublishResult',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  PublishResult._() : super();
  factory PublishResult() => create();
  factory PublishResult.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PublishResult.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  PublishResult clone() => PublishResult()..mergeFromMessage(this);
  PublishResult copyWith(void Function(PublishResult) updates) =>
      super.copyWith((message) => updates(message as PublishResult));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PublishResult create() => PublishResult._();
  PublishResult createEmptyInstance() => create();
  static $pb.PbList<PublishResult> createRepeated() =>
      $pb.PbList<PublishResult>();
  @$core.pragma('dart2js:noInline')
  static PublishResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishResult>(create);
  static PublishResult _defaultInstance;
}

class PresenceRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PresenceRequest',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..aOS(1, 'channel')
    ..hasRequiredFields = false;

  PresenceRequest._() : super();
  factory PresenceRequest() => create();
  factory PresenceRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PresenceRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  PresenceRequest clone() => PresenceRequest()..mergeFromMessage(this);
  PresenceRequest copyWith(void Function(PresenceRequest) updates) =>
      super.copyWith((message) => updates(message as PresenceRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PresenceRequest create() => PresenceRequest._();
  PresenceRequest createEmptyInstance() => create();
  static $pb.PbList<PresenceRequest> createRepeated() =>
      $pb.PbList<PresenceRequest>();
  @$core.pragma('dart2js:noInline')
  static PresenceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PresenceRequest>(create);
  static PresenceRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channel => $_getSZ(0);
  @$pb.TagNumber(1)
  set channel($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => clearField(1);
}

class PresenceResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PresenceResult',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..m<$core.String, ClientInfo>(1, 'presence',
        entryClassName: 'PresenceResult.PresenceEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: ClientInfo.create,
        packageName: const $pb.PackageName('protocol'))
    ..hasRequiredFields = false;

  PresenceResult._() : super();
  factory PresenceResult() => create();
  factory PresenceResult.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PresenceResult.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  PresenceResult clone() => PresenceResult()..mergeFromMessage(this);
  PresenceResult copyWith(void Function(PresenceResult) updates) =>
      super.copyWith((message) => updates(message as PresenceResult));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PresenceResult create() => PresenceResult._();
  PresenceResult createEmptyInstance() => create();
  static $pb.PbList<PresenceResult> createRepeated() =>
      $pb.PbList<PresenceResult>();
  @$core.pragma('dart2js:noInline')
  static PresenceResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PresenceResult>(create);
  static PresenceResult _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.String, ClientInfo> get presence => $_getMap(0);
}

class PresenceStatsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PresenceStatsRequest',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..aOS(1, 'channel')
    ..hasRequiredFields = false;

  PresenceStatsRequest._() : super();
  factory PresenceStatsRequest() => create();
  factory PresenceStatsRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PresenceStatsRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  PresenceStatsRequest clone() =>
      PresenceStatsRequest()..mergeFromMessage(this);
  PresenceStatsRequest copyWith(void Function(PresenceStatsRequest) updates) =>
      super.copyWith((message) => updates(message as PresenceStatsRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PresenceStatsRequest create() => PresenceStatsRequest._();
  PresenceStatsRequest createEmptyInstance() => create();
  static $pb.PbList<PresenceStatsRequest> createRepeated() =>
      $pb.PbList<PresenceStatsRequest>();
  @$core.pragma('dart2js:noInline')
  static PresenceStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PresenceStatsRequest>(create);
  static PresenceStatsRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channel => $_getSZ(0);
  @$pb.TagNumber(1)
  set channel($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => clearField(1);
}

class PresenceStatsResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PresenceStatsResult',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..a<$core.int>(1, 'numClients', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, 'numUsers', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  PresenceStatsResult._() : super();
  factory PresenceStatsResult() => create();
  factory PresenceStatsResult.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PresenceStatsResult.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  PresenceStatsResult clone() => PresenceStatsResult()..mergeFromMessage(this);
  PresenceStatsResult copyWith(void Function(PresenceStatsResult) updates) =>
      super.copyWith((message) => updates(message as PresenceStatsResult));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PresenceStatsResult create() => PresenceStatsResult._();
  PresenceStatsResult createEmptyInstance() => create();
  static $pb.PbList<PresenceStatsResult> createRepeated() =>
      $pb.PbList<PresenceStatsResult>();
  @$core.pragma('dart2js:noInline')
  static PresenceStatsResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PresenceStatsResult>(create);
  static PresenceStatsResult _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get numClients => $_getIZ(0);
  @$pb.TagNumber(1)
  set numClients($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasNumClients() => $_has(0);
  @$pb.TagNumber(1)
  void clearNumClients() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get numUsers => $_getIZ(1);
  @$pb.TagNumber(2)
  set numUsers($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasNumUsers() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumUsers() => clearField(2);
}

class HistoryRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('HistoryRequest',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..aOS(1, 'channel')
    ..hasRequiredFields = false;

  HistoryRequest._() : super();
  factory HistoryRequest() => create();
  factory HistoryRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory HistoryRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  HistoryRequest clone() => HistoryRequest()..mergeFromMessage(this);
  HistoryRequest copyWith(void Function(HistoryRequest) updates) =>
      super.copyWith((message) => updates(message as HistoryRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HistoryRequest create() => HistoryRequest._();
  HistoryRequest createEmptyInstance() => create();
  static $pb.PbList<HistoryRequest> createRepeated() =>
      $pb.PbList<HistoryRequest>();
  @$core.pragma('dart2js:noInline')
  static HistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HistoryRequest>(create);
  static HistoryRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channel => $_getSZ(0);
  @$pb.TagNumber(1)
  set channel($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => clearField(1);
}

class HistoryResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('HistoryResult',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..pc<Publication>(1, 'publications', $pb.PbFieldType.PM,
        subBuilder: Publication.create)
    ..hasRequiredFields = false;

  HistoryResult._() : super();
  factory HistoryResult() => create();
  factory HistoryResult.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory HistoryResult.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  HistoryResult clone() => HistoryResult()..mergeFromMessage(this);
  HistoryResult copyWith(void Function(HistoryResult) updates) =>
      super.copyWith((message) => updates(message as HistoryResult));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HistoryResult create() => HistoryResult._();
  HistoryResult createEmptyInstance() => create();
  static $pb.PbList<HistoryResult> createRepeated() =>
      $pb.PbList<HistoryResult>();
  @$core.pragma('dart2js:noInline')
  static HistoryResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HistoryResult>(create);
  static HistoryResult _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Publication> get publications => $_getList(0);
}

class PingRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PingRequest',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  PingRequest._() : super();
  factory PingRequest() => create();
  factory PingRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PingRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  PingRequest clone() => PingRequest()..mergeFromMessage(this);
  PingRequest copyWith(void Function(PingRequest) updates) =>
      super.copyWith((message) => updates(message as PingRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PingRequest create() => PingRequest._();
  PingRequest createEmptyInstance() => create();
  static $pb.PbList<PingRequest> createRepeated() => $pb.PbList<PingRequest>();
  @$core.pragma('dart2js:noInline')
  static PingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PingRequest>(create);
  static PingRequest _defaultInstance;
}

class PingResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PingResult',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  PingResult._() : super();
  factory PingResult() => create();
  factory PingResult.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PingResult.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  PingResult clone() => PingResult()..mergeFromMessage(this);
  PingResult copyWith(void Function(PingResult) updates) =>
      super.copyWith((message) => updates(message as PingResult));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PingResult create() => PingResult._();
  PingResult createEmptyInstance() => create();
  static $pb.PbList<PingResult> createRepeated() => $pb.PbList<PingResult>();
  @$core.pragma('dart2js:noInline')
  static PingResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PingResult>(create);
  static PingResult _defaultInstance;
}

class RPCRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RPCRequest',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'data', $pb.PbFieldType.OY)
    ..aOS(2, 'method')
    ..hasRequiredFields = false;

  RPCRequest._() : super();
  factory RPCRequest() => create();
  factory RPCRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RPCRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  RPCRequest clone() => RPCRequest()..mergeFromMessage(this);
  RPCRequest copyWith(void Function(RPCRequest) updates) =>
      super.copyWith((message) => updates(message as RPCRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RPCRequest create() => RPCRequest._();
  RPCRequest createEmptyInstance() => create();
  static $pb.PbList<RPCRequest> createRepeated() => $pb.PbList<RPCRequest>();
  @$core.pragma('dart2js:noInline')
  static RPCRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RPCRequest>(create);
  static RPCRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get method => $_getSZ(1);
  @$pb.TagNumber(2)
  set method($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMethod() => $_has(1);
  @$pb.TagNumber(2)
  void clearMethod() => clearField(2);
}

class RPCResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RPCResult',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  RPCResult._() : super();
  factory RPCResult() => create();
  factory RPCResult.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RPCResult.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  RPCResult clone() => RPCResult()..mergeFromMessage(this);
  RPCResult copyWith(void Function(RPCResult) updates) =>
      super.copyWith((message) => updates(message as RPCResult));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RPCResult create() => RPCResult._();
  RPCResult createEmptyInstance() => create();
  static $pb.PbList<RPCResult> createRepeated() => $pb.PbList<RPCResult>();
  @$core.pragma('dart2js:noInline')
  static RPCResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RPCResult>(create);
  static RPCResult _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
}

class SendRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SendRequest',
      package: const $pb.PackageName('protocol'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  SendRequest._() : super();
  factory SendRequest() => create();
  factory SendRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SendRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  SendRequest clone() => SendRequest()..mergeFromMessage(this);
  SendRequest copyWith(void Function(SendRequest) updates) =>
      super.copyWith((message) => updates(message as SendRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SendRequest create() => SendRequest._();
  SendRequest createEmptyInstance() => create();
  static $pb.PbList<SendRequest> createRepeated() => $pb.PbList<SendRequest>();
  @$core.pragma('dart2js:noInline')
  static SendRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendRequest>(create);
  static SendRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
}
