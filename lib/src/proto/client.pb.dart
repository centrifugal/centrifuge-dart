///
//  Generated code. Do not modify.
//  source: client.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'client.pbenum.dart';

export 'client.pbenum.dart';

class Error extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('Error', package: const $pb.PackageName('proto'))
        ..a<int>(1, 'code', $pb.PbFieldType.OU3)
        ..aOS(2, 'message')
        ..hasRequiredFields = false;

  Error() : super();
  Error.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Error.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  Error clone() => new Error()..mergeFromMessage(this);
  @override
  Error copyWith(void Function(Error) updates) =>
      super.copyWith((message) => updates(message as Error));
  @override
  $pb.BuilderInfo get info_ => _i;
  static Error create() => new Error();
  @override
  Error createEmptyInstance() => create();
  static $pb.PbList<Error> createRepeated() => new $pb.PbList<Error>();
  static Error getDefault() => _defaultInstance ??= create()..freeze();
  static Error _defaultInstance;
  static void $checkItem(Error v) {
    if (v is! Error) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get code => $_get(0, 0);
  set code(int v) {
    $_setUnsignedInt32(0, v);
  }

  bool hasCode() => $_has(0);
  void clearCode() => clearField(1);

  String get message => $_getS(1, '');
  set message(String v) {
    $_setString(1, v);
  }

  bool hasMessage() => $_has(1);
  void clearMessage() => clearField(2);
}

class Command extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('Command', package: const $pb.PackageName('proto'))
        ..a<int>(1, 'id', $pb.PbFieldType.OU3)
        ..e<MethodType>(2, 'method', $pb.PbFieldType.OE, MethodType.CONNECT,
            MethodType.valueOf, MethodType.values)
        ..a<List<int>>(3, 'params', $pb.PbFieldType.OY)
        ..hasRequiredFields = false;

  Command() : super();
  Command.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Command.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  Command clone() => new Command()..mergeFromMessage(this);
  @override
  Command copyWith(void Function(Command) updates) =>
      super.copyWith((message) => updates(message as Command));
  @override
  $pb.BuilderInfo get info_ => _i;
  static Command create() => new Command();
  @override
  Command createEmptyInstance() => create();
  static $pb.PbList<Command> createRepeated() => new $pb.PbList<Command>();
  static Command getDefault() => _defaultInstance ??= create()..freeze();
  static Command _defaultInstance;
  static void $checkItem(Command v) {
    if (v is! Command) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get id => $_get(0, 0);
  set id(int v) {
    $_setUnsignedInt32(0, v);
  }

  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  MethodType get method => $_getN(1);
  set method(MethodType v) {
    setField(2, v);
  }

  bool hasMethod() => $_has(1);
  void clearMethod() => clearField(2);

  List<int> get params => $_getN(2);
  set params(List<int> v) {
    $_setBytes(2, v);
  }

  bool hasParams() => $_has(2);
  void clearParams() => clearField(3);
}

class Reply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Reply',
      package: const $pb.PackageName('proto'))
    ..a<int>(1, 'id', $pb.PbFieldType.OU3)
    ..a<Error>(2, 'error', $pb.PbFieldType.OM, Error.getDefault, Error.create)
    ..a<List<int>>(3, 'result', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  Reply() : super();
  Reply.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Reply.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  Reply clone() => new Reply()..mergeFromMessage(this);
  @override
  Reply copyWith(void Function(Reply) updates) =>
      super.copyWith((message) => updates(message as Reply));
  @override
  $pb.BuilderInfo get info_ => _i;
  static Reply create() => new Reply();
  @override
  Reply createEmptyInstance() => create();
  static $pb.PbList<Reply> createRepeated() => new $pb.PbList<Reply>();
  static Reply getDefault() => _defaultInstance ??= create()..freeze();
  static Reply _defaultInstance;
  static void $checkItem(Reply v) {
    if (v is! Reply) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get id => $_get(0, 0);
  set id(int v) {
    $_setUnsignedInt32(0, v);
  }

  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  Error get error => $_getN(1);
  set error(Error v) {
    setField(2, v);
  }

  bool hasError() => $_has(1);
  void clearError() => clearField(2);

  List<int> get result => $_getN(2);
  set result(List<int> v) {
    $_setBytes(2, v);
  }

  bool hasResult() => $_has(2);
  void clearResult() => clearField(3);
}

class Push extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('Push', package: const $pb.PackageName('proto'))
        ..e<PushType>(1, 'type', $pb.PbFieldType.OE, PushType.PUBLICATION,
            PushType.valueOf, PushType.values)
        ..aOS(2, 'channel')
        ..a<List<int>>(3, 'data', $pb.PbFieldType.OY)
        ..hasRequiredFields = false;

  Push() : super();
  Push.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Push.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  Push clone() => new Push()..mergeFromMessage(this);
  @override
  Push copyWith(void Function(Push) updates) =>
      super.copyWith((message) => updates(message as Push));
  @override
  $pb.BuilderInfo get info_ => _i;
  static Push create() => new Push();
  @override
  Push createEmptyInstance() => create();
  static $pb.PbList<Push> createRepeated() => new $pb.PbList<Push>();
  static Push getDefault() => _defaultInstance ??= create()..freeze();
  static Push _defaultInstance;
  static void $checkItem(Push v) {
    if (v is! Push) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  PushType get type => $_getN(0);
  set type(PushType v) {
    setField(1, v);
  }

  bool hasType() => $_has(0);
  void clearType() => clearField(1);

  String get channel => $_getS(1, '');
  set channel(String v) {
    $_setString(1, v);
  }

  bool hasChannel() => $_has(1);
  void clearChannel() => clearField(2);

  List<int> get data => $_getN(2);
  set data(List<int> v) {
    $_setBytes(2, v);
  }

  bool hasData() => $_has(2);
  void clearData() => clearField(3);
}

class ClientInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('ClientInfo', package: const $pb.PackageName('proto'))
        ..aOS(1, 'user')
        ..aOS(2, 'client')
        ..a<List<int>>(3, 'connInfo', $pb.PbFieldType.OY)
        ..a<List<int>>(4, 'chanInfo', $pb.PbFieldType.OY)
        ..hasRequiredFields = false;

  ClientInfo() : super();
  ClientInfo.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ClientInfo.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  ClientInfo clone() => new ClientInfo()..mergeFromMessage(this);
  @override
  ClientInfo copyWith(void Function(ClientInfo) updates) =>
      super.copyWith((message) => updates(message as ClientInfo));
  @override
  $pb.BuilderInfo get info_ => _i;
  static ClientInfo create() => new ClientInfo();
  @override
  ClientInfo createEmptyInstance() => create();
  static $pb.PbList<ClientInfo> createRepeated() =>
      new $pb.PbList<ClientInfo>();
  static ClientInfo getDefault() => _defaultInstance ??= create()..freeze();
  static ClientInfo _defaultInstance;
  static void $checkItem(ClientInfo v) {
    if (v is! ClientInfo) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get user => $_getS(0, '');
  set user(String v) {
    $_setString(0, v);
  }

  bool hasUser() => $_has(0);
  void clearUser() => clearField(1);

  String get client => $_getS(1, '');
  set client(String v) {
    $_setString(1, v);
  }

  bool hasClient() => $_has(1);
  void clearClient() => clearField(2);

  List<int> get connInfo => $_getN(2);
  set connInfo(List<int> v) {
    $_setBytes(2, v);
  }

  bool hasConnInfo() => $_has(2);
  void clearConnInfo() => clearField(3);

  List<int> get chanInfo => $_getN(3);
  set chanInfo(List<int> v) {
    $_setBytes(3, v);
  }

  bool hasChanInfo() => $_has(3);
  void clearChanInfo() => clearField(4);
}

class Publication extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Publication',
      package: const $pb.PackageName('proto'))
    ..a<int>(1, 'seq', $pb.PbFieldType.OU3)
    ..a<int>(2, 'gen', $pb.PbFieldType.OU3)
    ..aOS(3, 'uid')
    ..a<List<int>>(4, 'data', $pb.PbFieldType.OY)
    ..a<ClientInfo>(
        5, 'info', $pb.PbFieldType.OM, ClientInfo.getDefault, ClientInfo.create)
    ..hasRequiredFields = false;

  Publication() : super();
  Publication.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Publication.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  Publication clone() => new Publication()..mergeFromMessage(this);
  @override
  Publication copyWith(void Function(Publication) updates) =>
      super.copyWith((message) => updates(message as Publication));
  @override
  $pb.BuilderInfo get info_ => _i;
  static Publication create() => new Publication();
  @override
  Publication createEmptyInstance() => create();
  static $pb.PbList<Publication> createRepeated() =>
      new $pb.PbList<Publication>();
  static Publication getDefault() => _defaultInstance ??= create()..freeze();
  static Publication _defaultInstance;
  static void $checkItem(Publication v) {
    if (v is! Publication) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get seq => $_get(0, 0);
  set seq(int v) {
    $_setUnsignedInt32(0, v);
  }

  bool hasSeq() => $_has(0);
  void clearSeq() => clearField(1);

  int get gen => $_get(1, 0);
  set gen(int v) {
    $_setUnsignedInt32(1, v);
  }

  bool hasGen() => $_has(1);
  void clearGen() => clearField(2);

  String get uid => $_getS(2, '');
  set uid(String v) {
    $_setString(2, v);
  }

  bool hasUid() => $_has(2);
  void clearUid() => clearField(3);

  List<int> get data => $_getN(3);
  set data(List<int> v) {
    $_setBytes(3, v);
  }

  bool hasData() => $_has(3);
  void clearData() => clearField(4);

  ClientInfo get info => $_getN(4);
  set info(ClientInfo v) {
    setField(5, v);
  }

  bool hasInfo() => $_has(4);
  void clearInfo() => clearField(5);
}

class Join extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Join',
      package: const $pb.PackageName('proto'))
    ..a<ClientInfo>(
        1, 'info', $pb.PbFieldType.OM, ClientInfo.getDefault, ClientInfo.create)
    ..hasRequiredFields = false;

  Join() : super();
  Join.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Join.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  Join clone() => new Join()..mergeFromMessage(this);
  @override
  Join copyWith(void Function(Join) updates) =>
      super.copyWith((message) => updates(message as Join));
  @override
  $pb.BuilderInfo get info_ => _i;
  static Join create() => new Join();
  @override
  Join createEmptyInstance() => create();
  static $pb.PbList<Join> createRepeated() => new $pb.PbList<Join>();
  static Join getDefault() => _defaultInstance ??= create()..freeze();
  static Join _defaultInstance;
  static void $checkItem(Join v) {
    if (v is! Join) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  ClientInfo get info => $_getN(0);
  set info(ClientInfo v) {
    setField(1, v);
  }

  bool hasInfo() => $_has(0);
  void clearInfo() => clearField(1);
}

class Leave extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Leave',
      package: const $pb.PackageName('proto'))
    ..a<ClientInfo>(
        1, 'info', $pb.PbFieldType.OM, ClientInfo.getDefault, ClientInfo.create)
    ..hasRequiredFields = false;

  Leave() : super();
  Leave.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Leave.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  Leave clone() => new Leave()..mergeFromMessage(this);
  @override
  Leave copyWith(void Function(Leave) updates) =>
      super.copyWith((message) => updates(message as Leave));
  @override
  $pb.BuilderInfo get info_ => _i;
  static Leave create() => new Leave();
  @override
  Leave createEmptyInstance() => create();
  static $pb.PbList<Leave> createRepeated() => new $pb.PbList<Leave>();
  static Leave getDefault() => _defaultInstance ??= create()..freeze();
  static Leave _defaultInstance;
  static void $checkItem(Leave v) {
    if (v is! Leave) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  ClientInfo get info => $_getN(0);
  set info(ClientInfo v) {
    setField(1, v);
  }

  bool hasInfo() => $_has(0);
  void clearInfo() => clearField(1);
}

class Unsub extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('Unsub', package: const $pb.PackageName('proto'))
        ..aOB(1, 'resubscribe')
        ..hasRequiredFields = false;

  Unsub() : super();
  Unsub.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Unsub.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  Unsub clone() => new Unsub()..mergeFromMessage(this);
  @override
  Unsub copyWith(void Function(Unsub) updates) =>
      super.copyWith((message) => updates(message as Unsub));
  @override
  $pb.BuilderInfo get info_ => _i;
  static Unsub create() => new Unsub();
  @override
  Unsub createEmptyInstance() => create();
  static $pb.PbList<Unsub> createRepeated() => new $pb.PbList<Unsub>();
  static Unsub getDefault() => _defaultInstance ??= create()..freeze();
  static Unsub _defaultInstance;
  static void $checkItem(Unsub v) {
    if (v is! Unsub) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  bool get resubscribe => $_get(0, false);
  set resubscribe(bool v) {
    $_setBool(0, v);
  }

  bool hasResubscribe() => $_has(0);
  void clearResubscribe() => clearField(1);
}

class Message extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('Message', package: const $pb.PackageName('proto'))
        ..a<List<int>>(1, 'data', $pb.PbFieldType.OY)
        ..hasRequiredFields = false;

  Message() : super();
  Message.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Message.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  Message clone() => new Message()..mergeFromMessage(this);
  @override
  Message copyWith(void Function(Message) updates) =>
      super.copyWith((message) => updates(message as Message));
  @override
  $pb.BuilderInfo get info_ => _i;
  static Message create() => new Message();
  @override
  Message createEmptyInstance() => create();
  static $pb.PbList<Message> createRepeated() => new $pb.PbList<Message>();
  static Message getDefault() => _defaultInstance ??= create()..freeze();
  static Message _defaultInstance;
  static void $checkItem(Message v) {
    if (v is! Message) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<int> get data => $_getN(0);
  set data(List<int> v) {
    $_setBytes(0, v);
  }

  bool hasData() => $_has(0);
  void clearData() => clearField(1);
}

class ConnectRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConnectRequest',
      package: const $pb.PackageName('proto'))
    ..aOS(1, 'token')
    ..a<List<int>>(2, 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  ConnectRequest() : super();
  ConnectRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConnectRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  ConnectRequest clone() => new ConnectRequest()..mergeFromMessage(this);
  @override
  ConnectRequest copyWith(void Function(ConnectRequest) updates) =>
      super.copyWith((message) => updates(message as ConnectRequest));
  @override
  $pb.BuilderInfo get info_ => _i;
  static ConnectRequest create() => new ConnectRequest();
  @override
  ConnectRequest createEmptyInstance() => create();
  static $pb.PbList<ConnectRequest> createRepeated() =>
      new $pb.PbList<ConnectRequest>();
  static ConnectRequest getDefault() => _defaultInstance ??= create()..freeze();
  static ConnectRequest _defaultInstance;
  static void $checkItem(ConnectRequest v) {
    if (v is! ConnectRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get token => $_getS(0, '');
  set token(String v) {
    $_setString(0, v);
  }

  bool hasToken() => $_has(0);
  void clearToken() => clearField(1);

  List<int> get data => $_getN(1);
  set data(List<int> v) {
    $_setBytes(1, v);
  }

  bool hasData() => $_has(1);
  void clearData() => clearField(2);
}

class ConnectResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConnectResult',
      package: const $pb.PackageName('proto'))
    ..aOS(1, 'client')
    ..aOS(2, 'version')
    ..aOB(3, 'expires')
    ..a<int>(4, 'ttl', $pb.PbFieldType.OU3)
    ..a<List<int>>(5, 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  ConnectResult() : super();
  ConnectResult.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConnectResult.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  ConnectResult clone() => new ConnectResult()..mergeFromMessage(this);
  @override
  ConnectResult copyWith(void Function(ConnectResult) updates) =>
      super.copyWith((message) => updates(message as ConnectResult));
  @override
  $pb.BuilderInfo get info_ => _i;
  static ConnectResult create() => new ConnectResult();
  @override
  ConnectResult createEmptyInstance() => create();
  static $pb.PbList<ConnectResult> createRepeated() =>
      new $pb.PbList<ConnectResult>();
  static ConnectResult getDefault() => _defaultInstance ??= create()..freeze();
  static ConnectResult _defaultInstance;
  static void $checkItem(ConnectResult v) {
    if (v is! ConnectResult) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get client => $_getS(0, '');
  set client(String v) {
    $_setString(0, v);
  }

  bool hasClient() => $_has(0);
  void clearClient() => clearField(1);

  String get version => $_getS(1, '');
  set version(String v) {
    $_setString(1, v);
  }

  bool hasVersion() => $_has(1);
  void clearVersion() => clearField(2);

  bool get expires => $_get(2, false);
  set expires(bool v) {
    $_setBool(2, v);
  }

  bool hasExpires() => $_has(2);
  void clearExpires() => clearField(3);

  int get ttl => $_get(3, 0);
  set ttl(int v) {
    $_setUnsignedInt32(3, v);
  }

  bool hasTtl() => $_has(3);
  void clearTtl() => clearField(4);

  List<int> get data => $_getN(4);
  set data(List<int> v) {
    $_setBytes(4, v);
  }

  bool hasData() => $_has(4);
  void clearData() => clearField(5);
}

class RefreshRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RefreshRequest',
      package: const $pb.PackageName('proto'))
    ..aOS(1, 'token')
    ..hasRequiredFields = false;

  RefreshRequest() : super();
  RefreshRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  RefreshRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  RefreshRequest clone() => new RefreshRequest()..mergeFromMessage(this);
  @override
  RefreshRequest copyWith(void Function(RefreshRequest) updates) =>
      super.copyWith((message) => updates(message as RefreshRequest));
  @override
  $pb.BuilderInfo get info_ => _i;
  static RefreshRequest create() => new RefreshRequest();
  @override
  RefreshRequest createEmptyInstance() => create();
  static $pb.PbList<RefreshRequest> createRepeated() =>
      new $pb.PbList<RefreshRequest>();
  static RefreshRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RefreshRequest _defaultInstance;
  static void $checkItem(RefreshRequest v) {
    if (v is! RefreshRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get token => $_getS(0, '');
  set token(String v) {
    $_setString(0, v);
  }

  bool hasToken() => $_has(0);
  void clearToken() => clearField(1);
}

class RefreshResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RefreshResult',
      package: const $pb.PackageName('proto'))
    ..aOS(1, 'client')
    ..aOS(2, 'version')
    ..aOB(3, 'expires')
    ..a<int>(4, 'ttl', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  RefreshResult() : super();
  RefreshResult.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  RefreshResult.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  RefreshResult clone() => new RefreshResult()..mergeFromMessage(this);
  @override
  RefreshResult copyWith(void Function(RefreshResult) updates) =>
      super.copyWith((message) => updates(message as RefreshResult));
  @override
  $pb.BuilderInfo get info_ => _i;
  static RefreshResult create() => new RefreshResult();
  @override
  RefreshResult createEmptyInstance() => create();
  static $pb.PbList<RefreshResult> createRepeated() =>
      new $pb.PbList<RefreshResult>();
  static RefreshResult getDefault() => _defaultInstance ??= create()..freeze();
  static RefreshResult _defaultInstance;
  static void $checkItem(RefreshResult v) {
    if (v is! RefreshResult) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get client => $_getS(0, '');
  set client(String v) {
    $_setString(0, v);
  }

  bool hasClient() => $_has(0);
  void clearClient() => clearField(1);

  String get version => $_getS(1, '');
  set version(String v) {
    $_setString(1, v);
  }

  bool hasVersion() => $_has(1);
  void clearVersion() => clearField(2);

  bool get expires => $_get(2, false);
  set expires(bool v) {
    $_setBool(2, v);
  }

  bool hasExpires() => $_has(2);
  void clearExpires() => clearField(3);

  int get ttl => $_get(3, 0);
  set ttl(int v) {
    $_setUnsignedInt32(3, v);
  }

  bool hasTtl() => $_has(3);
  void clearTtl() => clearField(4);
}

class SubscribeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SubscribeRequest',
      package: const $pb.PackageName('proto'))
    ..aOS(1, 'channel')
    ..aOS(2, 'token')
    ..aOB(3, 'recover')
    ..a<int>(4, 'seq', $pb.PbFieldType.OU3)
    ..a<int>(5, 'gen', $pb.PbFieldType.OU3)
    ..aOS(6, 'epoch')
    ..hasRequiredFields = false;

  SubscribeRequest() : super();
  SubscribeRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  SubscribeRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  SubscribeRequest clone() => new SubscribeRequest()..mergeFromMessage(this);
  @override
  SubscribeRequest copyWith(void Function(SubscribeRequest) updates) =>
      super.copyWith((message) => updates(message as SubscribeRequest));
  @override
  $pb.BuilderInfo get info_ => _i;
  static SubscribeRequest create() => new SubscribeRequest();
  @override
  SubscribeRequest createEmptyInstance() => create();
  static $pb.PbList<SubscribeRequest> createRepeated() =>
      new $pb.PbList<SubscribeRequest>();
  static SubscribeRequest getDefault() =>
      _defaultInstance ??= create()..freeze();
  static SubscribeRequest _defaultInstance;
  static void $checkItem(SubscribeRequest v) {
    if (v is! SubscribeRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get channel => $_getS(0, '');
  set channel(String v) {
    $_setString(0, v);
  }

  bool hasChannel() => $_has(0);
  void clearChannel() => clearField(1);

  String get token => $_getS(1, '');
  set token(String v) {
    $_setString(1, v);
  }

  bool hasToken() => $_has(1);
  void clearToken() => clearField(2);

  bool get recover => $_get(2, false);
  set recover(bool v) {
    $_setBool(2, v);
  }

  bool hasRecover() => $_has(2);
  void clearRecover() => clearField(3);

  int get seq => $_get(3, 0);
  set seq(int v) {
    $_setUnsignedInt32(3, v);
  }

  bool hasSeq() => $_has(3);
  void clearSeq() => clearField(4);

  int get gen => $_get(4, 0);
  set gen(int v) {
    $_setUnsignedInt32(4, v);
  }

  bool hasGen() => $_has(4);
  void clearGen() => clearField(5);

  String get epoch => $_getS(5, '');
  set epoch(String v) {
    $_setString(5, v);
  }

  bool hasEpoch() => $_has(5);
  void clearEpoch() => clearField(6);
}

class SubscribeResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SubscribeResult',
      package: const $pb.PackageName('proto'))
    ..aOB(1, 'expires')
    ..a<int>(2, 'ttl', $pb.PbFieldType.OU3)
    ..aOB(3, 'recoverable')
    ..a<int>(4, 'seq', $pb.PbFieldType.OU3)
    ..a<int>(5, 'gen', $pb.PbFieldType.OU3)
    ..aOS(6, 'epoch')
    ..pp<Publication>(7, 'publications', $pb.PbFieldType.PM,
        Publication.$checkItem, Publication.create)
    ..aOB(8, 'recovered')
    ..hasRequiredFields = false;

  SubscribeResult() : super();
  SubscribeResult.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  SubscribeResult.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  SubscribeResult clone() => new SubscribeResult()..mergeFromMessage(this);
  @override
  SubscribeResult copyWith(void Function(SubscribeResult) updates) =>
      super.copyWith((message) => updates(message as SubscribeResult));
  @override
  $pb.BuilderInfo get info_ => _i;
  static SubscribeResult create() => new SubscribeResult();
  @override
  SubscribeResult createEmptyInstance() => create();
  static $pb.PbList<SubscribeResult> createRepeated() =>
      new $pb.PbList<SubscribeResult>();
  static SubscribeResult getDefault() =>
      _defaultInstance ??= create()..freeze();
  static SubscribeResult _defaultInstance;
  static void $checkItem(SubscribeResult v) {
    if (v is! SubscribeResult) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  bool get expires => $_get(0, false);
  set expires(bool v) {
    $_setBool(0, v);
  }

  bool hasExpires() => $_has(0);
  void clearExpires() => clearField(1);

  int get ttl => $_get(1, 0);
  set ttl(int v) {
    $_setUnsignedInt32(1, v);
  }

  bool hasTtl() => $_has(1);
  void clearTtl() => clearField(2);

  bool get recoverable => $_get(2, false);
  set recoverable(bool v) {
    $_setBool(2, v);
  }

  bool hasRecoverable() => $_has(2);
  void clearRecoverable() => clearField(3);

  int get seq => $_get(3, 0);
  set seq(int v) {
    $_setUnsignedInt32(3, v);
  }

  bool hasSeq() => $_has(3);
  void clearSeq() => clearField(4);

  int get gen => $_get(4, 0);
  set gen(int v) {
    $_setUnsignedInt32(4, v);
  }

  bool hasGen() => $_has(4);
  void clearGen() => clearField(5);

  String get epoch => $_getS(5, '');
  set epoch(String v) {
    $_setString(5, v);
  }

  bool hasEpoch() => $_has(5);
  void clearEpoch() => clearField(6);

  List<Publication> get publications => $_getList(6);

  bool get recovered => $_get(7, false);
  set recovered(bool v) {
    $_setBool(7, v);
  }

  bool hasRecovered() => $_has(7);
  void clearRecovered() => clearField(8);
}

class SubRefreshRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SubRefreshRequest',
      package: const $pb.PackageName('proto'))
    ..aOS(1, 'channel')
    ..aOS(2, 'token')
    ..hasRequiredFields = false;

  SubRefreshRequest() : super();
  SubRefreshRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  SubRefreshRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  SubRefreshRequest clone() => new SubRefreshRequest()..mergeFromMessage(this);
  @override
  SubRefreshRequest copyWith(void Function(SubRefreshRequest) updates) =>
      super.copyWith((message) => updates(message as SubRefreshRequest));
  @override
  $pb.BuilderInfo get info_ => _i;
  static SubRefreshRequest create() => new SubRefreshRequest();
  @override
  SubRefreshRequest createEmptyInstance() => create();
  static $pb.PbList<SubRefreshRequest> createRepeated() =>
      new $pb.PbList<SubRefreshRequest>();
  static SubRefreshRequest getDefault() =>
      _defaultInstance ??= create()..freeze();
  static SubRefreshRequest _defaultInstance;
  static void $checkItem(SubRefreshRequest v) {
    if (v is! SubRefreshRequest)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get channel => $_getS(0, '');
  set channel(String v) {
    $_setString(0, v);
  }

  bool hasChannel() => $_has(0);
  void clearChannel() => clearField(1);

  String get token => $_getS(1, '');
  set token(String v) {
    $_setString(1, v);
  }

  bool hasToken() => $_has(1);
  void clearToken() => clearField(2);
}

class SubRefreshResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SubRefreshResult',
      package: const $pb.PackageName('proto'))
    ..aOB(1, 'expires')
    ..a<int>(2, 'ttl', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  SubRefreshResult() : super();
  SubRefreshResult.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  SubRefreshResult.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  SubRefreshResult clone() => new SubRefreshResult()..mergeFromMessage(this);
  @override
  SubRefreshResult copyWith(void Function(SubRefreshResult) updates) =>
      super.copyWith((message) => updates(message as SubRefreshResult));
  @override
  $pb.BuilderInfo get info_ => _i;
  static SubRefreshResult create() => new SubRefreshResult();
  @override
  SubRefreshResult createEmptyInstance() => create();
  static $pb.PbList<SubRefreshResult> createRepeated() =>
      new $pb.PbList<SubRefreshResult>();
  static SubRefreshResult getDefault() =>
      _defaultInstance ??= create()..freeze();
  static SubRefreshResult _defaultInstance;
  static void $checkItem(SubRefreshResult v) {
    if (v is! SubRefreshResult) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  bool get expires => $_get(0, false);
  set expires(bool v) {
    $_setBool(0, v);
  }

  bool hasExpires() => $_has(0);
  void clearExpires() => clearField(1);

  int get ttl => $_get(1, 0);
  set ttl(int v) {
    $_setUnsignedInt32(1, v);
  }

  bool hasTtl() => $_has(1);
  void clearTtl() => clearField(2);
}

class UnsubscribeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UnsubscribeRequest',
      package: const $pb.PackageName('proto'))
    ..aOS(1, 'channel')
    ..hasRequiredFields = false;

  UnsubscribeRequest() : super();
  UnsubscribeRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  UnsubscribeRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  UnsubscribeRequest clone() =>
      new UnsubscribeRequest()..mergeFromMessage(this);
  @override
  UnsubscribeRequest copyWith(void Function(UnsubscribeRequest) updates) =>
      super.copyWith((message) => updates(message as UnsubscribeRequest));
  @override
  $pb.BuilderInfo get info_ => _i;
  static UnsubscribeRequest create() => new UnsubscribeRequest();
  @override
  UnsubscribeRequest createEmptyInstance() => create();
  static $pb.PbList<UnsubscribeRequest> createRepeated() =>
      new $pb.PbList<UnsubscribeRequest>();
  static UnsubscribeRequest getDefault() =>
      _defaultInstance ??= create()..freeze();
  static UnsubscribeRequest _defaultInstance;
  static void $checkItem(UnsubscribeRequest v) {
    if (v is! UnsubscribeRequest)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get channel => $_getS(0, '');
  set channel(String v) {
    $_setString(0, v);
  }

  bool hasChannel() => $_has(0);
  void clearChannel() => clearField(1);
}

class UnsubscribeResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UnsubscribeResult',
      package: const $pb.PackageName('proto'))
    ..hasRequiredFields = false;

  UnsubscribeResult() : super();
  UnsubscribeResult.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  UnsubscribeResult.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  UnsubscribeResult clone() => new UnsubscribeResult()..mergeFromMessage(this);
  @override
  UnsubscribeResult copyWith(void Function(UnsubscribeResult) updates) =>
      super.copyWith((message) => updates(message as UnsubscribeResult));
  @override
  $pb.BuilderInfo get info_ => _i;
  static UnsubscribeResult create() => new UnsubscribeResult();
  @override
  UnsubscribeResult createEmptyInstance() => create();
  static $pb.PbList<UnsubscribeResult> createRepeated() =>
      new $pb.PbList<UnsubscribeResult>();
  static UnsubscribeResult getDefault() =>
      _defaultInstance ??= create()..freeze();
  static UnsubscribeResult _defaultInstance;
  static void $checkItem(UnsubscribeResult v) {
    if (v is! UnsubscribeResult)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

class PublishRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PublishRequest',
      package: const $pb.PackageName('proto'))
    ..aOS(1, 'channel')
    ..a<List<int>>(2, 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  PublishRequest() : super();
  PublishRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  PublishRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  PublishRequest clone() => new PublishRequest()..mergeFromMessage(this);
  @override
  PublishRequest copyWith(void Function(PublishRequest) updates) =>
      super.copyWith((message) => updates(message as PublishRequest));
  @override
  $pb.BuilderInfo get info_ => _i;
  static PublishRequest create() => new PublishRequest();
  @override
  PublishRequest createEmptyInstance() => create();
  static $pb.PbList<PublishRequest> createRepeated() =>
      new $pb.PbList<PublishRequest>();
  static PublishRequest getDefault() => _defaultInstance ??= create()..freeze();
  static PublishRequest _defaultInstance;
  static void $checkItem(PublishRequest v) {
    if (v is! PublishRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get channel => $_getS(0, '');
  set channel(String v) {
    $_setString(0, v);
  }

  bool hasChannel() => $_has(0);
  void clearChannel() => clearField(1);

  List<int> get data => $_getN(1);
  set data(List<int> v) {
    $_setBytes(1, v);
  }

  bool hasData() => $_has(1);
  void clearData() => clearField(2);
}

class PublishResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PublishResult',
      package: const $pb.PackageName('proto'))
    ..hasRequiredFields = false;

  PublishResult() : super();
  PublishResult.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  PublishResult.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  PublishResult clone() => new PublishResult()..mergeFromMessage(this);
  @override
  PublishResult copyWith(void Function(PublishResult) updates) =>
      super.copyWith((message) => updates(message as PublishResult));
  @override
  $pb.BuilderInfo get info_ => _i;
  static PublishResult create() => new PublishResult();
  @override
  PublishResult createEmptyInstance() => create();
  static $pb.PbList<PublishResult> createRepeated() =>
      new $pb.PbList<PublishResult>();
  static PublishResult getDefault() => _defaultInstance ??= create()..freeze();
  static PublishResult _defaultInstance;
  static void $checkItem(PublishResult v) {
    if (v is! PublishResult) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

class PresenceRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PresenceRequest',
      package: const $pb.PackageName('proto'))
    ..aOS(1, 'channel')
    ..hasRequiredFields = false;

  PresenceRequest() : super();
  PresenceRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  PresenceRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  PresenceRequest clone() => new PresenceRequest()..mergeFromMessage(this);
  @override
  PresenceRequest copyWith(void Function(PresenceRequest) updates) =>
      super.copyWith((message) => updates(message as PresenceRequest));
  @override
  $pb.BuilderInfo get info_ => _i;
  static PresenceRequest create() => new PresenceRequest();
  @override
  PresenceRequest createEmptyInstance() => create();
  static $pb.PbList<PresenceRequest> createRepeated() =>
      new $pb.PbList<PresenceRequest>();
  static PresenceRequest getDefault() =>
      _defaultInstance ??= create()..freeze();
  static PresenceRequest _defaultInstance;
  static void $checkItem(PresenceRequest v) {
    if (v is! PresenceRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get channel => $_getS(0, '');
  set channel(String v) {
    $_setString(0, v);
  }

  bool hasChannel() => $_has(0);
  void clearChannel() => clearField(1);
}

class PresenceResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PresenceResult',
      package: const $pb.PackageName('proto'))
    ..m<String, ClientInfo>(
        1,
        'presence',
        'PresenceResult.PresenceEntry',
        $pb.PbFieldType.OS,
        $pb.PbFieldType.OM,
        ClientInfo.create,
        null,
        null,
        const $pb.PackageName('proto'))
    ..hasRequiredFields = false;

  PresenceResult() : super();
  PresenceResult.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  PresenceResult.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  PresenceResult clone() => new PresenceResult()..mergeFromMessage(this);
  @override
  PresenceResult copyWith(void Function(PresenceResult) updates) =>
      super.copyWith((message) => updates(message as PresenceResult));
  @override
  $pb.BuilderInfo get info_ => _i;
  static PresenceResult create() => new PresenceResult();
  @override
  PresenceResult createEmptyInstance() => create();
  static $pb.PbList<PresenceResult> createRepeated() =>
      new $pb.PbList<PresenceResult>();
  static PresenceResult getDefault() => _defaultInstance ??= create()..freeze();
  static PresenceResult _defaultInstance;
  static void $checkItem(PresenceResult v) {
    if (v is! PresenceResult) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Map<String, ClientInfo> get presence => $_getMap(0);
}

class PresenceStatsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PresenceStatsRequest',
      package: const $pb.PackageName('proto'))
    ..aOS(1, 'channel')
    ..hasRequiredFields = false;

  PresenceStatsRequest() : super();
  PresenceStatsRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  PresenceStatsRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  PresenceStatsRequest clone() =>
      new PresenceStatsRequest()..mergeFromMessage(this);
  @override
  PresenceStatsRequest copyWith(void Function(PresenceStatsRequest) updates) =>
      super.copyWith((message) => updates(message as PresenceStatsRequest));
  @override
  $pb.BuilderInfo get info_ => _i;
  static PresenceStatsRequest create() => new PresenceStatsRequest();
  @override
  PresenceStatsRequest createEmptyInstance() => create();
  static $pb.PbList<PresenceStatsRequest> createRepeated() =>
      new $pb.PbList<PresenceStatsRequest>();
  static PresenceStatsRequest getDefault() =>
      _defaultInstance ??= create()..freeze();
  static PresenceStatsRequest _defaultInstance;
  static void $checkItem(PresenceStatsRequest v) {
    if (v is! PresenceStatsRequest)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get channel => $_getS(0, '');
  set channel(String v) {
    $_setString(0, v);
  }

  bool hasChannel() => $_has(0);
  void clearChannel() => clearField(1);
}

class PresenceStatsResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PresenceStatsResult',
      package: const $pb.PackageName('proto'))
    ..a<int>(1, 'numClients', $pb.PbFieldType.OU3)
    ..a<int>(2, 'numUsers', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  PresenceStatsResult() : super();
  PresenceStatsResult.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  PresenceStatsResult.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  PresenceStatsResult clone() =>
      new PresenceStatsResult()..mergeFromMessage(this);
  @override
  PresenceStatsResult copyWith(void Function(PresenceStatsResult) updates) =>
      super.copyWith((message) => updates(message as PresenceStatsResult));
  @override
  $pb.BuilderInfo get info_ => _i;
  static PresenceStatsResult create() => new PresenceStatsResult();
  @override
  PresenceStatsResult createEmptyInstance() => create();
  static $pb.PbList<PresenceStatsResult> createRepeated() =>
      new $pb.PbList<PresenceStatsResult>();
  static PresenceStatsResult getDefault() =>
      _defaultInstance ??= create()..freeze();
  static PresenceStatsResult _defaultInstance;
  static void $checkItem(PresenceStatsResult v) {
    if (v is! PresenceStatsResult)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get numClients => $_get(0, 0);
  set numClients(int v) {
    $_setUnsignedInt32(0, v);
  }

  bool hasNumClients() => $_has(0);
  void clearNumClients() => clearField(1);

  int get numUsers => $_get(1, 0);
  set numUsers(int v) {
    $_setUnsignedInt32(1, v);
  }

  bool hasNumUsers() => $_has(1);
  void clearNumUsers() => clearField(2);
}

class HistoryRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('HistoryRequest',
      package: const $pb.PackageName('proto'))
    ..aOS(1, 'channel')
    ..hasRequiredFields = false;

  HistoryRequest() : super();
  HistoryRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  HistoryRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  HistoryRequest clone() => new HistoryRequest()..mergeFromMessage(this);
  @override
  HistoryRequest copyWith(void Function(HistoryRequest) updates) =>
      super.copyWith((message) => updates(message as HistoryRequest));
  @override
  $pb.BuilderInfo get info_ => _i;
  static HistoryRequest create() => new HistoryRequest();
  @override
  HistoryRequest createEmptyInstance() => create();
  static $pb.PbList<HistoryRequest> createRepeated() =>
      new $pb.PbList<HistoryRequest>();
  static HistoryRequest getDefault() => _defaultInstance ??= create()..freeze();
  static HistoryRequest _defaultInstance;
  static void $checkItem(HistoryRequest v) {
    if (v is! HistoryRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get channel => $_getS(0, '');
  set channel(String v) {
    $_setString(0, v);
  }

  bool hasChannel() => $_has(0);
  void clearChannel() => clearField(1);
}

class HistoryResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('HistoryResult',
      package: const $pb.PackageName('proto'))
    ..pp<Publication>(1, 'publications', $pb.PbFieldType.PM,
        Publication.$checkItem, Publication.create)
    ..hasRequiredFields = false;

  HistoryResult() : super();
  HistoryResult.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  HistoryResult.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  HistoryResult clone() => new HistoryResult()..mergeFromMessage(this);
  @override
  HistoryResult copyWith(void Function(HistoryResult) updates) =>
      super.copyWith((message) => updates(message as HistoryResult));
  @override
  $pb.BuilderInfo get info_ => _i;
  static HistoryResult create() => new HistoryResult();
  @override
  HistoryResult createEmptyInstance() => create();
  static $pb.PbList<HistoryResult> createRepeated() =>
      new $pb.PbList<HistoryResult>();
  static HistoryResult getDefault() => _defaultInstance ??= create()..freeze();
  static HistoryResult _defaultInstance;
  static void $checkItem(HistoryResult v) {
    if (v is! HistoryResult) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<Publication> get publications => $_getList(0);
}

class PingRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PingRequest',
      package: const $pb.PackageName('proto'))
    ..hasRequiredFields = false;

  PingRequest() : super();
  PingRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  PingRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  PingRequest clone() => new PingRequest()..mergeFromMessage(this);
  @override
  PingRequest copyWith(void Function(PingRequest) updates) =>
      super.copyWith((message) => updates(message as PingRequest));
  @override
  $pb.BuilderInfo get info_ => _i;
  static PingRequest create() => new PingRequest();
  @override
  PingRequest createEmptyInstance() => create();
  static $pb.PbList<PingRequest> createRepeated() =>
      new $pb.PbList<PingRequest>();
  static PingRequest getDefault() => _defaultInstance ??= create()..freeze();
  static PingRequest _defaultInstance;
  static void $checkItem(PingRequest v) {
    if (v is! PingRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

class PingResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('PingResult', package: const $pb.PackageName('proto'))
        ..hasRequiredFields = false;

  PingResult() : super();
  PingResult.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  PingResult.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  PingResult clone() => new PingResult()..mergeFromMessage(this);
  @override
  PingResult copyWith(void Function(PingResult) updates) =>
      super.copyWith((message) => updates(message as PingResult));
  @override
  $pb.BuilderInfo get info_ => _i;
  static PingResult create() => new PingResult();
  @override
  PingResult createEmptyInstance() => create();
  static $pb.PbList<PingResult> createRepeated() =>
      new $pb.PbList<PingResult>();
  static PingResult getDefault() => _defaultInstance ??= create()..freeze();
  static PingResult _defaultInstance;
  static void $checkItem(PingResult v) {
    if (v is! PingResult) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

class RPCRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('RPCRequest', package: const $pb.PackageName('proto'))
        ..a<List<int>>(1, 'data', $pb.PbFieldType.OY)
        ..hasRequiredFields = false;

  RPCRequest() : super();
  RPCRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  RPCRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  RPCRequest clone() => new RPCRequest()..mergeFromMessage(this);
  @override
  RPCRequest copyWith(void Function(RPCRequest) updates) =>
      super.copyWith((message) => updates(message as RPCRequest));
  @override
  $pb.BuilderInfo get info_ => _i;
  static RPCRequest create() => new RPCRequest();
  @override
  RPCRequest createEmptyInstance() => create();
  static $pb.PbList<RPCRequest> createRepeated() =>
      new $pb.PbList<RPCRequest>();
  static RPCRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RPCRequest _defaultInstance;
  static void $checkItem(RPCRequest v) {
    if (v is! RPCRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<int> get data => $_getN(0);
  set data(List<int> v) {
    $_setBytes(0, v);
  }

  bool hasData() => $_has(0);
  void clearData() => clearField(1);
}

class RPCResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('RPCResult', package: const $pb.PackageName('proto'))
        ..a<List<int>>(1, 'data', $pb.PbFieldType.OY)
        ..hasRequiredFields = false;

  RPCResult() : super();
  RPCResult.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  RPCResult.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  RPCResult clone() => new RPCResult()..mergeFromMessage(this);
  @override
  RPCResult copyWith(void Function(RPCResult) updates) =>
      super.copyWith((message) => updates(message as RPCResult));
  @override
  $pb.BuilderInfo get info_ => _i;
  static RPCResult create() => new RPCResult();
  @override
  RPCResult createEmptyInstance() => create();
  static $pb.PbList<RPCResult> createRepeated() => new $pb.PbList<RPCResult>();
  static RPCResult getDefault() => _defaultInstance ??= create()..freeze();
  static RPCResult _defaultInstance;
  static void $checkItem(RPCResult v) {
    if (v is! RPCResult) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<int> get data => $_getN(0);
  set data(List<int> v) {
    $_setBytes(0, v);
  }

  bool hasData() => $_has(0);
  void clearData() => clearField(1);
}

class SendRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SendRequest',
      package: const $pb.PackageName('proto'))
    ..a<List<int>>(1, 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  SendRequest() : super();
  SendRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  SendRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  @override
  SendRequest clone() => new SendRequest()..mergeFromMessage(this);
  @override
  SendRequest copyWith(void Function(SendRequest) updates) =>
      super.copyWith((message) => updates(message as SendRequest));
  @override
  $pb.BuilderInfo get info_ => _i;
  static SendRequest create() => new SendRequest();
  @override
  SendRequest createEmptyInstance() => create();
  static $pb.PbList<SendRequest> createRepeated() =>
      new $pb.PbList<SendRequest>();
  static SendRequest getDefault() => _defaultInstance ??= create()..freeze();
  static SendRequest _defaultInstance;
  static void $checkItem(SendRequest v) {
    if (v is! SendRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<int> get data => $_getN(0);
  set data(List<int> v) {
    $_setBytes(0, v);
  }

  bool hasData() => $_has(0);
  void clearData() => clearField(1);
}
