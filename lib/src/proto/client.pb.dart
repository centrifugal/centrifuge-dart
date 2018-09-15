///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart';

import 'client.pbenum.dart';

export 'client.pbenum.dart';

class Error extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Error')
    ..a<int>(1, 'code', PbFieldType.OU3)
    ..aOS(2, 'message')
    ..hasRequiredFields = false;

  Error() : super();
  Error.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Error.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  Error clone() => new Error()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Error create() => new Error();
  static PbList<Error> createRepeated() => new PbList<Error>();
  static Error getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyError();
    return _defaultInstance;
  }

  static Error _defaultInstance;
  static void $checkItem(Error v) {
    if (v is! Error) checkItemFailed(v, 'Error');
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

class _ReadonlyError extends Error with ReadonlyMessageMixin {}

class Command extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Command')
    ..a<int>(1, 'id', PbFieldType.OU3)
    ..e<MethodType>(2, 'method', PbFieldType.OE, MethodType.CONNECT,
        MethodType.valueOf, MethodType.values)
    ..a<List<int>>(3, 'params', PbFieldType.OY)
    ..hasRequiredFields = false;

  Command() : super();
  Command.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Command.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  Command clone() => new Command()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Command create() => new Command();
  static PbList<Command> createRepeated() => new PbList<Command>();
  static Command getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyCommand();
    return _defaultInstance;
  }

  static Command _defaultInstance;
  static void $checkItem(Command v) {
    if (v is! Command) checkItemFailed(v, 'Command');
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

class _ReadonlyCommand extends Command with ReadonlyMessageMixin {}

class Reply extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Reply')
    ..a<int>(1, 'id', PbFieldType.OU3)
    ..a<Error>(2, 'error', PbFieldType.OM, Error.getDefault, Error.create)
    ..a<List<int>>(3, 'result', PbFieldType.OY)
    ..hasRequiredFields = false;

  Reply() : super();
  Reply.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Reply.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  Reply clone() => new Reply()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Reply create() => new Reply();
  static PbList<Reply> createRepeated() => new PbList<Reply>();
  static Reply getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyReply();
    return _defaultInstance;
  }

  static Reply _defaultInstance;
  static void $checkItem(Reply v) {
    if (v is! Reply) checkItemFailed(v, 'Reply');
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

class _ReadonlyReply extends Reply with ReadonlyMessageMixin {}

class Push extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Push')
    ..e<PushType>(1, 'type', PbFieldType.OE, PushType.PUBLICATION,
        PushType.valueOf, PushType.values)
    ..aOS(2, 'channel')
    ..a<List<int>>(3, 'data', PbFieldType.OY)
    ..hasRequiredFields = false;

  Push() : super();
  Push.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Push.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  Push clone() => new Push()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Push create() => new Push();
  static PbList<Push> createRepeated() => new PbList<Push>();
  static Push getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyPush();
    return _defaultInstance;
  }

  static Push _defaultInstance;
  static void $checkItem(Push v) {
    if (v is! Push) checkItemFailed(v, 'Push');
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

class _ReadonlyPush extends Push with ReadonlyMessageMixin {}

class ClientInfo extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ClientInfo')
    ..aOS(1, 'user')
    ..aOS(2, 'client')
    ..a<List<int>>(3, 'connInfo', PbFieldType.OY)
    ..a<List<int>>(4, 'chanInfo', PbFieldType.OY)
    ..hasRequiredFields = false;

  ClientInfo() : super();
  ClientInfo.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ClientInfo.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ClientInfo clone() => new ClientInfo()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ClientInfo create() => new ClientInfo();
  static PbList<ClientInfo> createRepeated() => new PbList<ClientInfo>();
  static ClientInfo getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyClientInfo();
    return _defaultInstance;
  }

  static ClientInfo _defaultInstance;
  static void $checkItem(ClientInfo v) {
    if (v is! ClientInfo) checkItemFailed(v, 'ClientInfo');
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

class _ReadonlyClientInfo extends ClientInfo with ReadonlyMessageMixin {}

class Publication extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Publication')
    ..a<int>(1, 'seq', PbFieldType.OU3)
    ..a<int>(2, 'gen', PbFieldType.OU3)
    ..aOS(3, 'uid')
    ..a<List<int>>(4, 'data', PbFieldType.OY)
    ..a<ClientInfo>(
        5, 'info', PbFieldType.OM, ClientInfo.getDefault, ClientInfo.create)
    ..hasRequiredFields = false;

  Publication() : super();
  Publication.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Publication.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  Publication clone() => new Publication()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Publication create() => new Publication();
  static PbList<Publication> createRepeated() => new PbList<Publication>();
  static Publication getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyPublication();
    return _defaultInstance;
  }

  static Publication _defaultInstance;
  static void $checkItem(Publication v) {
    if (v is! Publication) checkItemFailed(v, 'Publication');
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

class _ReadonlyPublication extends Publication with ReadonlyMessageMixin {}

class Join extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Join')
    ..a<ClientInfo>(
        1, 'info', PbFieldType.OM, ClientInfo.getDefault, ClientInfo.create)
    ..hasRequiredFields = false;

  Join() : super();
  Join.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Join.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  Join clone() => new Join()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Join create() => new Join();
  static PbList<Join> createRepeated() => new PbList<Join>();
  static Join getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyJoin();
    return _defaultInstance;
  }

  static Join _defaultInstance;
  static void $checkItem(Join v) {
    if (v is! Join) checkItemFailed(v, 'Join');
  }

  ClientInfo get info => $_getN(0);
  set info(ClientInfo v) {
    setField(1, v);
  }

  bool hasInfo() => $_has(0);
  void clearInfo() => clearField(1);
}

class _ReadonlyJoin extends Join with ReadonlyMessageMixin {}

class Leave extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Leave')
    ..a<ClientInfo>(
        1, 'info', PbFieldType.OM, ClientInfo.getDefault, ClientInfo.create)
    ..hasRequiredFields = false;

  Leave() : super();
  Leave.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Leave.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  Leave clone() => new Leave()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Leave create() => new Leave();
  static PbList<Leave> createRepeated() => new PbList<Leave>();
  static Leave getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyLeave();
    return _defaultInstance;
  }

  static Leave _defaultInstance;
  static void $checkItem(Leave v) {
    if (v is! Leave) checkItemFailed(v, 'Leave');
  }

  ClientInfo get info => $_getN(0);
  set info(ClientInfo v) {
    setField(1, v);
  }

  bool hasInfo() => $_has(0);
  void clearInfo() => clearField(1);
}

class _ReadonlyLeave extends Leave with ReadonlyMessageMixin {}

class Unsub extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Unsub')
    ..aOB(1, 'resubscribe')
    ..hasRequiredFields = false;

  Unsub() : super();
  Unsub.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Unsub.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  Unsub clone() => new Unsub()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Unsub create() => new Unsub();
  static PbList<Unsub> createRepeated() => new PbList<Unsub>();
  static Unsub getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyUnsub();
    return _defaultInstance;
  }

  static Unsub _defaultInstance;
  static void $checkItem(Unsub v) {
    if (v is! Unsub) checkItemFailed(v, 'Unsub');
  }

  bool get resubscribe => $_get(0, false);
  set resubscribe(bool v) {
    $_setBool(0, v);
  }

  bool hasResubscribe() => $_has(0);
  void clearResubscribe() => clearField(1);
}

class _ReadonlyUnsub extends Unsub with ReadonlyMessageMixin {}

class Message extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Message')
    ..a<List<int>>(1, 'data', PbFieldType.OY)
    ..hasRequiredFields = false;

  Message() : super();
  Message.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Message.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  Message clone() => new Message()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Message create() => new Message();
  static PbList<Message> createRepeated() => new PbList<Message>();
  static Message getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyMessage();
    return _defaultInstance;
  }

  static Message _defaultInstance;
  static void $checkItem(Message v) {
    if (v is! Message) checkItemFailed(v, 'Message');
  }

  List<int> get data => $_getN(0);
  set data(List<int> v) {
    $_setBytes(0, v);
  }

  bool hasData() => $_has(0);
  void clearData() => clearField(1);
}

class _ReadonlyMessage extends Message with ReadonlyMessageMixin {}

class ConnectRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ConnectRequest')
    ..aOS(1, 'token')
    ..a<List<int>>(2, 'data', PbFieldType.OY)
    ..hasRequiredFields = false;

  ConnectRequest() : super();
  ConnectRequest.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConnectRequest.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ConnectRequest clone() => new ConnectRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ConnectRequest create() => new ConnectRequest();
  static PbList<ConnectRequest> createRepeated() =>
      new PbList<ConnectRequest>();
  static ConnectRequest getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyConnectRequest();
    return _defaultInstance;
  }

  static ConnectRequest _defaultInstance;
  static void $checkItem(ConnectRequest v) {
    if (v is! ConnectRequest) checkItemFailed(v, 'ConnectRequest');
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

class _ReadonlyConnectRequest extends ConnectRequest with ReadonlyMessageMixin {
}

class ConnectResult extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ConnectResult')
    ..aOS(1, 'client')
    ..aOS(2, 'version')
    ..aOB(3, 'expires')
    ..a<int>(4, 'ttl', PbFieldType.OU3)
    ..a<List<int>>(5, 'data', PbFieldType.OY)
    ..hasRequiredFields = false;

  ConnectResult() : super();
  ConnectResult.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConnectResult.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ConnectResult clone() => new ConnectResult()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ConnectResult create() => new ConnectResult();
  static PbList<ConnectResult> createRepeated() => new PbList<ConnectResult>();
  static ConnectResult getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyConnectResult();
    return _defaultInstance;
  }

  static ConnectResult _defaultInstance;
  static void $checkItem(ConnectResult v) {
    if (v is! ConnectResult) checkItemFailed(v, 'ConnectResult');
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

class _ReadonlyConnectResult extends ConnectResult with ReadonlyMessageMixin {}

class RefreshRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('RefreshRequest')
    ..aOS(1, 'token')
    ..hasRequiredFields = false;

  RefreshRequest() : super();
  RefreshRequest.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  RefreshRequest.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  RefreshRequest clone() => new RefreshRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static RefreshRequest create() => new RefreshRequest();
  static PbList<RefreshRequest> createRepeated() =>
      new PbList<RefreshRequest>();
  static RefreshRequest getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyRefreshRequest();
    return _defaultInstance;
  }

  static RefreshRequest _defaultInstance;
  static void $checkItem(RefreshRequest v) {
    if (v is! RefreshRequest) checkItemFailed(v, 'RefreshRequest');
  }

  String get token => $_getS(0, '');
  set token(String v) {
    $_setString(0, v);
  }

  bool hasToken() => $_has(0);
  void clearToken() => clearField(1);
}

class _ReadonlyRefreshRequest extends RefreshRequest with ReadonlyMessageMixin {
}

class RefreshResult extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('RefreshResult')
    ..aOS(1, 'client')
    ..aOS(2, 'version')
    ..aOB(3, 'expires')
    ..a<int>(4, 'ttl', PbFieldType.OU3)
    ..hasRequiredFields = false;

  RefreshResult() : super();
  RefreshResult.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  RefreshResult.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  RefreshResult clone() => new RefreshResult()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static RefreshResult create() => new RefreshResult();
  static PbList<RefreshResult> createRepeated() => new PbList<RefreshResult>();
  static RefreshResult getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyRefreshResult();
    return _defaultInstance;
  }

  static RefreshResult _defaultInstance;
  static void $checkItem(RefreshResult v) {
    if (v is! RefreshResult) checkItemFailed(v, 'RefreshResult');
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

class _ReadonlyRefreshResult extends RefreshResult with ReadonlyMessageMixin {}

class SubscribeRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('SubscribeRequest')
    ..aOS(1, 'channel')
    ..aOS(2, 'token')
    ..aOB(3, 'recover')
    ..a<int>(4, 'seq', PbFieldType.OU3)
    ..a<int>(5, 'gen', PbFieldType.OU3)
    ..aOS(6, 'epoch')
    ..hasRequiredFields = false;

  SubscribeRequest() : super();
  SubscribeRequest.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  SubscribeRequest.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  SubscribeRequest clone() => new SubscribeRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static SubscribeRequest create() => new SubscribeRequest();
  static PbList<SubscribeRequest> createRepeated() =>
      new PbList<SubscribeRequest>();
  static SubscribeRequest getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlySubscribeRequest();
    return _defaultInstance;
  }

  static SubscribeRequest _defaultInstance;
  static void $checkItem(SubscribeRequest v) {
    if (v is! SubscribeRequest) checkItemFailed(v, 'SubscribeRequest');
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

class _ReadonlySubscribeRequest extends SubscribeRequest
    with ReadonlyMessageMixin {}

class SubscribeResult extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('SubscribeResult')
    ..aOB(1, 'expires')
    ..a<int>(2, 'ttl', PbFieldType.OU3)
    ..aOB(3, 'recoverable')
    ..a<int>(4, 'seq', PbFieldType.OU3)
    ..a<int>(5, 'gen', PbFieldType.OU3)
    ..aOS(6, 'epoch')
    ..pp<Publication>(7, 'publications', PbFieldType.PM, Publication.$checkItem,
        Publication.create)
    ..aOB(8, 'recovered')
    ..hasRequiredFields = false;

  SubscribeResult() : super();
  SubscribeResult.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  SubscribeResult.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  SubscribeResult clone() => new SubscribeResult()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static SubscribeResult create() => new SubscribeResult();
  static PbList<SubscribeResult> createRepeated() =>
      new PbList<SubscribeResult>();
  static SubscribeResult getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlySubscribeResult();
    return _defaultInstance;
  }

  static SubscribeResult _defaultInstance;
  static void $checkItem(SubscribeResult v) {
    if (v is! SubscribeResult) checkItemFailed(v, 'SubscribeResult');
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

class _ReadonlySubscribeResult extends SubscribeResult
    with ReadonlyMessageMixin {}

class SubRefreshRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('SubRefreshRequest')
    ..aOS(1, 'channel')
    ..aOS(2, 'token')
    ..hasRequiredFields = false;

  SubRefreshRequest() : super();
  SubRefreshRequest.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  SubRefreshRequest.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  SubRefreshRequest clone() => new SubRefreshRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static SubRefreshRequest create() => new SubRefreshRequest();
  static PbList<SubRefreshRequest> createRepeated() =>
      new PbList<SubRefreshRequest>();
  static SubRefreshRequest getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlySubRefreshRequest();
    return _defaultInstance;
  }

  static SubRefreshRequest _defaultInstance;
  static void $checkItem(SubRefreshRequest v) {
    if (v is! SubRefreshRequest) checkItemFailed(v, 'SubRefreshRequest');
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

class _ReadonlySubRefreshRequest extends SubRefreshRequest
    with ReadonlyMessageMixin {}

class SubRefreshResult extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('SubRefreshResult')
    ..aOB(1, 'expires')
    ..a<int>(2, 'ttl', PbFieldType.OU3)
    ..hasRequiredFields = false;

  SubRefreshResult() : super();
  SubRefreshResult.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  SubRefreshResult.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  SubRefreshResult clone() => new SubRefreshResult()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static SubRefreshResult create() => new SubRefreshResult();
  static PbList<SubRefreshResult> createRepeated() =>
      new PbList<SubRefreshResult>();
  static SubRefreshResult getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlySubRefreshResult();
    return _defaultInstance;
  }

  static SubRefreshResult _defaultInstance;
  static void $checkItem(SubRefreshResult v) {
    if (v is! SubRefreshResult) checkItemFailed(v, 'SubRefreshResult');
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

class _ReadonlySubRefreshResult extends SubRefreshResult
    with ReadonlyMessageMixin {}

class UnsubscribeRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UnsubscribeRequest')
    ..aOS(1, 'channel')
    ..hasRequiredFields = false;

  UnsubscribeRequest() : super();
  UnsubscribeRequest.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  UnsubscribeRequest.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  UnsubscribeRequest clone() =>
      new UnsubscribeRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UnsubscribeRequest create() => new UnsubscribeRequest();
  static PbList<UnsubscribeRequest> createRepeated() =>
      new PbList<UnsubscribeRequest>();
  static UnsubscribeRequest getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyUnsubscribeRequest();
    return _defaultInstance;
  }

  static UnsubscribeRequest _defaultInstance;
  static void $checkItem(UnsubscribeRequest v) {
    if (v is! UnsubscribeRequest) checkItemFailed(v, 'UnsubscribeRequest');
  }

  String get channel => $_getS(0, '');
  set channel(String v) {
    $_setString(0, v);
  }

  bool hasChannel() => $_has(0);
  void clearChannel() => clearField(1);
}

class _ReadonlyUnsubscribeRequest extends UnsubscribeRequest
    with ReadonlyMessageMixin {}

class UnsubscribeResult extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UnsubscribeResult')
    ..hasRequiredFields = false;

  UnsubscribeResult() : super();
  UnsubscribeResult.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  UnsubscribeResult.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  UnsubscribeResult clone() => new UnsubscribeResult()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UnsubscribeResult create() => new UnsubscribeResult();
  static PbList<UnsubscribeResult> createRepeated() =>
      new PbList<UnsubscribeResult>();
  static UnsubscribeResult getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyUnsubscribeResult();
    return _defaultInstance;
  }

  static UnsubscribeResult _defaultInstance;
  static void $checkItem(UnsubscribeResult v) {
    if (v is! UnsubscribeResult) checkItemFailed(v, 'UnsubscribeResult');
  }
}

class _ReadonlyUnsubscribeResult extends UnsubscribeResult
    with ReadonlyMessageMixin {}

class PublishRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PublishRequest')
    ..aOS(1, 'channel')
    ..a<List<int>>(2, 'data', PbFieldType.OY)
    ..hasRequiredFields = false;

  PublishRequest() : super();
  PublishRequest.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  PublishRequest.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  PublishRequest clone() => new PublishRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static PublishRequest create() => new PublishRequest();
  static PbList<PublishRequest> createRepeated() =>
      new PbList<PublishRequest>();
  static PublishRequest getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyPublishRequest();
    return _defaultInstance;
  }

  static PublishRequest _defaultInstance;
  static void $checkItem(PublishRequest v) {
    if (v is! PublishRequest) checkItemFailed(v, 'PublishRequest');
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

class _ReadonlyPublishRequest extends PublishRequest with ReadonlyMessageMixin {
}

class PublishResult extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PublishResult')
    ..hasRequiredFields = false;

  PublishResult() : super();
  PublishResult.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  PublishResult.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  PublishResult clone() => new PublishResult()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static PublishResult create() => new PublishResult();
  static PbList<PublishResult> createRepeated() => new PbList<PublishResult>();
  static PublishResult getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyPublishResult();
    return _defaultInstance;
  }

  static PublishResult _defaultInstance;
  static void $checkItem(PublishResult v) {
    if (v is! PublishResult) checkItemFailed(v, 'PublishResult');
  }
}

class _ReadonlyPublishResult extends PublishResult with ReadonlyMessageMixin {}

class PresenceRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PresenceRequest')
    ..aOS(1, 'channel')
    ..hasRequiredFields = false;

  PresenceRequest() : super();
  PresenceRequest.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  PresenceRequest.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  PresenceRequest clone() => new PresenceRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static PresenceRequest create() => new PresenceRequest();
  static PbList<PresenceRequest> createRepeated() =>
      new PbList<PresenceRequest>();
  static PresenceRequest getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyPresenceRequest();
    return _defaultInstance;
  }

  static PresenceRequest _defaultInstance;
  static void $checkItem(PresenceRequest v) {
    if (v is! PresenceRequest) checkItemFailed(v, 'PresenceRequest');
  }

  String get channel => $_getS(0, '');
  set channel(String v) {
    $_setString(0, v);
  }

  bool hasChannel() => $_has(0);
  void clearChannel() => clearField(1);
}

class _ReadonlyPresenceRequest extends PresenceRequest
    with ReadonlyMessageMixin {}

class PresenceResult_PresenceEntry extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PresenceResult_PresenceEntry')
    ..aOS(1, 'key')
    ..a<ClientInfo>(
        2, 'value', PbFieldType.OM, ClientInfo.getDefault, ClientInfo.create)
    ..hasRequiredFields = false;

  PresenceResult_PresenceEntry() : super();
  PresenceResult_PresenceEntry.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  PresenceResult_PresenceEntry.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  PresenceResult_PresenceEntry clone() =>
      new PresenceResult_PresenceEntry()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static PresenceResult_PresenceEntry create() =>
      new PresenceResult_PresenceEntry();
  static PbList<PresenceResult_PresenceEntry> createRepeated() =>
      new PbList<PresenceResult_PresenceEntry>();
  static PresenceResult_PresenceEntry getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyPresenceResult_PresenceEntry();
    return _defaultInstance;
  }

  static PresenceResult_PresenceEntry _defaultInstance;
  static void $checkItem(PresenceResult_PresenceEntry v) {
    if (v is! PresenceResult_PresenceEntry)
      checkItemFailed(v, 'PresenceResult_PresenceEntry');
  }

  String get key => $_getS(0, '');
  set key(String v) {
    $_setString(0, v);
  }

  bool hasKey() => $_has(0);
  void clearKey() => clearField(1);

  ClientInfo get value => $_getN(1);
  set value(ClientInfo v) {
    setField(2, v);
  }

  bool hasValue() => $_has(1);
  void clearValue() => clearField(2);
}

class _ReadonlyPresenceResult_PresenceEntry extends PresenceResult_PresenceEntry
    with ReadonlyMessageMixin {}

class PresenceResult extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PresenceResult')
    ..pp<PresenceResult_PresenceEntry>(
        1,
        'presence',
        PbFieldType.PM,
        PresenceResult_PresenceEntry.$checkItem,
        PresenceResult_PresenceEntry.create)
    ..hasRequiredFields = false;

  PresenceResult() : super();
  PresenceResult.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  PresenceResult.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  PresenceResult clone() => new PresenceResult()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static PresenceResult create() => new PresenceResult();
  static PbList<PresenceResult> createRepeated() =>
      new PbList<PresenceResult>();
  static PresenceResult getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyPresenceResult();
    return _defaultInstance;
  }

  static PresenceResult _defaultInstance;
  static void $checkItem(PresenceResult v) {
    if (v is! PresenceResult) checkItemFailed(v, 'PresenceResult');
  }

  List<PresenceResult_PresenceEntry> get presence => $_getList(0);
}

class _ReadonlyPresenceResult extends PresenceResult with ReadonlyMessageMixin {
}

class PresenceStatsRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PresenceStatsRequest')
    ..aOS(1, 'channel')
    ..hasRequiredFields = false;

  PresenceStatsRequest() : super();
  PresenceStatsRequest.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  PresenceStatsRequest.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  PresenceStatsRequest clone() =>
      new PresenceStatsRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static PresenceStatsRequest create() => new PresenceStatsRequest();
  static PbList<PresenceStatsRequest> createRepeated() =>
      new PbList<PresenceStatsRequest>();
  static PresenceStatsRequest getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyPresenceStatsRequest();
    return _defaultInstance;
  }

  static PresenceStatsRequest _defaultInstance;
  static void $checkItem(PresenceStatsRequest v) {
    if (v is! PresenceStatsRequest) checkItemFailed(v, 'PresenceStatsRequest');
  }

  String get channel => $_getS(0, '');
  set channel(String v) {
    $_setString(0, v);
  }

  bool hasChannel() => $_has(0);
  void clearChannel() => clearField(1);
}

class _ReadonlyPresenceStatsRequest extends PresenceStatsRequest
    with ReadonlyMessageMixin {}

class PresenceStatsResult extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PresenceStatsResult')
    ..a<int>(1, 'numClients', PbFieldType.OU3)
    ..a<int>(2, 'numUsers', PbFieldType.OU3)
    ..hasRequiredFields = false;

  PresenceStatsResult() : super();
  PresenceStatsResult.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  PresenceStatsResult.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  PresenceStatsResult clone() =>
      new PresenceStatsResult()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static PresenceStatsResult create() => new PresenceStatsResult();
  static PbList<PresenceStatsResult> createRepeated() =>
      new PbList<PresenceStatsResult>();
  static PresenceStatsResult getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyPresenceStatsResult();
    return _defaultInstance;
  }

  static PresenceStatsResult _defaultInstance;
  static void $checkItem(PresenceStatsResult v) {
    if (v is! PresenceStatsResult) checkItemFailed(v, 'PresenceStatsResult');
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

class _ReadonlyPresenceStatsResult extends PresenceStatsResult
    with ReadonlyMessageMixin {}

class HistoryRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('HistoryRequest')
    ..aOS(1, 'channel')
    ..hasRequiredFields = false;

  HistoryRequest() : super();
  HistoryRequest.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  HistoryRequest.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  HistoryRequest clone() => new HistoryRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static HistoryRequest create() => new HistoryRequest();
  static PbList<HistoryRequest> createRepeated() =>
      new PbList<HistoryRequest>();
  static HistoryRequest getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyHistoryRequest();
    return _defaultInstance;
  }

  static HistoryRequest _defaultInstance;
  static void $checkItem(HistoryRequest v) {
    if (v is! HistoryRequest) checkItemFailed(v, 'HistoryRequest');
  }

  String get channel => $_getS(0, '');
  set channel(String v) {
    $_setString(0, v);
  }

  bool hasChannel() => $_has(0);
  void clearChannel() => clearField(1);
}

class _ReadonlyHistoryRequest extends HistoryRequest with ReadonlyMessageMixin {
}

class HistoryResult extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('HistoryResult')
    ..pp<Publication>(1, 'publications', PbFieldType.PM, Publication.$checkItem,
        Publication.create)
    ..hasRequiredFields = false;

  HistoryResult() : super();
  HistoryResult.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  HistoryResult.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  HistoryResult clone() => new HistoryResult()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static HistoryResult create() => new HistoryResult();
  static PbList<HistoryResult> createRepeated() => new PbList<HistoryResult>();
  static HistoryResult getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyHistoryResult();
    return _defaultInstance;
  }

  static HistoryResult _defaultInstance;
  static void $checkItem(HistoryResult v) {
    if (v is! HistoryResult) checkItemFailed(v, 'HistoryResult');
  }

  List<Publication> get publications => $_getList(0);
}

class _ReadonlyHistoryResult extends HistoryResult with ReadonlyMessageMixin {}

class PingRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PingRequest')
    ..hasRequiredFields = false;

  PingRequest() : super();
  PingRequest.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  PingRequest.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  PingRequest clone() => new PingRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static PingRequest create() => new PingRequest();
  static PbList<PingRequest> createRepeated() => new PbList<PingRequest>();
  static PingRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyPingRequest();
    return _defaultInstance;
  }

  static PingRequest _defaultInstance;
  static void $checkItem(PingRequest v) {
    if (v is! PingRequest) checkItemFailed(v, 'PingRequest');
  }
}

class _ReadonlyPingRequest extends PingRequest with ReadonlyMessageMixin {}

class PingResult extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PingResult')
    ..hasRequiredFields = false;

  PingResult() : super();
  PingResult.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  PingResult.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  PingResult clone() => new PingResult()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static PingResult create() => new PingResult();
  static PbList<PingResult> createRepeated() => new PbList<PingResult>();
  static PingResult getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyPingResult();
    return _defaultInstance;
  }

  static PingResult _defaultInstance;
  static void $checkItem(PingResult v) {
    if (v is! PingResult) checkItemFailed(v, 'PingResult');
  }
}

class _ReadonlyPingResult extends PingResult with ReadonlyMessageMixin {}

class RPCRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('RPCRequest')
    ..a<List<int>>(1, 'data', PbFieldType.OY)
    ..hasRequiredFields = false;

  RPCRequest() : super();
  RPCRequest.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  RPCRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  RPCRequest clone() => new RPCRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static RPCRequest create() => new RPCRequest();
  static PbList<RPCRequest> createRepeated() => new PbList<RPCRequest>();
  static RPCRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyRPCRequest();
    return _defaultInstance;
  }

  static RPCRequest _defaultInstance;
  static void $checkItem(RPCRequest v) {
    if (v is! RPCRequest) checkItemFailed(v, 'RPCRequest');
  }

  List<int> get data => $_getN(0);
  set data(List<int> v) {
    $_setBytes(0, v);
  }

  bool hasData() => $_has(0);
  void clearData() => clearField(1);
}

class _ReadonlyRPCRequest extends RPCRequest with ReadonlyMessageMixin {}

class RPCResult extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('RPCResult')
    ..a<List<int>>(1, 'data', PbFieldType.OY)
    ..hasRequiredFields = false;

  RPCResult() : super();
  RPCResult.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  RPCResult.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  RPCResult clone() => new RPCResult()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static RPCResult create() => new RPCResult();
  static PbList<RPCResult> createRepeated() => new PbList<RPCResult>();
  static RPCResult getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyRPCResult();
    return _defaultInstance;
  }

  static RPCResult _defaultInstance;
  static void $checkItem(RPCResult v) {
    if (v is! RPCResult) checkItemFailed(v, 'RPCResult');
  }

  List<int> get data => $_getN(0);
  set data(List<int> v) {
    $_setBytes(0, v);
  }

  bool hasData() => $_has(0);
  void clearData() => clearField(1);
}

class _ReadonlyRPCResult extends RPCResult with ReadonlyMessageMixin {}

class SendRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('SendRequest')
    ..a<List<int>>(1, 'data', PbFieldType.OY)
    ..hasRequiredFields = false;

  SendRequest() : super();
  SendRequest.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  SendRequest.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  SendRequest clone() => new SendRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static SendRequest create() => new SendRequest();
  static PbList<SendRequest> createRepeated() => new PbList<SendRequest>();
  static SendRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlySendRequest();
    return _defaultInstance;
  }

  static SendRequest _defaultInstance;
  static void $checkItem(SendRequest v) {
    if (v is! SendRequest) checkItemFailed(v, 'SendRequest');
  }

  List<int> get data => $_getN(0);
  set data(List<int> v) {
    $_setBytes(0, v);
  }

  bool hasData() => $_has(0);
  void clearData() => clearField(1);
}

class _ReadonlySendRequest extends SendRequest with ReadonlyMessageMixin {}
