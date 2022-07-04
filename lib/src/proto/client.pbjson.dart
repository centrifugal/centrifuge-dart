///
//  Generated code. Do not modify.
//  source: client.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use errorDescriptor instead')
const Error$json = const {
  '1': 'Error',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 13, '10': 'code'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'temporary', '3': 3, '4': 1, '5': 8, '10': 'temporary'},
  ],
};

/// Descriptor for `Error`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorDescriptor = $convert.base64Decode('CgVFcnJvchISCgRjb2RlGAEgASgNUgRjb2RlEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2USHAoJdGVtcG9yYXJ5GAMgASgIUgl0ZW1wb3Jhcnk=');
@$core.Deprecated('Use emulationRequestDescriptor instead')
const EmulationRequest$json = const {
  '1': 'EmulationRequest',
  '2': const [
    const {'1': 'node', '3': 1, '4': 1, '5': 9, '10': 'node'},
    const {'1': 'session', '3': 2, '4': 1, '5': 9, '10': 'session'},
    const {'1': 'data', '3': 3, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `EmulationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emulationRequestDescriptor = $convert.base64Decode('ChBFbXVsYXRpb25SZXF1ZXN0EhIKBG5vZGUYASABKAlSBG5vZGUSGAoHc2Vzc2lvbhgCIAEoCVIHc2Vzc2lvbhISCgRkYXRhGAMgASgMUgRkYXRh');
@$core.Deprecated('Use commandDescriptor instead')
const Command$json = const {
  '1': 'Command',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    const {'1': 'method', '3': 2, '4': 1, '5': 14, '6': '.centrifugal.centrifuge.protocol.Command.MethodType', '10': 'method'},
    const {'1': 'params', '3': 3, '4': 1, '5': 12, '10': 'params'},
    const {'1': 'connect', '3': 4, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.ConnectRequest', '10': 'connect'},
    const {'1': 'subscribe', '3': 5, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.SubscribeRequest', '10': 'subscribe'},
    const {'1': 'unsubscribe', '3': 6, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.UnsubscribeRequest', '10': 'unsubscribe'},
    const {'1': 'publish', '3': 7, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.PublishRequest', '10': 'publish'},
    const {'1': 'presence', '3': 8, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.PresenceRequest', '10': 'presence'},
    const {'1': 'presence_stats', '3': 9, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.PresenceStatsRequest', '10': 'presenceStats'},
    const {'1': 'history', '3': 10, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.HistoryRequest', '10': 'history'},
    const {'1': 'ping', '3': 11, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.PingRequest', '10': 'ping'},
    const {'1': 'send', '3': 12, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.SendRequest', '10': 'send'},
    const {'1': 'rpc', '3': 13, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.RPCRequest', '10': 'rpc'},
    const {'1': 'refresh', '3': 14, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.RefreshRequest', '10': 'refresh'},
    const {'1': 'sub_refresh', '3': 15, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.SubRefreshRequest', '10': 'subRefresh'},
  ],
  '4': const [Command_MethodType$json],
};

@$core.Deprecated('Use commandDescriptor instead')
const Command_MethodType$json = const {
  '1': 'MethodType',
  '2': const [
    const {'1': 'CONNECT', '2': 0},
    const {'1': 'SUBSCRIBE', '2': 1},
    const {'1': 'UNSUBSCRIBE', '2': 2},
    const {'1': 'PUBLISH', '2': 3},
    const {'1': 'PRESENCE', '2': 4},
    const {'1': 'PRESENCE_STATS', '2': 5},
    const {'1': 'HISTORY', '2': 6},
    const {'1': 'PING', '2': 7},
    const {'1': 'SEND', '2': 8},
    const {'1': 'RPC', '2': 9},
    const {'1': 'REFRESH', '2': 10},
    const {'1': 'SUB_REFRESH', '2': 11},
  ],
};

/// Descriptor for `Command`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commandDescriptor = $convert.base64Decode('CgdDb21tYW5kEg4KAmlkGAEgASgNUgJpZBJLCgZtZXRob2QYAiABKA4yMy5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLkNvbW1hbmQuTWV0aG9kVHlwZVIGbWV0aG9kEhYKBnBhcmFtcxgDIAEoDFIGcGFyYW1zEkkKB2Nvbm5lY3QYBCABKAsyLy5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLkNvbm5lY3RSZXF1ZXN0Ugdjb25uZWN0Ek8KCXN1YnNjcmliZRgFIAEoCzIxLmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuU3Vic2NyaWJlUmVxdWVzdFIJc3Vic2NyaWJlElUKC3Vuc3Vic2NyaWJlGAYgASgLMjMuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5VbnN1YnNjcmliZVJlcXVlc3RSC3Vuc3Vic2NyaWJlEkkKB3B1Ymxpc2gYByABKAsyLy5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLlB1Ymxpc2hSZXF1ZXN0UgdwdWJsaXNoEkwKCHByZXNlbmNlGAggASgLMjAuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5QcmVzZW5jZVJlcXVlc3RSCHByZXNlbmNlElwKDnByZXNlbmNlX3N0YXRzGAkgASgLMjUuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5QcmVzZW5jZVN0YXRzUmVxdWVzdFINcHJlc2VuY2VTdGF0cxJJCgdoaXN0b3J5GAogASgLMi8uY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5IaXN0b3J5UmVxdWVzdFIHaGlzdG9yeRJACgRwaW5nGAsgASgLMiwuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5QaW5nUmVxdWVzdFIEcGluZxJACgRzZW5kGAwgASgLMiwuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5TZW5kUmVxdWVzdFIEc2VuZBI9CgNycGMYDSABKAsyKy5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLlJQQ1JlcXVlc3RSA3JwYxJJCgdyZWZyZXNoGA4gASgLMi8uY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5SZWZyZXNoUmVxdWVzdFIHcmVmcmVzaBJTCgtzdWJfcmVmcmVzaBgPIAEoCzIyLmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuU3ViUmVmcmVzaFJlcXVlc3RSCnN1YlJlZnJlc2gisAEKCk1ldGhvZFR5cGUSCwoHQ09OTkVDVBAAEg0KCVNVQlNDUklCRRABEg8KC1VOU1VCU0NSSUJFEAISCwoHUFVCTElTSBADEgwKCFBSRVNFTkNFEAQSEgoOUFJFU0VOQ0VfU1RBVFMQBRILCgdISVNUT1JZEAYSCAoEUElORxAHEggKBFNFTkQQCBIHCgNSUEMQCRILCgdSRUZSRVNIEAoSDwoLU1VCX1JFRlJFU0gQCw==');
@$core.Deprecated('Use replyDescriptor instead')
const Reply$json = const {
  '1': 'Reply',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    const {'1': 'error', '3': 2, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Error', '10': 'error'},
    const {'1': 'result', '3': 3, '4': 1, '5': 12, '10': 'result'},
    const {'1': 'push', '3': 4, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Push', '10': 'push'},
    const {'1': 'connect', '3': 5, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.ConnectResult', '10': 'connect'},
    const {'1': 'subscribe', '3': 6, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.SubscribeResult', '10': 'subscribe'},
    const {'1': 'unsubscribe', '3': 7, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.UnsubscribeResult', '10': 'unsubscribe'},
    const {'1': 'publish', '3': 8, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.PublishResult', '10': 'publish'},
    const {'1': 'presence', '3': 9, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.PresenceResult', '10': 'presence'},
    const {'1': 'presence_stats', '3': 10, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.PresenceStatsResult', '10': 'presenceStats'},
    const {'1': 'history', '3': 11, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.HistoryResult', '10': 'history'},
    const {'1': 'ping', '3': 12, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.PingResult', '10': 'ping'},
    const {'1': 'rpc', '3': 13, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.RPCResult', '10': 'rpc'},
    const {'1': 'refresh', '3': 14, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.RefreshResult', '10': 'refresh'},
    const {'1': 'sub_refresh', '3': 15, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.SubRefreshResult', '10': 'subRefresh'},
  ],
};

/// Descriptor for `Reply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replyDescriptor = $convert.base64Decode('CgVSZXBseRIOCgJpZBgBIAEoDVICaWQSPAoFZXJyb3IYAiABKAsyJi5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLkVycm9yUgVlcnJvchIWCgZyZXN1bHQYAyABKAxSBnJlc3VsdBI5CgRwdXNoGAQgASgLMiUuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5QdXNoUgRwdXNoEkgKB2Nvbm5lY3QYBSABKAsyLi5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLkNvbm5lY3RSZXN1bHRSB2Nvbm5lY3QSTgoJc3Vic2NyaWJlGAYgASgLMjAuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5TdWJzY3JpYmVSZXN1bHRSCXN1YnNjcmliZRJUCgt1bnN1YnNjcmliZRgHIAEoCzIyLmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuVW5zdWJzY3JpYmVSZXN1bHRSC3Vuc3Vic2NyaWJlEkgKB3B1Ymxpc2gYCCABKAsyLi5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLlB1Ymxpc2hSZXN1bHRSB3B1Ymxpc2gSSwoIcHJlc2VuY2UYCSABKAsyLy5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLlByZXNlbmNlUmVzdWx0UghwcmVzZW5jZRJbCg5wcmVzZW5jZV9zdGF0cxgKIAEoCzI0LmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuUHJlc2VuY2VTdGF0c1Jlc3VsdFINcHJlc2VuY2VTdGF0cxJICgdoaXN0b3J5GAsgASgLMi4uY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5IaXN0b3J5UmVzdWx0UgdoaXN0b3J5Ej8KBHBpbmcYDCABKAsyKy5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLlBpbmdSZXN1bHRSBHBpbmcSPAoDcnBjGA0gASgLMiouY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5SUENSZXN1bHRSA3JwYxJICgdyZWZyZXNoGA4gASgLMi4uY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5SZWZyZXNoUmVzdWx0UgdyZWZyZXNoElIKC3N1Yl9yZWZyZXNoGA8gASgLMjEuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5TdWJSZWZyZXNoUmVzdWx0UgpzdWJSZWZyZXNo');
@$core.Deprecated('Use pushDescriptor instead')
const Push$json = const {
  '1': 'Push',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.centrifugal.centrifuge.protocol.Push.PushType', '10': 'type'},
    const {'1': 'channel', '3': 2, '4': 1, '5': 9, '10': 'channel'},
    const {'1': 'data', '3': 3, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'pub', '3': 4, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Publication', '10': 'pub'},
    const {'1': 'join', '3': 5, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Join', '10': 'join'},
    const {'1': 'leave', '3': 6, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Leave', '10': 'leave'},
    const {'1': 'unsubscribe', '3': 7, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Unsubscribe', '10': 'unsubscribe'},
    const {'1': 'message', '3': 8, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Message', '10': 'message'},
    const {'1': 'subscribe', '3': 9, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Subscribe', '10': 'subscribe'},
    const {'1': 'connect', '3': 10, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Connect', '10': 'connect'},
    const {'1': 'disconnect', '3': 11, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Disconnect', '10': 'disconnect'},
    const {'1': 'refresh', '3': 12, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Refresh', '10': 'refresh'},
  ],
  '4': const [Push_PushType$json],
};

@$core.Deprecated('Use pushDescriptor instead')
const Push_PushType$json = const {
  '1': 'PushType',
  '2': const [
    const {'1': 'PUBLICATION', '2': 0},
    const {'1': 'JOIN', '2': 1},
    const {'1': 'LEAVE', '2': 2},
    const {'1': 'UNSUBSCRIBE', '2': 3},
    const {'1': 'MESSAGE', '2': 4},
    const {'1': 'SUBSCRIBE', '2': 5},
    const {'1': 'CONNECT', '2': 6},
    const {'1': 'DISCONNECT', '2': 7},
    const {'1': 'REFRESH', '2': 8},
  ],
};

/// Descriptor for `Push`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushDescriptor = $convert.base64Decode('CgRQdXNoEkIKBHR5cGUYASABKA4yLi5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLlB1c2guUHVzaFR5cGVSBHR5cGUSGAoHY2hhbm5lbBgCIAEoCVIHY2hhbm5lbBISCgRkYXRhGAMgASgMUgRkYXRhEj4KA3B1YhgEIAEoCzIsLmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuUHVibGljYXRpb25SA3B1YhI5CgRqb2luGAUgASgLMiUuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5Kb2luUgRqb2luEjwKBWxlYXZlGAYgASgLMiYuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5MZWF2ZVIFbGVhdmUSTgoLdW5zdWJzY3JpYmUYByABKAsyLC5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLlVuc3Vic2NyaWJlUgt1bnN1YnNjcmliZRJCCgdtZXNzYWdlGAggASgLMiguY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5NZXNzYWdlUgdtZXNzYWdlEkgKCXN1YnNjcmliZRgJIAEoCzIqLmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuU3Vic2NyaWJlUglzdWJzY3JpYmUSQgoHY29ubmVjdBgKIAEoCzIoLmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuQ29ubmVjdFIHY29ubmVjdBJLCgpkaXNjb25uZWN0GAsgASgLMisuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5EaXNjb25uZWN0UgpkaXNjb25uZWN0EkIKB3JlZnJlc2gYDCABKAsyKC5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLlJlZnJlc2hSB3JlZnJlc2gihwEKCFB1c2hUeXBlEg8KC1BVQkxJQ0FUSU9OEAASCAoESk9JThABEgkKBUxFQVZFEAISDwoLVU5TVUJTQ1JJQkUQAxILCgdNRVNTQUdFEAQSDQoJU1VCU0NSSUJFEAUSCwoHQ09OTkVDVBAGEg4KCkRJU0NPTk5FQ1QQBxILCgdSRUZSRVNIEAg=');
@$core.Deprecated('Use clientInfoDescriptor instead')
const ClientInfo$json = const {
  '1': 'ClientInfo',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 9, '10': 'user'},
    const {'1': 'client', '3': 2, '4': 1, '5': 9, '10': 'client'},
    const {'1': 'conn_info', '3': 3, '4': 1, '5': 12, '10': 'connInfo'},
    const {'1': 'chan_info', '3': 4, '4': 1, '5': 12, '10': 'chanInfo'},
  ],
};

/// Descriptor for `ClientInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientInfoDescriptor = $convert.base64Decode('CgpDbGllbnRJbmZvEhIKBHVzZXIYASABKAlSBHVzZXISFgoGY2xpZW50GAIgASgJUgZjbGllbnQSGwoJY29ubl9pbmZvGAMgASgMUghjb25uSW5mbxIbCgljaGFuX2luZm8YBCABKAxSCGNoYW5JbmZv');
@$core.Deprecated('Use publicationDescriptor instead')
const Publication$json = const {
  '1': 'Publication',
  '2': const [
    const {'1': 'data', '3': 4, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'info', '3': 5, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.ClientInfo', '10': 'info'},
    const {'1': 'offset', '3': 6, '4': 1, '5': 4, '10': 'offset'},
    const {'1': 'tags', '3': 7, '4': 3, '5': 11, '6': '.centrifugal.centrifuge.protocol.Publication.TagsEntry', '10': 'tags'},
  ],
  '3': const [Publication_TagsEntry$json],
};

@$core.Deprecated('Use publicationDescriptor instead')
const Publication_TagsEntry$json = const {
  '1': 'TagsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `Publication`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publicationDescriptor = $convert.base64Decode('CgtQdWJsaWNhdGlvbhISCgRkYXRhGAQgASgMUgRkYXRhEj8KBGluZm8YBSABKAsyKy5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLkNsaWVudEluZm9SBGluZm8SFgoGb2Zmc2V0GAYgASgEUgZvZmZzZXQSSgoEdGFncxgHIAMoCzI2LmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuUHVibGljYXRpb24uVGFnc0VudHJ5UgR0YWdzGjcKCVRhZ3NFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');
@$core.Deprecated('Use joinDescriptor instead')
const Join$json = const {
  '1': 'Join',
  '2': const [
    const {'1': 'info', '3': 1, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.ClientInfo', '10': 'info'},
  ],
};

/// Descriptor for `Join`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinDescriptor = $convert.base64Decode('CgRKb2luEj8KBGluZm8YASABKAsyKy5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLkNsaWVudEluZm9SBGluZm8=');
@$core.Deprecated('Use leaveDescriptor instead')
const Leave$json = const {
  '1': 'Leave',
  '2': const [
    const {'1': 'info', '3': 1, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.ClientInfo', '10': 'info'},
  ],
};

/// Descriptor for `Leave`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveDescriptor = $convert.base64Decode('CgVMZWF2ZRI/CgRpbmZvGAEgASgLMisuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5DbGllbnRJbmZvUgRpbmZv');
@$core.Deprecated('Use unsubscribeDescriptor instead')
const Unsubscribe$json = const {
  '1': 'Unsubscribe',
  '2': const [
    const {'1': 'code', '3': 2, '4': 1, '5': 13, '10': 'code'},
    const {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `Unsubscribe`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unsubscribeDescriptor = $convert.base64Decode('CgtVbnN1YnNjcmliZRISCgRjb2RlGAIgASgNUgRjb2RlEhYKBnJlYXNvbhgDIAEoCVIGcmVhc29u');
@$core.Deprecated('Use subscribeDescriptor instead')
const Subscribe$json = const {
  '1': 'Subscribe',
  '2': const [
    const {'1': 'recoverable', '3': 1, '4': 1, '5': 8, '10': 'recoverable'},
    const {'1': 'epoch', '3': 4, '4': 1, '5': 9, '10': 'epoch'},
    const {'1': 'offset', '3': 5, '4': 1, '5': 4, '10': 'offset'},
    const {'1': 'positioned', '3': 6, '4': 1, '5': 8, '10': 'positioned'},
    const {'1': 'data', '3': 7, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `Subscribe`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeDescriptor = $convert.base64Decode('CglTdWJzY3JpYmUSIAoLcmVjb3ZlcmFibGUYASABKAhSC3JlY292ZXJhYmxlEhQKBWVwb2NoGAQgASgJUgVlcG9jaBIWCgZvZmZzZXQYBSABKARSBm9mZnNldBIeCgpwb3NpdGlvbmVkGAYgASgIUgpwb3NpdGlvbmVkEhIKBGRhdGEYByABKAxSBGRhdGE=');
@$core.Deprecated('Use messageDescriptor instead')
const Message$json = const {
  '1': 'Message',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode('CgdNZXNzYWdlEhIKBGRhdGEYASABKAxSBGRhdGE=');
@$core.Deprecated('Use connectDescriptor instead')
const Connect$json = const {
  '1': 'Connect',
  '2': const [
    const {'1': 'client', '3': 1, '4': 1, '5': 9, '10': 'client'},
    const {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'data', '3': 3, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'subs', '3': 4, '4': 3, '5': 11, '6': '.centrifugal.centrifuge.protocol.Connect.SubsEntry', '10': 'subs'},
    const {'1': 'expires', '3': 5, '4': 1, '5': 8, '10': 'expires'},
    const {'1': 'ttl', '3': 6, '4': 1, '5': 13, '10': 'ttl'},
    const {'1': 'ping', '3': 7, '4': 1, '5': 13, '10': 'ping'},
    const {'1': 'pong', '3': 8, '4': 1, '5': 8, '10': 'pong'},
    const {'1': 'session', '3': 9, '4': 1, '5': 9, '10': 'session'},
    const {'1': 'node', '3': 10, '4': 1, '5': 9, '10': 'node'},
  ],
  '3': const [Connect_SubsEntry$json],
};

@$core.Deprecated('Use connectDescriptor instead')
const Connect_SubsEntry$json = const {
  '1': 'SubsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.SubscribeResult', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `Connect`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectDescriptor = $convert.base64Decode('CgdDb25uZWN0EhYKBmNsaWVudBgBIAEoCVIGY2xpZW50EhgKB3ZlcnNpb24YAiABKAlSB3ZlcnNpb24SEgoEZGF0YRgDIAEoDFIEZGF0YRJGCgRzdWJzGAQgAygLMjIuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5Db25uZWN0LlN1YnNFbnRyeVIEc3VicxIYCgdleHBpcmVzGAUgASgIUgdleHBpcmVzEhAKA3R0bBgGIAEoDVIDdHRsEhIKBHBpbmcYByABKA1SBHBpbmcSEgoEcG9uZxgIIAEoCFIEcG9uZxIYCgdzZXNzaW9uGAkgASgJUgdzZXNzaW9uEhIKBG5vZGUYCiABKAlSBG5vZGUaaQoJU3Vic0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EkYKBXZhbHVlGAIgASgLMjAuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5TdWJzY3JpYmVSZXN1bHRSBXZhbHVlOgI4AQ==');
@$core.Deprecated('Use disconnectDescriptor instead')
const Disconnect$json = const {
  '1': 'Disconnect',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 13, '10': 'code'},
    const {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    const {'1': 'reconnect', '3': 3, '4': 1, '5': 8, '10': 'reconnect'},
  ],
};

/// Descriptor for `Disconnect`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disconnectDescriptor = $convert.base64Decode('CgpEaXNjb25uZWN0EhIKBGNvZGUYASABKA1SBGNvZGUSFgoGcmVhc29uGAIgASgJUgZyZWFzb24SHAoJcmVjb25uZWN0GAMgASgIUglyZWNvbm5lY3Q=');
@$core.Deprecated('Use refreshDescriptor instead')
const Refresh$json = const {
  '1': 'Refresh',
  '2': const [
    const {'1': 'expires', '3': 1, '4': 1, '5': 8, '10': 'expires'},
    const {'1': 'ttl', '3': 2, '4': 1, '5': 13, '10': 'ttl'},
  ],
};

/// Descriptor for `Refresh`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refreshDescriptor = $convert.base64Decode('CgdSZWZyZXNoEhgKB2V4cGlyZXMYASABKAhSB2V4cGlyZXMSEAoDdHRsGAIgASgNUgN0dGw=');
@$core.Deprecated('Use connectRequestDescriptor instead')
const ConnectRequest$json = const {
  '1': 'ConnectRequest',
  '2': const [
    const {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    const {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'subs', '3': 3, '4': 3, '5': 11, '6': '.centrifugal.centrifuge.protocol.ConnectRequest.SubsEntry', '10': 'subs'},
    const {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'version', '3': 5, '4': 1, '5': 9, '10': 'version'},
  ],
  '3': const [ConnectRequest_SubsEntry$json],
};

@$core.Deprecated('Use connectRequestDescriptor instead')
const ConnectRequest_SubsEntry$json = const {
  '1': 'SubsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.SubscribeRequest', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `ConnectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectRequestDescriptor = $convert.base64Decode('Cg5Db25uZWN0UmVxdWVzdBIUCgV0b2tlbhgBIAEoCVIFdG9rZW4SEgoEZGF0YRgCIAEoDFIEZGF0YRJNCgRzdWJzGAMgAygLMjkuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5Db25uZWN0UmVxdWVzdC5TdWJzRW50cnlSBHN1YnMSEgoEbmFtZRgEIAEoCVIEbmFtZRIYCgd2ZXJzaW9uGAUgASgJUgd2ZXJzaW9uGmoKCVN1YnNFbnRyeRIQCgNrZXkYASABKAlSA2tleRJHCgV2YWx1ZRgCIAEoCzIxLmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuU3Vic2NyaWJlUmVxdWVzdFIFdmFsdWU6AjgB');
@$core.Deprecated('Use connectResultDescriptor instead')
const ConnectResult$json = const {
  '1': 'ConnectResult',
  '2': const [
    const {'1': 'client', '3': 1, '4': 1, '5': 9, '10': 'client'},
    const {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'expires', '3': 3, '4': 1, '5': 8, '10': 'expires'},
    const {'1': 'ttl', '3': 4, '4': 1, '5': 13, '10': 'ttl'},
    const {'1': 'data', '3': 5, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'subs', '3': 6, '4': 3, '5': 11, '6': '.centrifugal.centrifuge.protocol.ConnectResult.SubsEntry', '10': 'subs'},
    const {'1': 'ping', '3': 7, '4': 1, '5': 13, '10': 'ping'},
    const {'1': 'pong', '3': 8, '4': 1, '5': 8, '10': 'pong'},
    const {'1': 'session', '3': 9, '4': 1, '5': 9, '10': 'session'},
    const {'1': 'node', '3': 10, '4': 1, '5': 9, '10': 'node'},
  ],
  '3': const [ConnectResult_SubsEntry$json],
};

@$core.Deprecated('Use connectResultDescriptor instead')
const ConnectResult_SubsEntry$json = const {
  '1': 'SubsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.SubscribeResult', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `ConnectResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectResultDescriptor = $convert.base64Decode('Cg1Db25uZWN0UmVzdWx0EhYKBmNsaWVudBgBIAEoCVIGY2xpZW50EhgKB3ZlcnNpb24YAiABKAlSB3ZlcnNpb24SGAoHZXhwaXJlcxgDIAEoCFIHZXhwaXJlcxIQCgN0dGwYBCABKA1SA3R0bBISCgRkYXRhGAUgASgMUgRkYXRhEkwKBHN1YnMYBiADKAsyOC5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLkNvbm5lY3RSZXN1bHQuU3Vic0VudHJ5UgRzdWJzEhIKBHBpbmcYByABKA1SBHBpbmcSEgoEcG9uZxgIIAEoCFIEcG9uZxIYCgdzZXNzaW9uGAkgASgJUgdzZXNzaW9uEhIKBG5vZGUYCiABKAlSBG5vZGUaaQoJU3Vic0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EkYKBXZhbHVlGAIgASgLMjAuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5TdWJzY3JpYmVSZXN1bHRSBXZhbHVlOgI4AQ==');
@$core.Deprecated('Use refreshRequestDescriptor instead')
const RefreshRequest$json = const {
  '1': 'RefreshRequest',
  '2': const [
    const {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `RefreshRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refreshRequestDescriptor = $convert.base64Decode('Cg5SZWZyZXNoUmVxdWVzdBIUCgV0b2tlbhgBIAEoCVIFdG9rZW4=');
@$core.Deprecated('Use refreshResultDescriptor instead')
const RefreshResult$json = const {
  '1': 'RefreshResult',
  '2': const [
    const {'1': 'client', '3': 1, '4': 1, '5': 9, '10': 'client'},
    const {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'expires', '3': 3, '4': 1, '5': 8, '10': 'expires'},
    const {'1': 'ttl', '3': 4, '4': 1, '5': 13, '10': 'ttl'},
  ],
};

/// Descriptor for `RefreshResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refreshResultDescriptor = $convert.base64Decode('Cg1SZWZyZXNoUmVzdWx0EhYKBmNsaWVudBgBIAEoCVIGY2xpZW50EhgKB3ZlcnNpb24YAiABKAlSB3ZlcnNpb24SGAoHZXhwaXJlcxgDIAEoCFIHZXhwaXJlcxIQCgN0dGwYBCABKA1SA3R0bA==');
@$core.Deprecated('Use subscribeRequestDescriptor instead')
const SubscribeRequest$json = const {
  '1': 'SubscribeRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
    const {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    const {'1': 'recover', '3': 3, '4': 1, '5': 8, '10': 'recover'},
    const {'1': 'epoch', '3': 6, '4': 1, '5': 9, '10': 'epoch'},
    const {'1': 'offset', '3': 7, '4': 1, '5': 4, '10': 'offset'},
    const {'1': 'data', '3': 8, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'positioned', '3': 9, '4': 1, '5': 8, '10': 'positioned'},
    const {'1': 'recoverable', '3': 10, '4': 1, '5': 8, '10': 'recoverable'},
    const {'1': 'join_leave', '3': 11, '4': 1, '5': 8, '10': 'joinLeave'},
  ],
};

/// Descriptor for `SubscribeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeRequestDescriptor = $convert.base64Decode('ChBTdWJzY3JpYmVSZXF1ZXN0EhgKB2NoYW5uZWwYASABKAlSB2NoYW5uZWwSFAoFdG9rZW4YAiABKAlSBXRva2VuEhgKB3JlY292ZXIYAyABKAhSB3JlY292ZXISFAoFZXBvY2gYBiABKAlSBWVwb2NoEhYKBm9mZnNldBgHIAEoBFIGb2Zmc2V0EhIKBGRhdGEYCCABKAxSBGRhdGESHgoKcG9zaXRpb25lZBgJIAEoCFIKcG9zaXRpb25lZBIgCgtyZWNvdmVyYWJsZRgKIAEoCFILcmVjb3ZlcmFibGUSHQoKam9pbl9sZWF2ZRgLIAEoCFIJam9pbkxlYXZl');
@$core.Deprecated('Use subscribeResultDescriptor instead')
const SubscribeResult$json = const {
  '1': 'SubscribeResult',
  '2': const [
    const {'1': 'expires', '3': 1, '4': 1, '5': 8, '10': 'expires'},
    const {'1': 'ttl', '3': 2, '4': 1, '5': 13, '10': 'ttl'},
    const {'1': 'recoverable', '3': 3, '4': 1, '5': 8, '10': 'recoverable'},
    const {'1': 'epoch', '3': 6, '4': 1, '5': 9, '10': 'epoch'},
    const {'1': 'publications', '3': 7, '4': 3, '5': 11, '6': '.centrifugal.centrifuge.protocol.Publication', '10': 'publications'},
    const {'1': 'recovered', '3': 8, '4': 1, '5': 8, '10': 'recovered'},
    const {'1': 'offset', '3': 9, '4': 1, '5': 4, '10': 'offset'},
    const {'1': 'positioned', '3': 10, '4': 1, '5': 8, '10': 'positioned'},
    const {'1': 'data', '3': 11, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'was_recovering', '3': 12, '4': 1, '5': 8, '10': 'wasRecovering'},
  ],
};

/// Descriptor for `SubscribeResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeResultDescriptor = $convert.base64Decode('Cg9TdWJzY3JpYmVSZXN1bHQSGAoHZXhwaXJlcxgBIAEoCFIHZXhwaXJlcxIQCgN0dGwYAiABKA1SA3R0bBIgCgtyZWNvdmVyYWJsZRgDIAEoCFILcmVjb3ZlcmFibGUSFAoFZXBvY2gYBiABKAlSBWVwb2NoElAKDHB1YmxpY2F0aW9ucxgHIAMoCzIsLmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuUHVibGljYXRpb25SDHB1YmxpY2F0aW9ucxIcCglyZWNvdmVyZWQYCCABKAhSCXJlY292ZXJlZBIWCgZvZmZzZXQYCSABKARSBm9mZnNldBIeCgpwb3NpdGlvbmVkGAogASgIUgpwb3NpdGlvbmVkEhIKBGRhdGEYCyABKAxSBGRhdGESJQoOd2FzX3JlY292ZXJpbmcYDCABKAhSDXdhc1JlY292ZXJpbmc=');
@$core.Deprecated('Use subRefreshRequestDescriptor instead')
const SubRefreshRequest$json = const {
  '1': 'SubRefreshRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
    const {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `SubRefreshRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subRefreshRequestDescriptor = $convert.base64Decode('ChFTdWJSZWZyZXNoUmVxdWVzdBIYCgdjaGFubmVsGAEgASgJUgdjaGFubmVsEhQKBXRva2VuGAIgASgJUgV0b2tlbg==');
@$core.Deprecated('Use subRefreshResultDescriptor instead')
const SubRefreshResult$json = const {
  '1': 'SubRefreshResult',
  '2': const [
    const {'1': 'expires', '3': 1, '4': 1, '5': 8, '10': 'expires'},
    const {'1': 'ttl', '3': 2, '4': 1, '5': 13, '10': 'ttl'},
  ],
};

/// Descriptor for `SubRefreshResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subRefreshResultDescriptor = $convert.base64Decode('ChBTdWJSZWZyZXNoUmVzdWx0EhgKB2V4cGlyZXMYASABKAhSB2V4cGlyZXMSEAoDdHRsGAIgASgNUgN0dGw=');
@$core.Deprecated('Use unsubscribeRequestDescriptor instead')
const UnsubscribeRequest$json = const {
  '1': 'UnsubscribeRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
  ],
};

/// Descriptor for `UnsubscribeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unsubscribeRequestDescriptor = $convert.base64Decode('ChJVbnN1YnNjcmliZVJlcXVlc3QSGAoHY2hhbm5lbBgBIAEoCVIHY2hhbm5lbA==');
@$core.Deprecated('Use unsubscribeResultDescriptor instead')
const UnsubscribeResult$json = const {
  '1': 'UnsubscribeResult',
};

/// Descriptor for `UnsubscribeResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unsubscribeResultDescriptor = $convert.base64Decode('ChFVbnN1YnNjcmliZVJlc3VsdA==');
@$core.Deprecated('Use publishRequestDescriptor instead')
const PublishRequest$json = const {
  '1': 'PublishRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
    const {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `PublishRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishRequestDescriptor = $convert.base64Decode('Cg5QdWJsaXNoUmVxdWVzdBIYCgdjaGFubmVsGAEgASgJUgdjaGFubmVsEhIKBGRhdGEYAiABKAxSBGRhdGE=');
@$core.Deprecated('Use publishResultDescriptor instead')
const PublishResult$json = const {
  '1': 'PublishResult',
};

/// Descriptor for `PublishResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishResultDescriptor = $convert.base64Decode('Cg1QdWJsaXNoUmVzdWx0');
@$core.Deprecated('Use presenceRequestDescriptor instead')
const PresenceRequest$json = const {
  '1': 'PresenceRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
  ],
};

/// Descriptor for `PresenceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List presenceRequestDescriptor = $convert.base64Decode('Cg9QcmVzZW5jZVJlcXVlc3QSGAoHY2hhbm5lbBgBIAEoCVIHY2hhbm5lbA==');
@$core.Deprecated('Use presenceResultDescriptor instead')
const PresenceResult$json = const {
  '1': 'PresenceResult',
  '2': const [
    const {'1': 'presence', '3': 1, '4': 3, '5': 11, '6': '.centrifugal.centrifuge.protocol.PresenceResult.PresenceEntry', '10': 'presence'},
  ],
  '3': const [PresenceResult_PresenceEntry$json],
};

@$core.Deprecated('Use presenceResultDescriptor instead')
const PresenceResult_PresenceEntry$json = const {
  '1': 'PresenceEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.ClientInfo', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `PresenceResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List presenceResultDescriptor = $convert.base64Decode('Cg5QcmVzZW5jZVJlc3VsdBJZCghwcmVzZW5jZRgBIAMoCzI9LmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuUHJlc2VuY2VSZXN1bHQuUHJlc2VuY2VFbnRyeVIIcHJlc2VuY2UaaAoNUHJlc2VuY2VFbnRyeRIQCgNrZXkYASABKAlSA2tleRJBCgV2YWx1ZRgCIAEoCzIrLmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuQ2xpZW50SW5mb1IFdmFsdWU6AjgB');
@$core.Deprecated('Use presenceStatsRequestDescriptor instead')
const PresenceStatsRequest$json = const {
  '1': 'PresenceStatsRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
  ],
};

/// Descriptor for `PresenceStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List presenceStatsRequestDescriptor = $convert.base64Decode('ChRQcmVzZW5jZVN0YXRzUmVxdWVzdBIYCgdjaGFubmVsGAEgASgJUgdjaGFubmVs');
@$core.Deprecated('Use presenceStatsResultDescriptor instead')
const PresenceStatsResult$json = const {
  '1': 'PresenceStatsResult',
  '2': const [
    const {'1': 'num_clients', '3': 1, '4': 1, '5': 13, '10': 'numClients'},
    const {'1': 'num_users', '3': 2, '4': 1, '5': 13, '10': 'numUsers'},
  ],
};

/// Descriptor for `PresenceStatsResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List presenceStatsResultDescriptor = $convert.base64Decode('ChNQcmVzZW5jZVN0YXRzUmVzdWx0Eh8KC251bV9jbGllbnRzGAEgASgNUgpudW1DbGllbnRzEhsKCW51bV91c2VycxgCIAEoDVIIbnVtVXNlcnM=');
@$core.Deprecated('Use streamPositionDescriptor instead')
const StreamPosition$json = const {
  '1': 'StreamPosition',
  '2': const [
    const {'1': 'offset', '3': 1, '4': 1, '5': 4, '10': 'offset'},
    const {'1': 'epoch', '3': 2, '4': 1, '5': 9, '10': 'epoch'},
  ],
};

/// Descriptor for `StreamPosition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamPositionDescriptor = $convert.base64Decode('Cg5TdHJlYW1Qb3NpdGlvbhIWCgZvZmZzZXQYASABKARSBm9mZnNldBIUCgVlcG9jaBgCIAEoCVIFZXBvY2g=');
@$core.Deprecated('Use historyRequestDescriptor instead')
const HistoryRequest$json = const {
  '1': 'HistoryRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
    const {'1': 'limit', '3': 7, '4': 1, '5': 5, '10': 'limit'},
    const {'1': 'since', '3': 8, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.StreamPosition', '10': 'since'},
    const {'1': 'reverse', '3': 9, '4': 1, '5': 8, '10': 'reverse'},
  ],
};

/// Descriptor for `HistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List historyRequestDescriptor = $convert.base64Decode('Cg5IaXN0b3J5UmVxdWVzdBIYCgdjaGFubmVsGAEgASgJUgdjaGFubmVsEhQKBWxpbWl0GAcgASgFUgVsaW1pdBJFCgVzaW5jZRgIIAEoCzIvLmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuU3RyZWFtUG9zaXRpb25SBXNpbmNlEhgKB3JldmVyc2UYCSABKAhSB3JldmVyc2U=');
@$core.Deprecated('Use historyResultDescriptor instead')
const HistoryResult$json = const {
  '1': 'HistoryResult',
  '2': const [
    const {'1': 'publications', '3': 1, '4': 3, '5': 11, '6': '.centrifugal.centrifuge.protocol.Publication', '10': 'publications'},
    const {'1': 'epoch', '3': 2, '4': 1, '5': 9, '10': 'epoch'},
    const {'1': 'offset', '3': 3, '4': 1, '5': 4, '10': 'offset'},
  ],
};

/// Descriptor for `HistoryResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List historyResultDescriptor = $convert.base64Decode('Cg1IaXN0b3J5UmVzdWx0ElAKDHB1YmxpY2F0aW9ucxgBIAMoCzIsLmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuUHVibGljYXRpb25SDHB1YmxpY2F0aW9ucxIUCgVlcG9jaBgCIAEoCVIFZXBvY2gSFgoGb2Zmc2V0GAMgASgEUgZvZmZzZXQ=');
@$core.Deprecated('Use pingRequestDescriptor instead')
const PingRequest$json = const {
  '1': 'PingRequest',
};

/// Descriptor for `PingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingRequestDescriptor = $convert.base64Decode('CgtQaW5nUmVxdWVzdA==');
@$core.Deprecated('Use pingResultDescriptor instead')
const PingResult$json = const {
  '1': 'PingResult',
};

/// Descriptor for `PingResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingResultDescriptor = $convert.base64Decode('CgpQaW5nUmVzdWx0');
@$core.Deprecated('Use rPCRequestDescriptor instead')
const RPCRequest$json = const {
  '1': 'RPCRequest',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'method', '3': 2, '4': 1, '5': 9, '10': 'method'},
  ],
};

/// Descriptor for `RPCRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rPCRequestDescriptor = $convert.base64Decode('CgpSUENSZXF1ZXN0EhIKBGRhdGEYASABKAxSBGRhdGESFgoGbWV0aG9kGAIgASgJUgZtZXRob2Q=');
@$core.Deprecated('Use rPCResultDescriptor instead')
const RPCResult$json = const {
  '1': 'RPCResult',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `RPCResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rPCResultDescriptor = $convert.base64Decode('CglSUENSZXN1bHQSEgoEZGF0YRgBIAEoDFIEZGF0YQ==');
@$core.Deprecated('Use sendRequestDescriptor instead')
const SendRequest$json = const {
  '1': 'SendRequest',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `SendRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendRequestDescriptor = $convert.base64Decode('CgtTZW5kUmVxdWVzdBISCgRkYXRhGAEgASgMUgRkYXRh');
