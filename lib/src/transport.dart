import 'dart:async';
import 'dart:io';

import 'package:protobuf/protobuf.dart';

import 'codec.dart';
import 'proto/client.pb.dart' hide Error;
import 'subscription.dart';

class CentrifugeTransport extends StreamView<Push> {
  final WebSocket _socket;
  final CommandEncoder _commandEncoder;
  final ReplyDecoder _replyDecoder;
  final StreamController<Push> _pushController;

  factory CentrifugeTransport(WebSocket socket, CommandEncoder commandEncoder,
      ReplyDecoder replyDecoder) {
    final transport = CentrifugeTransport._(socket, commandEncoder,
        replyDecoder, StreamController.broadcast(sync: true));
    return transport;
  }

  CentrifugeTransport._(this._socket, this._commandEncoder, this._replyDecoder,
      this._pushController)
      : super(_pushController.stream) {
    _socket.listen(
      _onData,
      onError: (dynamic error) => print(error),
      onDone: _onSocketDone,
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

  void _onData(dynamic input) {
    final replies = _replyDecoder.convert(input);
    replies.forEach((reply) {
      if (reply.id > 0) {
        _onResponse(reply);
      } else {
        _onPush(reply);
      }
    });
  }

  void _onPush(Reply reply) {
    final push = Push.fromBuffer(reply.result);
    _pushController.add(push);
  }

  void _onResponse(Reply reply) {
    assert(reply.id > 0);
    _completers.remove(reply.id).complete(reply);
  }

  void _onSocketDone() {
    final event = UnsubscribeEvent();
//    _subscriptions.values.forEach((s) => s.onUnsubscribe(event));
//
//    _disconnectController.add(DisconnectEvent._('socket was closed', false));
  }
}
