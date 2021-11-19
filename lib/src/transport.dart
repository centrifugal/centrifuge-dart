import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:protobuf/protobuf.dart';

import 'codec.dart';
import 'error.dart' as centrifuge;
import 'proto/client.pb.dart' hide Error;

typedef TransportBuilder = Transport Function({
  required String url,
  required TransportConfig config,
});

typedef WebSocketBuilder = Future<WebSocket> Function();

class TransportConfig {
  TransportConfig(
      {this.pingInterval = const Duration(seconds: 25),
      this.headers = const <String, dynamic>{},
      this.timeout = const Duration(seconds: 10)});

  final Duration pingInterval;
  final Map<String, dynamic> headers;
  final Duration timeout;
}

Transport protobufTransportBuilder(
    {required String url, required TransportConfig config}) {
  final replyDecoder = ProtobufReplyDecoder();
  final commandEncoder = ProtobufCommandEncoder();

  final transport = Transport(
    () => WebSocket.connect(
      url,
      protocols: ["centrifuge-protobuf"],
      headers: config.headers,
    ),
    config,
    commandEncoder,
    replyDecoder,
  );

  return transport;
}

abstract class GeneratedMessageSender {
  Future<Rep>
      sendMessage<Req extends GeneratedMessage, Rep extends GeneratedMessage>(
          Req request, Rep result);
  Future<void> sendAsyncMessage<Req extends GeneratedMessage>(Req request);
}

class Transport implements GeneratedMessageSender {
  Transport(this._socketBuilder, this._config, this._commandEncoder,
      this._replyDecoder);

  final WebSocketBuilder _socketBuilder;
  WebSocket? _socket;
  final CommandEncoder _commandEncoder;
  final ReplyDecoder _replyDecoder;
  final TransportConfig _config;

  Future open(void onPush(Push push),
      {Function? onError,
      void onDone(String reason, bool shouldReconnect)?}) async {
    _socket = await _socketBuilder();
    if (_config.pingInterval != Duration.zero) {
      _socket!.pingInterval = _config.pingInterval;
    }

    _socket!.listen(
      _onData(onPush) as void Function(dynamic)?,
      onError: onError,
      onDone: _onDone(onDone) as void Function()?,
    );
  }

  int _messageId = 1;

  var _completers = <int, Completer<GeneratedMessage>>{};

  @override
  Future<Rep>
      sendMessage<Req extends GeneratedMessage, Rep extends GeneratedMessage>(
          Req request, Rep result) async {
    final command = _createCommand(request, false);
    try {
      var fut = _sendCommand(command);
      if (_config.timeout.inMicroseconds > 0) {
        fut = fut.timeout(_config.timeout);
      }
      final reply = await fut;
      final filledResult = _processResult(result, reply);
      return filledResult;
    } on TimeoutException {
      if (command.id > 0) {
        _completers.remove(command.id);
      }
      rethrow;
    }
  }

  @override
  Future<void> sendAsyncMessage<Req extends GeneratedMessage>(
      Req request) async {
    if (_socket == null) {
      throw centrifuge.ClientDisconnectedError;
    }
    final command = _createCommand(request, true);
    final List<int> data = _commandEncoder.convert(command);
    _socket!.add(data);
  }

  Future? close() {
    return _socket?.close();
  }

  Command _createCommand(GeneratedMessage request, bool isAsync) {
    final cmd = Command()
      ..method = _getType(request)
      ..params = request.writeToBuffer();
    if (!isAsync) {
      cmd.id = _messageId++;
    }
    return cmd;
  }

  Future<Reply> _sendCommand(Command command) {
    final completer = Completer<Reply>.sync();

    _completers[command.id] = completer;

    final List<int> data = _commandEncoder.convert(command);

    if (_socket == null) {
      throw centrifuge.ClientDisconnectedError;
    }

    _socket!.add(data);

    return completer.future;
  }

  T _processResult<T extends GeneratedMessage>(T result, Reply reply) {
    if (reply.hasError()) {
      throw centrifuge.Error.custom(reply.error.code, reply.error.message);
    }
    result.mergeFromBuffer(reply.result);
    return result;
  }

  Command_MethodType _getType(GeneratedMessage request) {
    switch (request.runtimeType) {
      case ConnectRequest:
        return Command_MethodType.CONNECT;
      case PublishRequest:
        return Command_MethodType.PUBLISH;
      case UnsubscribeRequest:
        return Command_MethodType.UNSUBSCRIBE;
      case SubscribeRequest:
        return Command_MethodType.SUBSCRIBE;
      case HistoryRequest:
        return Command_MethodType.HISTORY;
      case PresenceRequest:
        return Command_MethodType.PRESENCE;
      case PresenceStatsRequest:
        return Command_MethodType.PRESENCE_STATS;
      case RPCRequest:
        return Command_MethodType.RPC;
      default:
        throw ArgumentError('unknown request type');
    }
  }

  Function _onDone(void Function(String, bool)? onDone) {
    return () {
      String reason = "connection closed";
      bool reconnect = true;
      _completers.forEach((key, value) {
        _completers[key]?.completeError(centrifuge.ClientDisconnectedError);
      });
      _completers = <int, Completer<GeneratedMessage>>{};
      if (_socket!.closeReason != null) {
        try {
          final Map<String, dynamic> info = jsonDecode(_socket!.closeReason!);
          reason = info['reason'];
          reconnect = info['reconnect'] ?? true;
        } catch (_) {}
      }
      onDone!(reason, reconnect);
    };
  }

  Function _onData(void onPush(Push push)) {
    return (dynamic input) {
      final List<Reply> replies = _replyDecoder.convert(input);
      replies.forEach((reply) {
        if (reply.id > 0) {
          _completers.remove(reply.id)?.complete(reply);
        } else {
          final push = Push.fromBuffer(reply.result);

          onPush(push);
        }
      });
    };
  }
}
