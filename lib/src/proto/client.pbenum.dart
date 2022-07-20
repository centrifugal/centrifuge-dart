///
//  Generated code. Do not modify.
//  source: client.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class Command_MethodType extends $pb.ProtobufEnum {
  static const Command_MethodType CONNECT = Command_MethodType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CONNECT');
  static const Command_MethodType SUBSCRIBE = Command_MethodType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SUBSCRIBE');
  static const Command_MethodType UNSUBSCRIBE = Command_MethodType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UNSUBSCRIBE');
  static const Command_MethodType PUBLISH = Command_MethodType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PUBLISH');
  static const Command_MethodType PRESENCE = Command_MethodType._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PRESENCE');
  static const Command_MethodType PRESENCE_STATS = Command_MethodType._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PRESENCE_STATS');
  static const Command_MethodType HISTORY = Command_MethodType._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'HISTORY');
  static const Command_MethodType PING = Command_MethodType._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PING');
  static const Command_MethodType SEND = Command_MethodType._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SEND');
  static const Command_MethodType RPC = Command_MethodType._(9, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RPC');
  static const Command_MethodType REFRESH = Command_MethodType._(10, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'REFRESH');
  static const Command_MethodType SUB_REFRESH = Command_MethodType._(11, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SUB_REFRESH');

  static const $core.List<Command_MethodType> values = <Command_MethodType> [
    CONNECT,
    SUBSCRIBE,
    UNSUBSCRIBE,
    PUBLISH,
    PRESENCE,
    PRESENCE_STATS,
    HISTORY,
    PING,
    SEND,
    RPC,
    REFRESH,
    SUB_REFRESH,
  ];

  static final $core.Map<$core.int, Command_MethodType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Command_MethodType? valueOf($core.int value) => _byValue[value];

  const Command_MethodType._($core.int v, $core.String n) : super(v, n);
}

class Push_PushType extends $pb.ProtobufEnum {
  static const Push_PushType PUBLICATION = Push_PushType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PUBLICATION');
  static const Push_PushType JOIN = Push_PushType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'JOIN');
  static const Push_PushType LEAVE = Push_PushType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LEAVE');
  static const Push_PushType UNSUBSCRIBE = Push_PushType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UNSUBSCRIBE');
  static const Push_PushType MESSAGE = Push_PushType._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MESSAGE');
  static const Push_PushType SUBSCRIBE = Push_PushType._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SUBSCRIBE');
  static const Push_PushType CONNECT = Push_PushType._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CONNECT');
  static const Push_PushType DISCONNECT = Push_PushType._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DISCONNECT');
  static const Push_PushType REFRESH = Push_PushType._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'REFRESH');

  static const $core.List<Push_PushType> values = <Push_PushType> [
    PUBLICATION,
    JOIN,
    LEAVE,
    UNSUBSCRIBE,
    MESSAGE,
    SUBSCRIBE,
    CONNECT,
    DISCONNECT,
    REFRESH,
  ];

  static final $core.Map<$core.int, Push_PushType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Push_PushType? valueOf($core.int value) => _byValue[value];

  const Push_PushType._($core.int v, $core.String n) : super(v, n);
}

