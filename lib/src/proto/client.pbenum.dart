///
//  Generated code. Do not modify.
//  source: client.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class MethodType extends $pb.ProtobufEnum {
  static const MethodType CONNECT = MethodType._(0, 'CONNECT');
  static const MethodType SUBSCRIBE = MethodType._(1, 'SUBSCRIBE');
  static const MethodType UNSUBSCRIBE = MethodType._(2, 'UNSUBSCRIBE');
  static const MethodType PUBLISH = MethodType._(3, 'PUBLISH');
  static const MethodType PRESENCE = MethodType._(4, 'PRESENCE');
  static const MethodType PRESENCE_STATS = MethodType._(5, 'PRESENCE_STATS');
  static const MethodType HISTORY = MethodType._(6, 'HISTORY');
  static const MethodType PING = MethodType._(7, 'PING');
  static const MethodType SEND = MethodType._(8, 'SEND');
  static const MethodType RPC = MethodType._(9, 'RPC');
  static const MethodType REFRESH = MethodType._(10, 'REFRESH');
  static const MethodType SUB_REFRESH = MethodType._(11, 'SUB_REFRESH');

  static const $core.List<MethodType> values = <MethodType>[
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

  static final $core.Map<$core.int, MethodType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static MethodType valueOf($core.int value) => _byValue[value];

  const MethodType._($core.int v, $core.String n) : super(v, n);
}

class PushType extends $pb.ProtobufEnum {
  static const PushType PUBLICATION = PushType._(0, 'PUBLICATION');
  static const PushType JOIN = PushType._(1, 'JOIN');
  static const PushType LEAVE = PushType._(2, 'LEAVE');
  static const PushType UNSUB = PushType._(3, 'UNSUB');
  static const PushType MESSAGE = PushType._(4, 'MESSAGE');
  static const PushType SUB = PushType._(5, 'SUB');

  static const $core.List<PushType> values = <PushType>[
    PUBLICATION,
    JOIN,
    LEAVE,
    UNSUB,
    MESSAGE,
    SUB,
  ];

  static final $core.Map<$core.int, PushType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static PushType valueOf($core.int value) => _byValue[value];

  const PushType._($core.int v, $core.String n) : super(v, n);
}
