///
//  Generated code. Do not modify.
//  source: client.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const MethodType$json = const {
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

const PushType$json = const {
  '1': 'PushType',
  '2': const [
    const {'1': 'PUBLICATION', '2': 0},
    const {'1': 'JOIN', '2': 1},
    const {'1': 'LEAVE', '2': 2},
    const {'1': 'UNSUB', '2': 3},
    const {'1': 'MESSAGE', '2': 4},
    const {'1': 'SUB', '2': 5},
  ],
};

const Error$json = const {
  '1': 'Error',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 13, '10': 'code'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

const Command$json = const {
  '1': 'Command',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    const {
      '1': 'method',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.protocol.MethodType',
      '10': 'method'
    },
    const {'1': 'params', '3': 3, '4': 1, '5': 12, '10': 'params'},
  ],
};

const Reply$json = const {
  '1': 'Reply',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    const {
      '1': 'error',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.protocol.Error',
      '10': 'error'
    },
    const {'1': 'result', '3': 3, '4': 1, '5': 12, '10': 'result'},
  ],
};

const Push$json = const {
  '1': 'Push',
  '2': const [
    const {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.protocol.PushType',
      '10': 'type'
    },
    const {'1': 'channel', '3': 2, '4': 1, '5': 9, '10': 'channel'},
    const {'1': 'data', '3': 3, '4': 1, '5': 12, '10': 'data'},
  ],
};

const ClientInfo$json = const {
  '1': 'ClientInfo',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 9, '10': 'user'},
    const {'1': 'client', '3': 2, '4': 1, '5': 9, '10': 'client'},
    const {'1': 'conn_info', '3': 3, '4': 1, '5': 12, '10': 'connInfo'},
    const {'1': 'chan_info', '3': 4, '4': 1, '5': 12, '10': 'chanInfo'},
  ],
};

const Publication$json = const {
  '1': 'Publication',
  '2': const [
    const {'1': 'seq', '3': 1, '4': 1, '5': 13, '10': 'seq'},
    const {'1': 'gen', '3': 2, '4': 1, '5': 13, '10': 'gen'},
    const {'1': 'uid', '3': 3, '4': 1, '5': 9, '10': 'uid'},
    const {'1': 'data', '3': 4, '4': 1, '5': 12, '10': 'data'},
    const {
      '1': 'info',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.protocol.ClientInfo',
      '10': 'info'
    },
    const {'1': 'offset', '3': 6, '4': 1, '5': 4, '10': 'offset'},
  ],
};

const Join$json = const {
  '1': 'Join',
  '2': const [
    const {
      '1': 'info',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.protocol.ClientInfo',
      '10': 'info'
    },
  ],
};

const Leave$json = const {
  '1': 'Leave',
  '2': const [
    const {
      '1': 'info',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.protocol.ClientInfo',
      '10': 'info'
    },
  ],
};

const Unsub$json = const {
  '1': 'Unsub',
  '2': const [
    const {'1': 'resubscribe', '3': 1, '4': 1, '5': 8, '10': 'resubscribe'},
  ],
};

const Sub$json = const {
  '1': 'Sub',
  '2': const [
    const {'1': 'recoverable', '3': 1, '4': 1, '5': 8, '10': 'recoverable'},
    const {'1': 'seq', '3': 2, '4': 1, '5': 13, '10': 'seq'},
    const {'1': 'gen', '3': 3, '4': 1, '5': 13, '10': 'gen'},
    const {'1': 'epoch', '3': 4, '4': 1, '5': 9, '10': 'epoch'},
    const {'1': 'offset', '3': 5, '4': 1, '5': 4, '10': 'offset'},
  ],
};

const Message$json = const {
  '1': 'Message',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
  ],
};

const ConnectRequest$json = const {
  '1': 'ConnectRequest',
  '2': const [
    const {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    const {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
    const {
      '1': 'subs',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.protocol.ConnectRequest.SubsEntry',
      '10': 'subs'
    },
  ],
  '3': const [ConnectRequest_SubsEntry$json],
};

const ConnectRequest_SubsEntry$json = const {
  '1': 'SubsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.protocol.SubscribeRequest',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

const ConnectResult$json = const {
  '1': 'ConnectResult',
  '2': const [
    const {'1': 'client', '3': 1, '4': 1, '5': 9, '10': 'client'},
    const {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'expires', '3': 3, '4': 1, '5': 8, '10': 'expires'},
    const {'1': 'ttl', '3': 4, '4': 1, '5': 13, '10': 'ttl'},
    const {'1': 'data', '3': 5, '4': 1, '5': 12, '10': 'data'},
    const {
      '1': 'subs',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.protocol.ConnectResult.SubsEntry',
      '10': 'subs'
    },
  ],
  '3': const [ConnectResult_SubsEntry$json],
};

const ConnectResult_SubsEntry$json = const {
  '1': 'SubsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.protocol.SubscribeResult',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

const RefreshRequest$json = const {
  '1': 'RefreshRequest',
  '2': const [
    const {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
  ],
};

const RefreshResult$json = const {
  '1': 'RefreshResult',
  '2': const [
    const {'1': 'client', '3': 1, '4': 1, '5': 9, '10': 'client'},
    const {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'expires', '3': 3, '4': 1, '5': 8, '10': 'expires'},
    const {'1': 'ttl', '3': 4, '4': 1, '5': 13, '10': 'ttl'},
  ],
};

const SubscribeRequest$json = const {
  '1': 'SubscribeRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
    const {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    const {'1': 'recover', '3': 3, '4': 1, '5': 8, '10': 'recover'},
    const {'1': 'seq', '3': 4, '4': 1, '5': 13, '10': 'seq'},
    const {'1': 'gen', '3': 5, '4': 1, '5': 13, '10': 'gen'},
    const {'1': 'epoch', '3': 6, '4': 1, '5': 9, '10': 'epoch'},
    const {'1': 'offset', '3': 7, '4': 1, '5': 4, '10': 'offset'},
  ],
};

const SubscribeResult$json = const {
  '1': 'SubscribeResult',
  '2': const [
    const {'1': 'expires', '3': 1, '4': 1, '5': 8, '10': 'expires'},
    const {'1': 'ttl', '3': 2, '4': 1, '5': 13, '10': 'ttl'},
    const {'1': 'recoverable', '3': 3, '4': 1, '5': 8, '10': 'recoverable'},
    const {'1': 'seq', '3': 4, '4': 1, '5': 13, '10': 'seq'},
    const {'1': 'gen', '3': 5, '4': 1, '5': 13, '10': 'gen'},
    const {'1': 'epoch', '3': 6, '4': 1, '5': 9, '10': 'epoch'},
    const {
      '1': 'publications',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.protocol.Publication',
      '10': 'publications'
    },
    const {'1': 'recovered', '3': 8, '4': 1, '5': 8, '10': 'recovered'},
    const {'1': 'offset', '3': 9, '4': 1, '5': 4, '10': 'offset'},
  ],
};

const SubRefreshRequest$json = const {
  '1': 'SubRefreshRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
    const {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

const SubRefreshResult$json = const {
  '1': 'SubRefreshResult',
  '2': const [
    const {'1': 'expires', '3': 1, '4': 1, '5': 8, '10': 'expires'},
    const {'1': 'ttl', '3': 2, '4': 1, '5': 13, '10': 'ttl'},
  ],
};

const UnsubscribeRequest$json = const {
  '1': 'UnsubscribeRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
  ],
};

const UnsubscribeResult$json = const {
  '1': 'UnsubscribeResult',
};

const PublishRequest$json = const {
  '1': 'PublishRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
    const {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
  ],
};

const PublishResult$json = const {
  '1': 'PublishResult',
};

const PresenceRequest$json = const {
  '1': 'PresenceRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
  ],
};

const PresenceResult$json = const {
  '1': 'PresenceResult',
  '2': const [
    const {
      '1': 'presence',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.protocol.PresenceResult.PresenceEntry',
      '10': 'presence'
    },
  ],
  '3': const [PresenceResult_PresenceEntry$json],
};

const PresenceResult_PresenceEntry$json = const {
  '1': 'PresenceEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.protocol.ClientInfo',
      '10': 'value'
    },
  ],
  '7': const {'7': true},
};

const PresenceStatsRequest$json = const {
  '1': 'PresenceStatsRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
  ],
};

const PresenceStatsResult$json = const {
  '1': 'PresenceStatsResult',
  '2': const [
    const {'1': 'num_clients', '3': 1, '4': 1, '5': 13, '10': 'numClients'},
    const {'1': 'num_users', '3': 2, '4': 1, '5': 13, '10': 'numUsers'},
  ],
};

const HistoryRequest$json = const {
  '1': 'HistoryRequest',
  '2': const [
    const {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
  ],
};

const HistoryResult$json = const {
  '1': 'HistoryResult',
  '2': const [
    const {
      '1': 'publications',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.protocol.Publication',
      '10': 'publications'
    },
  ],
};

const PingRequest$json = const {
  '1': 'PingRequest',
};

const PingResult$json = const {
  '1': 'PingResult',
};

const RPCRequest$json = const {
  '1': 'RPCRequest',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'method', '3': 2, '4': 1, '5': 9, '10': 'method'},
  ],
};

const RPCResult$json = const {
  '1': 'RPCResult',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
  ],
};

const SendRequest$json = const {
  '1': 'SendRequest',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
  ],
};
