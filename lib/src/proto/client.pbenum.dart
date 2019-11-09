///
//  Generated code. Do not modify.
//  source: client.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
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

  static const List<MethodType> values = <MethodType>[
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

  static final Map<int, MethodType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static MethodType valueOf(int value) => _byValue[value];
  static void $checkItem(MethodType v) {
    if (v is! MethodType) $pb.checkItemFailed(v, 'MethodType');
  }

  const MethodType._(int v, String n) : super(v, n);
}

class PushType extends $pb.ProtobufEnum {
  static const PushType PUBLICATION = PushType._(0, 'PUBLICATION');
  static const PushType JOIN = PushType._(1, 'JOIN');
  static const PushType LEAVE = PushType._(2, 'LEAVE');
  static const PushType UNSUB = PushType._(3, 'UNSUB');
  static const PushType MESSAGE = PushType._(4, 'MESSAGE');

  static const List<PushType> values = <PushType>[
    PUBLICATION,
    JOIN,
    LEAVE,
    UNSUB,
    MESSAGE,
  ];

  static final Map<int, PushType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static PushType valueOf(int value) => _byValue[value];
  static void $checkItem(PushType v) {
    if (v is! PushType) $pb.checkItemFailed(v, 'PushType');
  }

  const PushType._(int v, String n) : super(v, n);
}
