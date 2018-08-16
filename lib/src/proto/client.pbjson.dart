///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes

const MethodType$json = const {
  '1': 'MethodType',
  '2': const [
    const {'1': 'CONNECT', '2': 0, '3': const {}},
    const {'1': 'SUBSCRIBE', '2': 1, '3': const {}},
    const {'1': 'UNSUBSCRIBE', '2': 2, '3': const {}},
    const {'1': 'PUBLISH', '2': 3, '3': const {}},
    const {'1': 'PRESENCE', '2': 4, '3': const {}},
    const {'1': 'PRESENCE_STATS', '2': 5, '3': const {}},
    const {'1': 'HISTORY', '2': 6, '3': const {}},
    const {'1': 'PING', '2': 7, '3': const {}},
    const {'1': 'SEND', '2': 8, '3': const {}},
    const {'1': 'RPC', '2': 9, '3': const {}},
    const {'1': 'REFRESH', '2': 10, '3': const {}},
    const {'1': 'SUB_REFRESH', '2': 11, '3': const {}},
  ],
  '3': const {},
};

const PushType$json = const {
  '1': 'PushType',
  '2': const [
    const {'1': 'PUBLICATION', '2': 0, '3': const {}},
    const {'1': 'JOIN', '2': 1, '3': const {}},
    const {'1': 'LEAVE', '2': 2, '3': const {}},
    const {'1': 'UNSUB', '2': 3, '3': const {}},
    const {'1': 'MESSAGE', '2': 4, '3': const {}},
  ],
  '3': const {},
};

const Error$json = const {
  '1': 'Error',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 13, '8': const {}, '10': 'code'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'message'},
  ],
};

const Command$json = const {
  '1': 'Command',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 13, '8': const {}, '10': 'id'},
    const {'1': 'method', '3': 2, '4': 1, '5': 14, '6': '.proto.MethodType', '8': const {}, '10': 'method'},
    const {'1': 'params', '3': 3, '4': 1, '5': 12, '8': const {}, '10': 'params'},
  ],
};

const Reply$json = const {
  '1': 'Reply',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 13, '8': const {}, '10': 'id'},
    const {'1': 'error', '3': 2, '4': 1, '5': 11, '6': '.proto.Error', '8': const {}, '10': 'error'},
    const {'1': 'result', '3': 3, '4': 1, '5': 12, '8': const {}, '10': 'result'},
  ],
};

const Push$json = const {
  '1': 'Push',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.proto.PushType', '8': const {}, '10': 'type'},
    const {'1': 'channel', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'channel'},
    const {'1': 'data', '3': 3, '4': 1, '5': 12, '8': const {}, '10': 'data'},
  ],
};

const ClientInfo$json = const {
  '1': 'ClientInfo',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'user'},
    const {'1': 'client', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'client'},
    const {'1': 'conn_info', '3': 3, '4': 1, '5': 12, '8': const {}, '10': 'connInfo'},
    const {'1': 'chan_info', '3': 4, '4': 1, '5': 12, '8': const {}, '10': 'chanInfo'},
  ],
};

const Publication$json = const {
  '1': 'Publication',
  '2': const [
    const {'1': 'uid', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'uid'},
    const {'1': 'data', '3': 2, '4': 1, '5': 12, '8': const {}, '10': 'data'},
    const {'1': 'info', '3': 3, '4': 1, '5': 11, '6': '.proto.ClientInfo', '8': const {}, '10': 'info'},
  ],
};

const Join$json = const {
  '1': 'Join',
  '2': const [
    const {'1': 'info', '3': 1, '4': 1, '5': 11, '6': '.proto.ClientInfo', '8': const {}, '10': 'info'},
  ],
};

const Leave$json = const {
  '1': 'Leave',
  '2': const [
    const {'1': 'info', '3': 1, '4': 1, '5': 11, '6': '.proto.ClientInfo', '8': const {}, '10': 'info'},
  ],
};

const Unsub$json = const {
  '1': 'Unsub',
  '2': const [
    const {'1': 'resubscribe', '3': 1, '4': 1, '5': 8, '8': const {}, '10': 'resubscribe'},
  ],
};

const Message$json = const {
  '1': 'Message',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 12, '8': const {}, '10': 'data'},
  ],
};

const ConnectRequest$json = const {
  '1': 'ConnectRequest',
  '2': const [
    const {'1': 'token', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'token'},
    const {'1': 'data', '3': 2, '4': 1, '5': 12, '8': const {}, '10': 'data'},
  ],
};

const ConnectResult$json = const {
  '1': 'ConnectResult',
  '2': const [
    const {'1': 'client', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'client'},
    const {'1': 'version', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'version'},
    const {'1': 'expires', '3': 3, '4': 1, '5': 8, '8': const {}, '10': 'expires'},
    const {'1': 'ttl', '3': 4, '4': 1, '5': 13, '8': const {}, '10': 'ttl'},
    const {'1': 'data', '3': 5, '4': 1, '5': 12, '8': const {}, '10': 'data'},
  ],
};

const RefreshRequest$json = const {
  '1': 'RefreshRequest',
  '2': const [
    const {'1': 'token', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'token'},
  ],
};

const RefreshResult$json = const {
  '1': 'RefreshResult',
  '2': const [
    const {'1': 'client', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'client'},
    const {'1': 'version', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'version'},
    const {'1': 'expires', '3': 3, '4': 1, '5': 8, '8': const {}, '10': 'expires'},
    const {'1': 'ttl', '3': 4, '4': 1, '5': 13, '8': const {}, '10': 'ttl'},
  ],
};

const SubscribeRequest$json = const {
  '1': 'SubscribeRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'channel'},
    const {'1': 'recover', '3': 2, '4': 1, '5': 8, '8': const {}, '10': 'recover'},
    const {'1': 'last', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'last'},
    const {'1': 'away', '3': 4, '4': 1, '5': 13, '8': const {}, '10': 'away'},
    const {'1': 'token', '3': 5, '4': 1, '5': 9, '8': const {}, '10': 'token'},
  ],
};

const SubscribeResult$json = const {
  '1': 'SubscribeResult',
  '2': const [
    const {'1': 'last', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'last'},
    const {'1': 'recovered', '3': 2, '4': 1, '5': 8, '8': const {}, '10': 'recovered'},
    const {'1': 'publications', '3': 3, '4': 3, '5': 11, '6': '.proto.Publication', '8': const {}, '10': 'publications'},
    const {'1': 'expires', '3': 4, '4': 1, '5': 8, '8': const {}, '10': 'expires'},
    const {'1': 'ttl', '3': 5, '4': 1, '5': 13, '8': const {}, '10': 'ttl'},
  ],
};

const SubRefreshRequest$json = const {
  '1': 'SubRefreshRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'channel'},
    const {'1': 'token', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'token'},
  ],
};

const SubRefreshResult$json = const {
  '1': 'SubRefreshResult',
  '2': const [
    const {'1': 'expires', '3': 1, '4': 1, '5': 8, '8': const {}, '10': 'expires'},
    const {'1': 'ttl', '3': 2, '4': 1, '5': 13, '8': const {}, '10': 'ttl'},
  ],
};

const UnsubscribeRequest$json = const {
  '1': 'UnsubscribeRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'channel'},
  ],
};

const UnsubscribeResult$json = const {
  '1': 'UnsubscribeResult',
};

const PublishRequest$json = const {
  '1': 'PublishRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'channel'},
    const {'1': 'data', '3': 2, '4': 1, '5': 12, '8': const {}, '10': 'data'},
  ],
};

const PublishResult$json = const {
  '1': 'PublishResult',
};

const PresenceRequest$json = const {
  '1': 'PresenceRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'channel'},
  ],
};

const PresenceResult$json = const {
  '1': 'PresenceResult',
  '2': const [
    const {'1': 'presence', '3': 1, '4': 3, '5': 11, '6': '.proto.PresenceResult.PresenceEntry', '8': const {}, '10': 'presence'},
  ],
  '3': const [PresenceResult_PresenceEntry$json],
};

const PresenceResult_PresenceEntry$json = const {
  '1': 'PresenceEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.proto.ClientInfo', '10': 'value'},
  ],
  '7': const {'7': true},
};

const PresenceStatsRequest$json = const {
  '1': 'PresenceStatsRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'channel'},
  ],
};

const PresenceStatsResult$json = const {
  '1': 'PresenceStatsResult',
  '2': const [
    const {'1': 'num_clients', '3': 1, '4': 1, '5': 13, '8': const {}, '10': 'numClients'},
    const {'1': 'num_users', '3': 2, '4': 1, '5': 13, '8': const {}, '10': 'numUsers'},
  ],
};

const HistoryRequest$json = const {
  '1': 'HistoryRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'channel'},
  ],
};

const HistoryResult$json = const {
  '1': 'HistoryResult',
  '2': const [
    const {'1': 'publications', '3': 1, '4': 3, '5': 11, '6': '.proto.Publication', '8': const {}, '10': 'publications'},
  ],
};

const PingRequest$json = const {
  '1': 'PingRequest',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'data'},
  ],
};

const PingResult$json = const {
  '1': 'PingResult',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'data'},
  ],
};

const RPCRequest$json = const {
  '1': 'RPCRequest',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 12, '8': const {}, '10': 'data'},
  ],
};

const RPCResult$json = const {
  '1': 'RPCResult',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 12, '8': const {}, '10': 'data'},
  ],
};

const SendRequest$json = const {
  '1': 'SendRequest',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 12, '8': const {}, '10': 'data'},
  ],
};

