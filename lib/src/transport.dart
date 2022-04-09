import 'dart:async';
import 'dart:io';

import 'package:protobuf/protobuf.dart';

import 'codec.dart';
import 'codes.dart';
import 'error.dart' as centrifuge;
import 'proto/client.pb.dart' hide Error;

typedef TransportBuilder = Transport Function({
  required String url,
  required TransportConfig config,
});

typedef WebSocketBuilder = Future<WebSocket> Function();

class TransportConfig {
  TransportConfig({this.headers = const <String, dynamic>{}, this.timeout = const Duration(seconds: 10)});

  final Map<String, dynamic> headers;
  final Duration timeout;
}

Transport protobufTransportBuilder({required String url, required TransportConfig config}) {
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
  Future<Rep> sendMessage<Req extends GeneratedMessage, Rep extends GeneratedMessage>(
      Req request, Rep result);
  Future<void> sendAsyncMessage<Req extends GeneratedMessage>(Req request);
}

class Transport implements GeneratedMessageSender {
  Transport(this._socketBuilder, this._config, this._commandEncoder, this._replyDecoder);

  final WebSocketBuilder _socketBuilder;
  WebSocket? _socket;
  final CommandEncoder _commandEncoder;
  final ReplyDecoder _replyDecoder;
  final TransportConfig _config;

  Future open(void onPush(Push push, bool isPing),
      {Function? onError, void onDone(int code, String reason, bool shouldReconnect)?}) async {
    _socket = await _socketBuilder();
    _socket!.listen(
      _onData(onPush) as void Function(dynamic)?,
      onError: onError,
      onDone: _onDone(onDone) as void Function()?,
    );
  }

  int _messageId = 1;

  var _completers = <int, Completer<GeneratedMessage>>{};

  @override
  Future<Rep> sendMessage<Req extends GeneratedMessage, Rep extends GeneratedMessage>(
    Req request,
    Rep result,
  ) async {
    final command = _createCommand(
      request,
      false,
    );
    try {
      var fut = _sendCommand(command);
      if (_config.timeout.inMicroseconds > 0) {
        fut = fut.timeout(_config.timeout);
      }
      final reply = await fut;
      if (reply.hasError()) {
        throw centrifuge.Error.custom(reply.error.code, reply.error.message, reply.error.temporary);
      }
      if (reply.hasConnect()) {
        result.mergeFromMessage(reply.connect);
        return result;
      } else if (reply.hasSubscribe()) {
        result.mergeFromMessage(reply.subscribe);
        return result;
      } else if (reply.hasPublish()) {
        result.mergeFromMessage(reply.publish);
        return result;
      } else if (reply.hasPing()) {
        result.mergeFromMessage(reply.publish);
        return result;
      } else if (reply.hasUnsubscribe()) {
        result.mergeFromMessage(reply.unsubscribe);
        return result;
      } else if (reply.hasPresence()) {
        result.mergeFromMessage(reply.presence);
        return result;
      } else if (reply.hasPresenceStats()) {
        result.mergeFromMessage(reply.presenceStats);
        return result;
      } else if (reply.hasHistory()) {
        result.mergeFromMessage(reply.history);
        return result;
      } else if (reply.hasRpc()) {
        result.mergeFromMessage(reply.rpc);
        return result;
      } else if (reply.hasRefresh()) {
        result.mergeFromMessage(reply.refresh);
        return result;
      } else if (reply.hasSubRefresh()) {
        result.mergeFromMessage(reply.subRefresh);
        return result;
      }
      throw ArgumentError("unknown reply type " + reply.toString());
    } on TimeoutException {
      if (command.id > 0) {
        _completers.remove(command.id);
      }
      rethrow;
    }
  }

  @override
  Future<void> sendAsyncMessage<Req extends GeneratedMessage>(
    Req request,
  ) async {
    if (_socket == null) {
      throw centrifuge.ClientDisconnectedError;
    }
    final command = _createCommand(
      request,
      true,
    );
    final List<int> data = _commandEncoder.convert(command);
    _socket!.add(data);
  }

  Future? close() {
    return _socket?.close();
  }

  Command _createCommand(
    GeneratedMessage request,
    bool isAsync,
  ) {
    final cmd = Command();
    if (request is ConnectRequest) {
      cmd..connect = request;
    } else if (request is PublishRequest) {
      cmd..publish = request;
    } else if (request is PingRequest) {
      cmd..ping = request;
    } else if (request is SubscribeRequest) {
      cmd..subscribe = request;
    } else if (request is UnsubscribeRequest) {
      cmd..unsubscribe = request;
    } else if (request is HistoryRequest) {
      cmd..history = request;
    } else if (request is PresenceRequest) {
      cmd..presence = request;
    } else if (request is PresenceStatsRequest) {
      cmd..presenceStats = request;
    } else if (request is RPCRequest) {
      cmd..rpc = request;
    } else if (request is RefreshRequest) {
      cmd..refresh = request;
    } else if (request is SubRefreshRequest) {
      cmd..subRefresh = request;
    } else if (request is SendRequest) {
      cmd..send = request;
    } else if (request is Command) {
      // Pong.
    } else {
      throw ArgumentError('unknown request type');
    }
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

  Function _onDone(void Function(int, String, bool)? onDone) {
    return () {
      _completers.forEach((key, value) {
        _completers[key]?.completeError(centrifuge.ClientDisconnectedError);
      });
      _completers = <int, Completer<GeneratedMessage>>{};
      int code = connectingCodeTransportClosed;
      String reason = "transport closed";
      bool reconnect = true;
      if (_socket != null && _socket!.closeCode! > 0) {
        code = _socket!.closeCode!;
        reason = _socket!.closeReason!;
        reconnect = code < 3500 || code >= 5000 || (code >= 4000 && code < 4500);
        if (code < 3000) {
          if (code == 1009) {
            code = disconnectCodeMessageSizeLimit;
            reason = "message size limit exceeded";
          } else {
            // We expose codes defined by Centrifuge protocol, hiding
            // details about transport-specific error codes. We may have extra
            // optional transportCode field in the future.
            code = connectingCodeTransportClosed;
          }
        }
      }
      onDone!(code, reason, reconnect);
    };
  }

  Function _onData(void onPush(Push push, bool isPing)) {
    return (dynamic input) {
      final List<Reply> replies = _replyDecoder.convert(input);
      replies.forEach((reply) {
        if (reply.id > 0) {
          _completers.remove(reply.id)?.complete(reply);
        } else {
          onPush(reply.push, !reply.hasPush());
        }
      });
    };
  }
}
