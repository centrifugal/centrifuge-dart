//
//  Generated code. Do not modify.
//  source: client.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use errorDescriptor instead')
const Error$json = {
  '1': 'Error',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 13, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'temporary', '3': 3, '4': 1, '5': 8, '10': 'temporary'},
  ],
};

/// Descriptor for `Error`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorDescriptor = $convert.base64Decode(
    'CgVFcnJvchISCgRjb2RlGAEgASgNUgRjb2RlEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2USHA'
    'oJdGVtcG9yYXJ5GAMgASgIUgl0ZW1wb3Jhcnk=');

@$core.Deprecated('Use emulationRequestDescriptor instead')
const EmulationRequest$json = {
  '1': 'EmulationRequest',
  '2': [
    {'1': 'node', '3': 1, '4': 1, '5': 9, '10': 'node'},
    {'1': 'session', '3': 2, '4': 1, '5': 9, '10': 'session'},
    {'1': 'data', '3': 3, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `EmulationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emulationRequestDescriptor = $convert.base64Decode(
    'ChBFbXVsYXRpb25SZXF1ZXN0EhIKBG5vZGUYASABKAlSBG5vZGUSGAoHc2Vzc2lvbhgCIAEoCV'
    'IHc2Vzc2lvbhISCgRkYXRhGAMgASgMUgRkYXRh');

@$core.Deprecated('Use commandDescriptor instead')
const Command$json = {
  '1': 'Command',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {'1': 'connect', '3': 4, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.ConnectRequest', '10': 'connect'},
    {'1': 'subscribe', '3': 5, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.SubscribeRequest', '10': 'subscribe'},
    {'1': 'unsubscribe', '3': 6, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.UnsubscribeRequest', '10': 'unsubscribe'},
    {'1': 'publish', '3': 7, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.PublishRequest', '10': 'publish'},
    {'1': 'presence', '3': 8, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.PresenceRequest', '10': 'presence'},
    {'1': 'presence_stats', '3': 9, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.PresenceStatsRequest', '10': 'presenceStats'},
    {'1': 'history', '3': 10, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.HistoryRequest', '10': 'history'},
    {'1': 'ping', '3': 11, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.PingRequest', '10': 'ping'},
    {'1': 'send', '3': 12, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.SendRequest', '10': 'send'},
    {'1': 'rpc', '3': 13, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.RPCRequest', '10': 'rpc'},
    {'1': 'refresh', '3': 14, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.RefreshRequest', '10': 'refresh'},
    {'1': 'sub_refresh', '3': 15, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.SubRefreshRequest', '10': 'subRefresh'},
  ],
  '9': [
    {'1': 2, '2': 3},
    {'1': 3, '2': 4},
  ],
};

/// Descriptor for `Command`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commandDescriptor = $convert.base64Decode(
    'CgdDb21tYW5kEg4KAmlkGAEgASgNUgJpZBJJCgdjb25uZWN0GAQgASgLMi8uY2VudHJpZnVnYW'
    'wuY2VudHJpZnVnZS5wcm90b2NvbC5Db25uZWN0UmVxdWVzdFIHY29ubmVjdBJPCglzdWJzY3Jp'
    'YmUYBSABKAsyMS5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLlN1YnNjcmliZVJlcX'
    'Vlc3RSCXN1YnNjcmliZRJVCgt1bnN1YnNjcmliZRgGIAEoCzIzLmNlbnRyaWZ1Z2FsLmNlbnRy'
    'aWZ1Z2UucHJvdG9jb2wuVW5zdWJzY3JpYmVSZXF1ZXN0Ugt1bnN1YnNjcmliZRJJCgdwdWJsaX'
    'NoGAcgASgLMi8uY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5QdWJsaXNoUmVxdWVz'
    'dFIHcHVibGlzaBJMCghwcmVzZW5jZRgIIAEoCzIwLmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucH'
    'JvdG9jb2wuUHJlc2VuY2VSZXF1ZXN0UghwcmVzZW5jZRJcCg5wcmVzZW5jZV9zdGF0cxgJIAEo'
    'CzI1LmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuUHJlc2VuY2VTdGF0c1JlcXVlc3'
    'RSDXByZXNlbmNlU3RhdHMSSQoHaGlzdG9yeRgKIAEoCzIvLmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1'
    'Z2UucHJvdG9jb2wuSGlzdG9yeVJlcXVlc3RSB2hpc3RvcnkSQAoEcGluZxgLIAEoCzIsLmNlbn'
    'RyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuUGluZ1JlcXVlc3RSBHBpbmcSQAoEc2VuZBgM'
    'IAEoCzIsLmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuU2VuZFJlcXVlc3RSBHNlbm'
    'QSPQoDcnBjGA0gASgLMisuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5SUENSZXF1'
    'ZXN0UgNycGMSSQoHcmVmcmVzaBgOIAEoCzIvLmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG'
    '9jb2wuUmVmcmVzaFJlcXVlc3RSB3JlZnJlc2gSUwoLc3ViX3JlZnJlc2gYDyABKAsyMi5jZW50'
    'cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLlN1YlJlZnJlc2hSZXF1ZXN0UgpzdWJSZWZyZX'
    'NoSgQIAhADSgQIAxAE');

@$core.Deprecated('Use replyDescriptor instead')
const Reply$json = {
  '1': 'Reply',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {'1': 'error', '3': 2, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Error', '10': 'error'},
    {'1': 'push', '3': 4, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Push', '10': 'push'},
    {'1': 'connect', '3': 5, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.ConnectResult', '10': 'connect'},
    {'1': 'subscribe', '3': 6, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.SubscribeResult', '10': 'subscribe'},
    {'1': 'unsubscribe', '3': 7, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.UnsubscribeResult', '10': 'unsubscribe'},
    {'1': 'publish', '3': 8, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.PublishResult', '10': 'publish'},
    {'1': 'presence', '3': 9, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.PresenceResult', '10': 'presence'},
    {'1': 'presence_stats', '3': 10, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.PresenceStatsResult', '10': 'presenceStats'},
    {'1': 'history', '3': 11, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.HistoryResult', '10': 'history'},
    {'1': 'ping', '3': 12, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.PingResult', '10': 'ping'},
    {'1': 'rpc', '3': 13, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.RPCResult', '10': 'rpc'},
    {'1': 'refresh', '3': 14, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.RefreshResult', '10': 'refresh'},
    {'1': 'sub_refresh', '3': 15, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.SubRefreshResult', '10': 'subRefresh'},
  ],
  '9': [
    {'1': 3, '2': 4},
  ],
};

/// Descriptor for `Reply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replyDescriptor = $convert.base64Decode(
    'CgVSZXBseRIOCgJpZBgBIAEoDVICaWQSPAoFZXJyb3IYAiABKAsyJi5jZW50cmlmdWdhbC5jZW'
    '50cmlmdWdlLnByb3RvY29sLkVycm9yUgVlcnJvchI5CgRwdXNoGAQgASgLMiUuY2VudHJpZnVn'
    'YWwuY2VudHJpZnVnZS5wcm90b2NvbC5QdXNoUgRwdXNoEkgKB2Nvbm5lY3QYBSABKAsyLi5jZW'
    '50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLkNvbm5lY3RSZXN1bHRSB2Nvbm5lY3QSTgoJ'
    'c3Vic2NyaWJlGAYgASgLMjAuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5TdWJzY3'
    'JpYmVSZXN1bHRSCXN1YnNjcmliZRJUCgt1bnN1YnNjcmliZRgHIAEoCzIyLmNlbnRyaWZ1Z2Fs'
    'LmNlbnRyaWZ1Z2UucHJvdG9jb2wuVW5zdWJzY3JpYmVSZXN1bHRSC3Vuc3Vic2NyaWJlEkgKB3'
    'B1Ymxpc2gYCCABKAsyLi5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLlB1Ymxpc2hS'
    'ZXN1bHRSB3B1Ymxpc2gSSwoIcHJlc2VuY2UYCSABKAsyLy5jZW50cmlmdWdhbC5jZW50cmlmdW'
    'dlLnByb3RvY29sLlByZXNlbmNlUmVzdWx0UghwcmVzZW5jZRJbCg5wcmVzZW5jZV9zdGF0cxgK'
    'IAEoCzI0LmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuUHJlc2VuY2VTdGF0c1Jlc3'
    'VsdFINcHJlc2VuY2VTdGF0cxJICgdoaXN0b3J5GAsgASgLMi4uY2VudHJpZnVnYWwuY2VudHJp'
    'ZnVnZS5wcm90b2NvbC5IaXN0b3J5UmVzdWx0UgdoaXN0b3J5Ej8KBHBpbmcYDCABKAsyKy5jZW'
    '50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLlBpbmdSZXN1bHRSBHBpbmcSPAoDcnBjGA0g'
    'ASgLMiouY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5SUENSZXN1bHRSA3JwYxJICg'
    'dyZWZyZXNoGA4gASgLMi4uY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5SZWZyZXNo'
    'UmVzdWx0UgdyZWZyZXNoElIKC3N1Yl9yZWZyZXNoGA8gASgLMjEuY2VudHJpZnVnYWwuY2VudH'
    'JpZnVnZS5wcm90b2NvbC5TdWJSZWZyZXNoUmVzdWx0UgpzdWJSZWZyZXNoSgQIAxAE');

@$core.Deprecated('Use pushDescriptor instead')
const Push$json = {
  '1': 'Push',
  '2': [
    {'1': 'channel', '3': 2, '4': 1, '5': 9, '10': 'channel'},
    {'1': 'pub', '3': 4, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Publication', '10': 'pub'},
    {'1': 'join', '3': 5, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Join', '10': 'join'},
    {'1': 'leave', '3': 6, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Leave', '10': 'leave'},
    {'1': 'unsubscribe', '3': 7, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Unsubscribe', '10': 'unsubscribe'},
    {'1': 'message', '3': 8, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Message', '10': 'message'},
    {'1': 'subscribe', '3': 9, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Subscribe', '10': 'subscribe'},
    {'1': 'connect', '3': 10, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Connect', '10': 'connect'},
    {'1': 'disconnect', '3': 11, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Disconnect', '10': 'disconnect'},
    {'1': 'refresh', '3': 12, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.Refresh', '10': 'refresh'},
  ],
  '9': [
    {'1': 1, '2': 2},
    {'1': 3, '2': 4},
  ],
};

/// Descriptor for `Push`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushDescriptor = $convert.base64Decode(
    'CgRQdXNoEhgKB2NoYW5uZWwYAiABKAlSB2NoYW5uZWwSPgoDcHViGAQgASgLMiwuY2VudHJpZn'
    'VnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5QdWJsaWNhdGlvblIDcHViEjkKBGpvaW4YBSABKAsy'
    'JS5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLkpvaW5SBGpvaW4SPAoFbGVhdmUYBi'
    'ABKAsyJi5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLkxlYXZlUgVsZWF2ZRJOCgt1'
    'bnN1YnNjcmliZRgHIAEoCzIsLmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuVW5zdW'
    'JzY3JpYmVSC3Vuc3Vic2NyaWJlEkIKB21lc3NhZ2UYCCABKAsyKC5jZW50cmlmdWdhbC5jZW50'
    'cmlmdWdlLnByb3RvY29sLk1lc3NhZ2VSB21lc3NhZ2USSAoJc3Vic2NyaWJlGAkgASgLMiouY2'
    'VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5TdWJzY3JpYmVSCXN1YnNjcmliZRJCCgdj'
    'b25uZWN0GAogASgLMiguY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5Db25uZWN0Ug'
    'djb25uZWN0EksKCmRpc2Nvbm5lY3QYCyABKAsyKy5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnBy'
    'b3RvY29sLkRpc2Nvbm5lY3RSCmRpc2Nvbm5lY3QSQgoHcmVmcmVzaBgMIAEoCzIoLmNlbnRyaW'
    'Z1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuUmVmcmVzaFIHcmVmcmVzaEoECAEQAkoECAMQBA==');

@$core.Deprecated('Use clientInfoDescriptor instead')
const ClientInfo$json = {
  '1': 'ClientInfo',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 9, '10': 'user'},
    {'1': 'client', '3': 2, '4': 1, '5': 9, '10': 'client'},
    {'1': 'conn_info', '3': 3, '4': 1, '5': 12, '10': 'connInfo'},
    {'1': 'chan_info', '3': 4, '4': 1, '5': 12, '10': 'chanInfo'},
  ],
};

/// Descriptor for `ClientInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientInfoDescriptor = $convert.base64Decode(
    'CgpDbGllbnRJbmZvEhIKBHVzZXIYASABKAlSBHVzZXISFgoGY2xpZW50GAIgASgJUgZjbGllbn'
    'QSGwoJY29ubl9pbmZvGAMgASgMUghjb25uSW5mbxIbCgljaGFuX2luZm8YBCABKAxSCGNoYW5J'
    'bmZv');

@$core.Deprecated('Use publicationDescriptor instead')
const Publication$json = {
  '1': 'Publication',
  '2': [
    {'1': 'data', '3': 4, '4': 1, '5': 12, '10': 'data'},
    {'1': 'info', '3': 5, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.ClientInfo', '10': 'info'},
    {'1': 'offset', '3': 6, '4': 1, '5': 4, '10': 'offset'},
    {'1': 'tags', '3': 7, '4': 3, '5': 11, '6': '.centrifugal.centrifuge.protocol.Publication.TagsEntry', '10': 'tags'},
    {'1': 'delta', '3': 8, '4': 1, '5': 8, '10': 'delta'},
    {'1': 'time', '3': 9, '4': 1, '5': 3, '10': 'time'},
    {'1': 'channel', '3': 10, '4': 1, '5': 9, '10': 'channel'},
  ],
  '3': [Publication_TagsEntry$json],
  '9': [
    {'1': 1, '2': 2},
    {'1': 2, '2': 3},
    {'1': 3, '2': 4},
  ],
};

@$core.Deprecated('Use publicationDescriptor instead')
const Publication_TagsEntry$json = {
  '1': 'TagsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Publication`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publicationDescriptor = $convert.base64Decode(
    'CgtQdWJsaWNhdGlvbhISCgRkYXRhGAQgASgMUgRkYXRhEj8KBGluZm8YBSABKAsyKy5jZW50cm'
    'lmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLkNsaWVudEluZm9SBGluZm8SFgoGb2Zmc2V0GAYg'
    'ASgEUgZvZmZzZXQSSgoEdGFncxgHIAMoCzI2LmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG'
    '9jb2wuUHVibGljYXRpb24uVGFnc0VudHJ5UgR0YWdzEhQKBWRlbHRhGAggASgIUgVkZWx0YRIS'
    'CgR0aW1lGAkgASgDUgR0aW1lEhgKB2NoYW5uZWwYCiABKAlSB2NoYW5uZWwaNwoJVGFnc0VudH'
    'J5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAFKBAgBEAJKBAgC'
    'EANKBAgDEAQ=');

@$core.Deprecated('Use joinDescriptor instead')
const Join$json = {
  '1': 'Join',
  '2': [
    {'1': 'info', '3': 1, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.ClientInfo', '10': 'info'},
  ],
};

/// Descriptor for `Join`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinDescriptor = $convert.base64Decode(
    'CgRKb2luEj8KBGluZm8YASABKAsyKy5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLk'
    'NsaWVudEluZm9SBGluZm8=');

@$core.Deprecated('Use leaveDescriptor instead')
const Leave$json = {
  '1': 'Leave',
  '2': [
    {'1': 'info', '3': 1, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.ClientInfo', '10': 'info'},
  ],
};

/// Descriptor for `Leave`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveDescriptor = $convert.base64Decode(
    'CgVMZWF2ZRI/CgRpbmZvGAEgASgLMisuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC'
    '5DbGllbnRJbmZvUgRpbmZv');

@$core.Deprecated('Use unsubscribeDescriptor instead')
const Unsubscribe$json = {
  '1': 'Unsubscribe',
  '2': [
    {'1': 'code', '3': 2, '4': 1, '5': 13, '10': 'code'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
  '9': [
    {'1': 1, '2': 2},
  ],
};

/// Descriptor for `Unsubscribe`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unsubscribeDescriptor = $convert.base64Decode(
    'CgtVbnN1YnNjcmliZRISCgRjb2RlGAIgASgNUgRjb2RlEhYKBnJlYXNvbhgDIAEoCVIGcmVhc2'
    '9uSgQIARAC');

@$core.Deprecated('Use subscribeDescriptor instead')
const Subscribe$json = {
  '1': 'Subscribe',
  '2': [
    {'1': 'recoverable', '3': 1, '4': 1, '5': 8, '10': 'recoverable'},
    {'1': 'epoch', '3': 4, '4': 1, '5': 9, '10': 'epoch'},
    {'1': 'offset', '3': 5, '4': 1, '5': 4, '10': 'offset'},
    {'1': 'positioned', '3': 6, '4': 1, '5': 8, '10': 'positioned'},
    {'1': 'data', '3': 7, '4': 1, '5': 12, '10': 'data'},
  ],
  '9': [
    {'1': 2, '2': 3},
    {'1': 3, '2': 4},
  ],
};

/// Descriptor for `Subscribe`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeDescriptor = $convert.base64Decode(
    'CglTdWJzY3JpYmUSIAoLcmVjb3ZlcmFibGUYASABKAhSC3JlY292ZXJhYmxlEhQKBWVwb2NoGA'
    'QgASgJUgVlcG9jaBIWCgZvZmZzZXQYBSABKARSBm9mZnNldBIeCgpwb3NpdGlvbmVkGAYgASgI'
    'Ugpwb3NpdGlvbmVkEhIKBGRhdGEYByABKAxSBGRhdGFKBAgCEANKBAgDEAQ=');

@$core.Deprecated('Use messageDescriptor instead')
const Message$json = {
  '1': 'Message',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode(
    'CgdNZXNzYWdlEhIKBGRhdGEYASABKAxSBGRhdGE=');

@$core.Deprecated('Use connectDescriptor instead')
const Connect$json = {
  '1': 'Connect',
  '2': [
    {'1': 'client', '3': 1, '4': 1, '5': 9, '10': 'client'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {'1': 'data', '3': 3, '4': 1, '5': 12, '10': 'data'},
    {'1': 'subs', '3': 4, '4': 3, '5': 11, '6': '.centrifugal.centrifuge.protocol.Connect.SubsEntry', '10': 'subs'},
    {'1': 'expires', '3': 5, '4': 1, '5': 8, '10': 'expires'},
    {'1': 'ttl', '3': 6, '4': 1, '5': 13, '10': 'ttl'},
    {'1': 'ping', '3': 7, '4': 1, '5': 13, '10': 'ping'},
    {'1': 'pong', '3': 8, '4': 1, '5': 8, '10': 'pong'},
    {'1': 'session', '3': 9, '4': 1, '5': 9, '10': 'session'},
    {'1': 'node', '3': 10, '4': 1, '5': 9, '10': 'node'},
    {'1': 'time', '3': 11, '4': 1, '5': 3, '10': 'time'},
  ],
  '3': [Connect_SubsEntry$json],
};

@$core.Deprecated('Use connectDescriptor instead')
const Connect_SubsEntry$json = {
  '1': 'SubsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.SubscribeResult', '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Connect`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectDescriptor = $convert.base64Decode(
    'CgdDb25uZWN0EhYKBmNsaWVudBgBIAEoCVIGY2xpZW50EhgKB3ZlcnNpb24YAiABKAlSB3Zlcn'
    'Npb24SEgoEZGF0YRgDIAEoDFIEZGF0YRJGCgRzdWJzGAQgAygLMjIuY2VudHJpZnVnYWwuY2Vu'
    'dHJpZnVnZS5wcm90b2NvbC5Db25uZWN0LlN1YnNFbnRyeVIEc3VicxIYCgdleHBpcmVzGAUgAS'
    'gIUgdleHBpcmVzEhAKA3R0bBgGIAEoDVIDdHRsEhIKBHBpbmcYByABKA1SBHBpbmcSEgoEcG9u'
    'ZxgIIAEoCFIEcG9uZxIYCgdzZXNzaW9uGAkgASgJUgdzZXNzaW9uEhIKBG5vZGUYCiABKAlSBG'
    '5vZGUSEgoEdGltZRgLIAEoA1IEdGltZRppCglTdWJzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkS'
    'RgoFdmFsdWUYAiABKAsyMC5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3RvY29sLlN1YnNjcm'
    'liZVJlc3VsdFIFdmFsdWU6AjgB');

@$core.Deprecated('Use disconnectDescriptor instead')
const Disconnect$json = {
  '1': 'Disconnect',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 13, '10': 'code'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'reconnect', '3': 3, '4': 1, '5': 8, '10': 'reconnect'},
  ],
};

/// Descriptor for `Disconnect`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disconnectDescriptor = $convert.base64Decode(
    'CgpEaXNjb25uZWN0EhIKBGNvZGUYASABKA1SBGNvZGUSFgoGcmVhc29uGAIgASgJUgZyZWFzb2'
    '4SHAoJcmVjb25uZWN0GAMgASgIUglyZWNvbm5lY3Q=');

@$core.Deprecated('Use refreshDescriptor instead')
const Refresh$json = {
  '1': 'Refresh',
  '2': [
    {'1': 'expires', '3': 1, '4': 1, '5': 8, '10': 'expires'},
    {'1': 'ttl', '3': 2, '4': 1, '5': 13, '10': 'ttl'},
  ],
};

/// Descriptor for `Refresh`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refreshDescriptor = $convert.base64Decode(
    'CgdSZWZyZXNoEhgKB2V4cGlyZXMYASABKAhSB2V4cGlyZXMSEAoDdHRsGAIgASgNUgN0dGw=');

@$core.Deprecated('Use connectRequestDescriptor instead')
const ConnectRequest$json = {
  '1': 'ConnectRequest',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
    {'1': 'subs', '3': 3, '4': 3, '5': 11, '6': '.centrifugal.centrifuge.protocol.ConnectRequest.SubsEntry', '10': 'subs'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'version', '3': 5, '4': 1, '5': 9, '10': 'version'},
    {'1': 'headers', '3': 6, '4': 3, '5': 11, '6': '.centrifugal.centrifuge.protocol.ConnectRequest.HeadersEntry', '10': 'headers'},
  ],
  '3': [ConnectRequest_SubsEntry$json, ConnectRequest_HeadersEntry$json],
};

@$core.Deprecated('Use connectRequestDescriptor instead')
const ConnectRequest_SubsEntry$json = {
  '1': 'SubsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.SubscribeRequest', '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use connectRequestDescriptor instead')
const ConnectRequest_HeadersEntry$json = {
  '1': 'HeadersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ConnectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectRequestDescriptor = $convert.base64Decode(
    'Cg5Db25uZWN0UmVxdWVzdBIUCgV0b2tlbhgBIAEoCVIFdG9rZW4SEgoEZGF0YRgCIAEoDFIEZG'
    'F0YRJNCgRzdWJzGAMgAygLMjkuY2VudHJpZnVnYWwuY2VudHJpZnVnZS5wcm90b2NvbC5Db25u'
    'ZWN0UmVxdWVzdC5TdWJzRW50cnlSBHN1YnMSEgoEbmFtZRgEIAEoCVIEbmFtZRIYCgd2ZXJzaW'
    '9uGAUgASgJUgd2ZXJzaW9uElYKB2hlYWRlcnMYBiADKAsyPC5jZW50cmlmdWdhbC5jZW50cmlm'
    'dWdlLnByb3RvY29sLkNvbm5lY3RSZXF1ZXN0LkhlYWRlcnNFbnRyeVIHaGVhZGVycxpqCglTdW'
    'JzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSRwoFdmFsdWUYAiABKAsyMS5jZW50cmlmdWdhbC5j'
    'ZW50cmlmdWdlLnByb3RvY29sLlN1YnNjcmliZVJlcXVlc3RSBXZhbHVlOgI4ARo6CgxIZWFkZX'
    'JzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use connectResultDescriptor instead')
const ConnectResult$json = {
  '1': 'ConnectResult',
  '2': [
    {'1': 'client', '3': 1, '4': 1, '5': 9, '10': 'client'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {'1': 'expires', '3': 3, '4': 1, '5': 8, '10': 'expires'},
    {'1': 'ttl', '3': 4, '4': 1, '5': 13, '10': 'ttl'},
    {'1': 'data', '3': 5, '4': 1, '5': 12, '10': 'data'},
    {'1': 'subs', '3': 6, '4': 3, '5': 11, '6': '.centrifugal.centrifuge.protocol.ConnectResult.SubsEntry', '10': 'subs'},
    {'1': 'ping', '3': 7, '4': 1, '5': 13, '10': 'ping'},
    {'1': 'pong', '3': 8, '4': 1, '5': 8, '10': 'pong'},
    {'1': 'session', '3': 9, '4': 1, '5': 9, '10': 'session'},
    {'1': 'node', '3': 10, '4': 1, '5': 9, '10': 'node'},
    {'1': 'time', '3': 11, '4': 1, '5': 3, '10': 'time'},
  ],
  '3': [ConnectResult_SubsEntry$json],
};

@$core.Deprecated('Use connectResultDescriptor instead')
const ConnectResult_SubsEntry$json = {
  '1': 'SubsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.SubscribeResult', '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ConnectResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectResultDescriptor = $convert.base64Decode(
    'Cg1Db25uZWN0UmVzdWx0EhYKBmNsaWVudBgBIAEoCVIGY2xpZW50EhgKB3ZlcnNpb24YAiABKA'
    'lSB3ZlcnNpb24SGAoHZXhwaXJlcxgDIAEoCFIHZXhwaXJlcxIQCgN0dGwYBCABKA1SA3R0bBIS'
    'CgRkYXRhGAUgASgMUgRkYXRhEkwKBHN1YnMYBiADKAsyOC5jZW50cmlmdWdhbC5jZW50cmlmdW'
    'dlLnByb3RvY29sLkNvbm5lY3RSZXN1bHQuU3Vic0VudHJ5UgRzdWJzEhIKBHBpbmcYByABKA1S'
    'BHBpbmcSEgoEcG9uZxgIIAEoCFIEcG9uZxIYCgdzZXNzaW9uGAkgASgJUgdzZXNzaW9uEhIKBG'
    '5vZGUYCiABKAlSBG5vZGUSEgoEdGltZRgLIAEoA1IEdGltZRppCglTdWJzRW50cnkSEAoDa2V5'
    'GAEgASgJUgNrZXkSRgoFdmFsdWUYAiABKAsyMC5jZW50cmlmdWdhbC5jZW50cmlmdWdlLnByb3'
    'RvY29sLlN1YnNjcmliZVJlc3VsdFIFdmFsdWU6AjgB');

@$core.Deprecated('Use refreshRequestDescriptor instead')
const RefreshRequest$json = {
  '1': 'RefreshRequest',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `RefreshRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refreshRequestDescriptor = $convert.base64Decode(
    'Cg5SZWZyZXNoUmVxdWVzdBIUCgV0b2tlbhgBIAEoCVIFdG9rZW4=');

@$core.Deprecated('Use refreshResultDescriptor instead')
const RefreshResult$json = {
  '1': 'RefreshResult',
  '2': [
    {'1': 'client', '3': 1, '4': 1, '5': 9, '10': 'client'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {'1': 'expires', '3': 3, '4': 1, '5': 8, '10': 'expires'},
    {'1': 'ttl', '3': 4, '4': 1, '5': 13, '10': 'ttl'},
  ],
};

/// Descriptor for `RefreshResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refreshResultDescriptor = $convert.base64Decode(
    'Cg1SZWZyZXNoUmVzdWx0EhYKBmNsaWVudBgBIAEoCVIGY2xpZW50EhgKB3ZlcnNpb24YAiABKA'
    'lSB3ZlcnNpb24SGAoHZXhwaXJlcxgDIAEoCFIHZXhwaXJlcxIQCgN0dGwYBCABKA1SA3R0bA==');

@$core.Deprecated('Use subscribeRequestDescriptor instead')
const SubscribeRequest$json = {
  '1': 'SubscribeRequest',
  '2': [
    {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    {'1': 'recover', '3': 3, '4': 1, '5': 8, '10': 'recover'},
    {'1': 'epoch', '3': 6, '4': 1, '5': 9, '10': 'epoch'},
    {'1': 'offset', '3': 7, '4': 1, '5': 4, '10': 'offset'},
    {'1': 'data', '3': 8, '4': 1, '5': 12, '10': 'data'},
    {'1': 'positioned', '3': 9, '4': 1, '5': 8, '10': 'positioned'},
    {'1': 'recoverable', '3': 10, '4': 1, '5': 8, '10': 'recoverable'},
    {'1': 'join_leave', '3': 11, '4': 1, '5': 8, '10': 'joinLeave'},
    {'1': 'delta', '3': 12, '4': 1, '5': 9, '10': 'delta'},
  ],
  '9': [
    {'1': 4, '2': 5},
    {'1': 5, '2': 6},
  ],
};

/// Descriptor for `SubscribeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeRequestDescriptor = $convert.base64Decode(
    'ChBTdWJzY3JpYmVSZXF1ZXN0EhgKB2NoYW5uZWwYASABKAlSB2NoYW5uZWwSFAoFdG9rZW4YAi'
    'ABKAlSBXRva2VuEhgKB3JlY292ZXIYAyABKAhSB3JlY292ZXISFAoFZXBvY2gYBiABKAlSBWVw'
    'b2NoEhYKBm9mZnNldBgHIAEoBFIGb2Zmc2V0EhIKBGRhdGEYCCABKAxSBGRhdGESHgoKcG9zaX'
    'Rpb25lZBgJIAEoCFIKcG9zaXRpb25lZBIgCgtyZWNvdmVyYWJsZRgKIAEoCFILcmVjb3ZlcmFi'
    'bGUSHQoKam9pbl9sZWF2ZRgLIAEoCFIJam9pbkxlYXZlEhQKBWRlbHRhGAwgASgJUgVkZWx0YU'
    'oECAQQBUoECAUQBg==');

@$core.Deprecated('Use subscribeResultDescriptor instead')
const SubscribeResult$json = {
  '1': 'SubscribeResult',
  '2': [
    {'1': 'expires', '3': 1, '4': 1, '5': 8, '10': 'expires'},
    {'1': 'ttl', '3': 2, '4': 1, '5': 13, '10': 'ttl'},
    {'1': 'recoverable', '3': 3, '4': 1, '5': 8, '10': 'recoverable'},
    {'1': 'epoch', '3': 6, '4': 1, '5': 9, '10': 'epoch'},
    {'1': 'publications', '3': 7, '4': 3, '5': 11, '6': '.centrifugal.centrifuge.protocol.Publication', '10': 'publications'},
    {'1': 'recovered', '3': 8, '4': 1, '5': 8, '10': 'recovered'},
    {'1': 'offset', '3': 9, '4': 1, '5': 4, '10': 'offset'},
    {'1': 'positioned', '3': 10, '4': 1, '5': 8, '10': 'positioned'},
    {'1': 'data', '3': 11, '4': 1, '5': 12, '10': 'data'},
    {'1': 'was_recovering', '3': 12, '4': 1, '5': 8, '10': 'wasRecovering'},
    {'1': 'delta', '3': 13, '4': 1, '5': 8, '10': 'delta'},
  ],
  '9': [
    {'1': 4, '2': 5},
    {'1': 5, '2': 6},
  ],
};

/// Descriptor for `SubscribeResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeResultDescriptor = $convert.base64Decode(
    'Cg9TdWJzY3JpYmVSZXN1bHQSGAoHZXhwaXJlcxgBIAEoCFIHZXhwaXJlcxIQCgN0dGwYAiABKA'
    '1SA3R0bBIgCgtyZWNvdmVyYWJsZRgDIAEoCFILcmVjb3ZlcmFibGUSFAoFZXBvY2gYBiABKAlS'
    'BWVwb2NoElAKDHB1YmxpY2F0aW9ucxgHIAMoCzIsLmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucH'
    'JvdG9jb2wuUHVibGljYXRpb25SDHB1YmxpY2F0aW9ucxIcCglyZWNvdmVyZWQYCCABKAhSCXJl'
    'Y292ZXJlZBIWCgZvZmZzZXQYCSABKARSBm9mZnNldBIeCgpwb3NpdGlvbmVkGAogASgIUgpwb3'
    'NpdGlvbmVkEhIKBGRhdGEYCyABKAxSBGRhdGESJQoOd2FzX3JlY292ZXJpbmcYDCABKAhSDXdh'
    'c1JlY292ZXJpbmcSFAoFZGVsdGEYDSABKAhSBWRlbHRhSgQIBBAFSgQIBRAG');

@$core.Deprecated('Use subRefreshRequestDescriptor instead')
const SubRefreshRequest$json = {
  '1': 'SubRefreshRequest',
  '2': [
    {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `SubRefreshRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subRefreshRequestDescriptor = $convert.base64Decode(
    'ChFTdWJSZWZyZXNoUmVxdWVzdBIYCgdjaGFubmVsGAEgASgJUgdjaGFubmVsEhQKBXRva2VuGA'
    'IgASgJUgV0b2tlbg==');

@$core.Deprecated('Use subRefreshResultDescriptor instead')
const SubRefreshResult$json = {
  '1': 'SubRefreshResult',
  '2': [
    {'1': 'expires', '3': 1, '4': 1, '5': 8, '10': 'expires'},
    {'1': 'ttl', '3': 2, '4': 1, '5': 13, '10': 'ttl'},
  ],
};

/// Descriptor for `SubRefreshResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subRefreshResultDescriptor = $convert.base64Decode(
    'ChBTdWJSZWZyZXNoUmVzdWx0EhgKB2V4cGlyZXMYASABKAhSB2V4cGlyZXMSEAoDdHRsGAIgAS'
    'gNUgN0dGw=');

@$core.Deprecated('Use unsubscribeRequestDescriptor instead')
const UnsubscribeRequest$json = {
  '1': 'UnsubscribeRequest',
  '2': [
    {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
  ],
};

/// Descriptor for `UnsubscribeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unsubscribeRequestDescriptor = $convert.base64Decode(
    'ChJVbnN1YnNjcmliZVJlcXVlc3QSGAoHY2hhbm5lbBgBIAEoCVIHY2hhbm5lbA==');

@$core.Deprecated('Use unsubscribeResultDescriptor instead')
const UnsubscribeResult$json = {
  '1': 'UnsubscribeResult',
};

/// Descriptor for `UnsubscribeResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unsubscribeResultDescriptor = $convert.base64Decode(
    'ChFVbnN1YnNjcmliZVJlc3VsdA==');

@$core.Deprecated('Use publishRequestDescriptor instead')
const PublishRequest$json = {
  '1': 'PublishRequest',
  '2': [
    {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
    {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `PublishRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishRequestDescriptor = $convert.base64Decode(
    'Cg5QdWJsaXNoUmVxdWVzdBIYCgdjaGFubmVsGAEgASgJUgdjaGFubmVsEhIKBGRhdGEYAiABKA'
    'xSBGRhdGE=');

@$core.Deprecated('Use publishResultDescriptor instead')
const PublishResult$json = {
  '1': 'PublishResult',
};

/// Descriptor for `PublishResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishResultDescriptor = $convert.base64Decode(
    'Cg1QdWJsaXNoUmVzdWx0');

@$core.Deprecated('Use presenceRequestDescriptor instead')
const PresenceRequest$json = {
  '1': 'PresenceRequest',
  '2': [
    {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
  ],
};

/// Descriptor for `PresenceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List presenceRequestDescriptor = $convert.base64Decode(
    'Cg9QcmVzZW5jZVJlcXVlc3QSGAoHY2hhbm5lbBgBIAEoCVIHY2hhbm5lbA==');

@$core.Deprecated('Use presenceResultDescriptor instead')
const PresenceResult$json = {
  '1': 'PresenceResult',
  '2': [
    {'1': 'presence', '3': 1, '4': 3, '5': 11, '6': '.centrifugal.centrifuge.protocol.PresenceResult.PresenceEntry', '10': 'presence'},
  ],
  '3': [PresenceResult_PresenceEntry$json],
};

@$core.Deprecated('Use presenceResultDescriptor instead')
const PresenceResult_PresenceEntry$json = {
  '1': 'PresenceEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.ClientInfo', '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `PresenceResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List presenceResultDescriptor = $convert.base64Decode(
    'Cg5QcmVzZW5jZVJlc3VsdBJZCghwcmVzZW5jZRgBIAMoCzI9LmNlbnRyaWZ1Z2FsLmNlbnRyaW'
    'Z1Z2UucHJvdG9jb2wuUHJlc2VuY2VSZXN1bHQuUHJlc2VuY2VFbnRyeVIIcHJlc2VuY2UaaAoN'
    'UHJlc2VuY2VFbnRyeRIQCgNrZXkYASABKAlSA2tleRJBCgV2YWx1ZRgCIAEoCzIrLmNlbnRyaW'
    'Z1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9jb2wuQ2xpZW50SW5mb1IFdmFsdWU6AjgB');

@$core.Deprecated('Use presenceStatsRequestDescriptor instead')
const PresenceStatsRequest$json = {
  '1': 'PresenceStatsRequest',
  '2': [
    {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
  ],
};

/// Descriptor for `PresenceStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List presenceStatsRequestDescriptor = $convert.base64Decode(
    'ChRQcmVzZW5jZVN0YXRzUmVxdWVzdBIYCgdjaGFubmVsGAEgASgJUgdjaGFubmVs');

@$core.Deprecated('Use presenceStatsResultDescriptor instead')
const PresenceStatsResult$json = {
  '1': 'PresenceStatsResult',
  '2': [
    {'1': 'num_clients', '3': 1, '4': 1, '5': 13, '10': 'numClients'},
    {'1': 'num_users', '3': 2, '4': 1, '5': 13, '10': 'numUsers'},
  ],
};

/// Descriptor for `PresenceStatsResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List presenceStatsResultDescriptor = $convert.base64Decode(
    'ChNQcmVzZW5jZVN0YXRzUmVzdWx0Eh8KC251bV9jbGllbnRzGAEgASgNUgpudW1DbGllbnRzEh'
    'sKCW51bV91c2VycxgCIAEoDVIIbnVtVXNlcnM=');

@$core.Deprecated('Use streamPositionDescriptor instead')
const StreamPosition$json = {
  '1': 'StreamPosition',
  '2': [
    {'1': 'offset', '3': 1, '4': 1, '5': 4, '10': 'offset'},
    {'1': 'epoch', '3': 2, '4': 1, '5': 9, '10': 'epoch'},
  ],
};

/// Descriptor for `StreamPosition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamPositionDescriptor = $convert.base64Decode(
    'Cg5TdHJlYW1Qb3NpdGlvbhIWCgZvZmZzZXQYASABKARSBm9mZnNldBIUCgVlcG9jaBgCIAEoCV'
    'IFZXBvY2g=');

@$core.Deprecated('Use historyRequestDescriptor instead')
const HistoryRequest$json = {
  '1': 'HistoryRequest',
  '2': [
    {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
    {'1': 'limit', '3': 7, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'since', '3': 8, '4': 1, '5': 11, '6': '.centrifugal.centrifuge.protocol.StreamPosition', '10': 'since'},
    {'1': 'reverse', '3': 9, '4': 1, '5': 8, '10': 'reverse'},
  ],
  '9': [
    {'1': 2, '2': 3},
    {'1': 3, '2': 4},
    {'1': 4, '2': 5},
    {'1': 5, '2': 6},
    {'1': 6, '2': 7},
  ],
};

/// Descriptor for `HistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List historyRequestDescriptor = $convert.base64Decode(
    'Cg5IaXN0b3J5UmVxdWVzdBIYCgdjaGFubmVsGAEgASgJUgdjaGFubmVsEhQKBWxpbWl0GAcgAS'
    'gFUgVsaW1pdBJFCgVzaW5jZRgIIAEoCzIvLmNlbnRyaWZ1Z2FsLmNlbnRyaWZ1Z2UucHJvdG9j'
    'b2wuU3RyZWFtUG9zaXRpb25SBXNpbmNlEhgKB3JldmVyc2UYCSABKAhSB3JldmVyc2VKBAgCEA'
    'NKBAgDEARKBAgEEAVKBAgFEAZKBAgGEAc=');

@$core.Deprecated('Use historyResultDescriptor instead')
const HistoryResult$json = {
  '1': 'HistoryResult',
  '2': [
    {'1': 'publications', '3': 1, '4': 3, '5': 11, '6': '.centrifugal.centrifuge.protocol.Publication', '10': 'publications'},
    {'1': 'epoch', '3': 2, '4': 1, '5': 9, '10': 'epoch'},
    {'1': 'offset', '3': 3, '4': 1, '5': 4, '10': 'offset'},
  ],
};

/// Descriptor for `HistoryResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List historyResultDescriptor = $convert.base64Decode(
    'Cg1IaXN0b3J5UmVzdWx0ElAKDHB1YmxpY2F0aW9ucxgBIAMoCzIsLmNlbnRyaWZ1Z2FsLmNlbn'
    'RyaWZ1Z2UucHJvdG9jb2wuUHVibGljYXRpb25SDHB1YmxpY2F0aW9ucxIUCgVlcG9jaBgCIAEo'
    'CVIFZXBvY2gSFgoGb2Zmc2V0GAMgASgEUgZvZmZzZXQ=');

@$core.Deprecated('Use pingRequestDescriptor instead')
const PingRequest$json = {
  '1': 'PingRequest',
};

/// Descriptor for `PingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingRequestDescriptor = $convert.base64Decode(
    'CgtQaW5nUmVxdWVzdA==');

@$core.Deprecated('Use pingResultDescriptor instead')
const PingResult$json = {
  '1': 'PingResult',
};

/// Descriptor for `PingResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingResultDescriptor = $convert.base64Decode(
    'CgpQaW5nUmVzdWx0');

@$core.Deprecated('Use rPCRequestDescriptor instead')
const RPCRequest$json = {
  '1': 'RPCRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
    {'1': 'method', '3': 2, '4': 1, '5': 9, '10': 'method'},
  ],
};

/// Descriptor for `RPCRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rPCRequestDescriptor = $convert.base64Decode(
    'CgpSUENSZXF1ZXN0EhIKBGRhdGEYASABKAxSBGRhdGESFgoGbWV0aG9kGAIgASgJUgZtZXRob2'
    'Q=');

@$core.Deprecated('Use rPCResultDescriptor instead')
const RPCResult$json = {
  '1': 'RPCResult',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `RPCResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rPCResultDescriptor = $convert.base64Decode(
    'CglSUENSZXN1bHQSEgoEZGF0YRgBIAEoDFIEZGF0YQ==');

@$core.Deprecated('Use sendRequestDescriptor instead')
const SendRequest$json = {
  '1': 'SendRequest',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `SendRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendRequestDescriptor = $convert.base64Decode(
    'CgtTZW5kUmVxdWVzdBISCgRkYXRhGAEgASgMUgRkYXRh');

