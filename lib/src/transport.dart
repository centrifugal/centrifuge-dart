import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart';

import 'codec.dart';
import 'error.dart' as centrifuge;
import 'proto/client.pb.dart' hide Error;

typedef Transport TransportBuilder({
  @required String url,
  @required TransportConfig config,
});

typedef Future<WebSocket> WebSocketBuilder();

class TransportMessage<Req extends GeneratedMessage,
    Res extends GeneratedMessage> {
  TransportMessage({
    this.req,
    this.res,
    this.onError,
  });
  final Req req;
  final Res res;
  final void Function(int code, String message) onError;
}

class TransportConfig {
  TransportConfig({
    this.pingInterval = const Duration(seconds: 25),
    this.headers = const <String, dynamic>{},
  });

  final Duration pingInterval;
  final Map<String, dynamic> headers;
}

Transport protobufTransportBuilder({
  @required String url,
  @required TransportConfig config,
}) {
  final replyDecoder = ProtobufReplyDecoder();
  final commandEncoder = ProtobufCommandEncoder();

  final transport = Transport(
    () => WebSocket.connect(
      url,
      headers: config.headers,
    ),
    config,
    commandEncoder,
    replyDecoder,
  );

  return transport;
}

abstract class GeneratedMessageSender {
  Future<List<Res>>
      sendMessages<Req extends GeneratedMessage, Res extends GeneratedMessage>(
          List<TransportMessage<Req, Res>> messages);
}

class Transport implements GeneratedMessageSender {
  Transport(
    this._socketBuilder,
    this._config,
    this._commandEncoder,
    this._replyDecoder,
  );

  final WebSocketBuilder _socketBuilder;
  WebSocket _socket;
  final CommandEncoder _commandEncoder;
  final ReplyDecoder _replyDecoder;
  final TransportConfig _config;

  Future open(
    void onPush(Push push), {
    Function onError,
    void onDone(String reason, bool shouldReconnect),
  }) async {
    _socket = await _socketBuilder();
    if (_config.pingInterval != Duration.zero) {
      _socket.pingInterval = _config.pingInterval;
    }

    _socket.listen(
      _onData(onPush),
      onError: onError,
      onDone: _onDone(onDone),
    );
  }

  int _messageId = 1;

  final _completers = <int, Completer<GeneratedMessage>>{};

  @override
  Future<List<Res>>
      sendMessages<Req extends GeneratedMessage, Res extends GeneratedMessage>(
          List<TransportMessage<Req, Res>> messages) async {
    final commands = messages.map((msg) => _createCommand(msg.req)).toList();
    final replies = await _sendCommands(commands);

    final filledResults = <Res>[];
    for (var i = 0; i < replies.length; i++) {
      filledResults.add(
        _processResult(messages[i].res, replies[i], messages[i].onError),
      );
    }

    return filledResults;
  }

  Future close() {
    return _socket.close();
  }

  Command _createCommand(GeneratedMessage request) => Command()
    ..id = _messageId++
    ..method = _getType(request)
    ..params = request.writeToBuffer();

  Future<List<Reply>> _sendCommands(List<Command> commands) {
    // List of completers each reffering to one of the passed commands
    final ctxCompleters = <Completer<Reply>>[];

    for (final cmd in commands) {
      final completer = Completer<Reply>.sync();
      _completers[cmd.id] = completer;
      ctxCompleters.add(completer);
    }

    final data = _commandEncoder.convert(commands);

    if (_socket == null) {
      throw centrifuge.ClientDisconnectedError;
    }

    _socket.add(data);
    return Future.wait(ctxCompleters.map((c) => c.future));
  }

  T _processResult<T extends GeneratedMessage>(T result, Reply reply,
      [void Function(int code, String message) onError]) {
    if (reply.hasError()) {
      if (onError != null) {
        onError(reply.error.code, reply.error.message);
        return null;
      } else {
        throw centrifuge.Error.custom(reply.error.code, reply.error.message);
      }
    }
    result.mergeFromBuffer(reply.result);
    return result;
  }

  MethodType _getType(GeneratedMessage request) {
    switch (request.runtimeType) {
      case ConnectRequest:
        return MethodType.CONNECT;
      case PublishRequest:
        return MethodType.PUBLISH;
      case UnsubscribeRequest:
        return MethodType.UNSUBSCRIBE;
      case SubscribeRequest:
        return MethodType.SUBSCRIBE;
      case HistoryRequest:
        return MethodType.HISTORY;
      case RPCRequest:
        return MethodType.RPC;
      default:
        throw ArgumentError('unknown request type');
    }
  }

  Function _onDone(void Function(String, bool) onDone) {
    return () {
      String reason;
      bool reconnect = true;
      if (_socket.closeReason != null) {
        try {
          final Map<String, dynamic> info = jsonDecode(_socket.closeReason);
          reason = info['reason'];
          reconnect = info['reconnect'] ?? true;
        } catch (_) {}
      }
      onDone(reason, reconnect);
    };
  }

  Function _onData(void onPush(Push push)) {
    return (dynamic input) {
      final replies = _replyDecoder.convert(input);
      replies.forEach((reply) {
        if (reply.id > 0) {
          _completers.remove(reply.id).complete(reply);
        } else {
          final push = Push.fromBuffer(reply.result);

          onPush(push);
        }
      });
    };
  }
}
