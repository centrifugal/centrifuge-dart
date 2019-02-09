import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart';

import 'codec.dart';
import 'proto/client.pb.dart' hide Error;

typedef Transport TransportBuilder(
    {@required String url, @required Map<String, dynamic> headers});

typedef Future<WebSocket> WebSocketBuilder();

Transport protobufTransportBuilder(
    {@required String url, @required Map<String, dynamic> headers}) {
  final replyDecoder = ProtobufReplyDecoder();
  final commandEncoder = ProtobufCommandEncoder();

  final transport = Transport(
    () => WebSocket.connect(
          url,
          headers: headers,
        ),
    commandEncoder,
    replyDecoder,
  );

  return transport;
}

class Transport {
  Transport(this._socketBuilder, this._commandEncoder, this._replyDecoder);

  final WebSocketBuilder _socketBuilder;
  WebSocket _socket;
  final CommandEncoder _commandEncoder;
  final ReplyDecoder _replyDecoder;

  Future open(void onPush(Push push), {Function onError, void onDone()}) async {
    _socket = await _socketBuilder();

    _socket.listen(
      _onData(onPush),
      onError: onError,
      onDone: onDone,
    );
  }

  int _messageId = 1;

  final _completers = <int, Completer<GeneratedMessage>>{};

  Future<Rep> send<Req extends GeneratedMessage, Rep extends GeneratedMessage>(
      Req request, Rep result) async {
    final command = _createCommand(request);

    final reply = await _sendCommand(command);

    final filledResult = _processResult(result, reply);
    return filledResult;
  }

  Future close() {
    return _socket.close();
  }

  Command _createCommand(GeneratedMessage request) => Command()
    ..id = _messageId++
    ..method = _getType(request)
    ..params = request.writeToBuffer();

  Future<Reply> _sendCommand(Command command) {
    final completer = Completer<Reply>.sync();

    _completers[command.id] = completer;

    final data = _commandEncoder.convert(command);
    _socket.add(data);

    return completer.future;
  }

  T _processResult<T extends GeneratedMessage>(T result, Reply reply) {
    if (reply.hasError()) {
      throw reply.error;
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
      default:
        throw ArgumentError('unknown request type');
    }
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
