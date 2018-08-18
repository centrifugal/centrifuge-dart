///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes, unnecessary_const, avoid_as, sort_constructors_first

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart';

class MethodType extends ProtobufEnum {
  static const MethodType CONNECT = const MethodType._(0, 'CONNECT');
  static const MethodType SUBSCRIBE = const MethodType._(1, 'SUBSCRIBE');
  static const MethodType UNSUBSCRIBE = const MethodType._(2, 'UNSUBSCRIBE');
  static const MethodType PUBLISH = const MethodType._(3, 'PUBLISH');
  static const MethodType PRESENCE = const MethodType._(4, 'PRESENCE');
  static const MethodType PRESENCE_STATS =
      const MethodType._(5, 'PRESENCE_STATS');
  static const MethodType HISTORY = const MethodType._(6, 'HISTORY');
  static const MethodType PING = const MethodType._(7, 'PING');
  static const MethodType SEND = const MethodType._(8, 'SEND');
  static const MethodType RPC = const MethodType._(9, 'RPC');
  static const MethodType REFRESH = const MethodType._(10, 'REFRESH');
  static const MethodType SUB_REFRESH = const MethodType._(11, 'SUB_REFRESH');

  static const List<MethodType> values = const <MethodType>[
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

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static MethodType valueOf(int value) => _byValue[value] as MethodType;
  static void $checkItem(MethodType v) {
    if (v is! MethodType) checkItemFailed(v, 'MethodType');
  }

  const MethodType._(int v, String n) : super(v, n);
}

class PushType extends ProtobufEnum {
  static const PushType PUBLICATION = const PushType._(0, 'PUBLICATION');
  static const PushType JOIN = const PushType._(1, 'JOIN');
  static const PushType LEAVE = const PushType._(2, 'LEAVE');
  static const PushType UNSUB = const PushType._(3, 'UNSUB');
  static const PushType MESSAGE = const PushType._(4, 'MESSAGE');

  static const List<PushType> values = const <PushType>[
    PUBLICATION,
    JOIN,
    LEAVE,
    UNSUB,
    MESSAGE,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static PushType valueOf(int value) => _byValue[value] as PushType;
  static void $checkItem(PushType v) {
    if (v is! PushType) checkItemFailed(v, 'PushType');
  }

  const PushType._(int v, String n) : super(v, n);
}
