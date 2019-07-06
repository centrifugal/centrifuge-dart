import 'dart:async';
import 'dart:io';

import 'package:centrifuge/centrifuge.dart';
import 'package:centrifuge/src/client.dart';
import 'package:centrifuge/src/proto/client.pb.dart' hide Error;
import 'package:centrifuge/src/transport.dart';
import 'package:mockito/mockito.dart';
import 'package:protobuf/protobuf.dart';

class MockWebSocket implements WebSocket {
  final List<Command> commands = <Command>[];

  final _stubs = <CommandMatcher, SendAction>{};

  @override
  Duration pingInterval;

  @override
  String closeReason;

  @override
  void add(dynamic data) {
    final reader = CodedBufferReader(data);
    final command = Command();
    reader.readMessage(command, ExtensionRegistry.EMPTY);

    for (CommandMatcher func in _stubs.keys) {
      if (func(command)) {
        final reply = Reply()..id = command.id;
        if (_stubs[func]._error != null) {
          reply.error = _stubs[func]._error;
        } else if (_stubs[func].result != null) {
          reply.result = _stubs[func]._result.writeToBuffer();
        }

        final replyData = reply.writeToBuffer();
        final length = replyData.lengthInBytes;

        final writer = CodedBufferWriter();
        writer.writeInt32NoTag(length);
        onData(writer.toBuffer() + replyData);
      }
    }

    commands.add(command);
  }

  SendAction onCommand(CommandMatcher matcher) {
    final action = SendAction();
    _stubs[matcher] = action;
    return action;
  }

  Function onData;
  Function onError;
  Function onDone;

  @override
  StreamSubscription listen(void onData(dynamic event),
      {Function onError, void onDone(), bool cancelOnError}) {
    this.onData = onData;
    this.onError = onError;
    this.onDone = onDone;
    return null;
  }

  @override
  Future close([int code, String reason]) {
    closeReason = reason;
    onDone();
    return null;
  }

  @override
  void noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class SendAction {
  GeneratedMessage _error;
  GeneratedMessage _result;

  void result(GeneratedMessage result) {
    _result = result;
  }

  void error(GeneratedMessage error) {
    _error = error;
  }
}

typedef CommandMatcher = Function(Command);

CommandMatcher withMethod(MethodType type) =>
    (Command command) => command.method == type;

class MockTransport implements Transport {
  String url;
  TransportConfig transportConfig;

  @override
  Future close() {
    // TODO: implement close
    return null;
  }

  void Function(Push push) onPush;
  void Function(dynamic) onError;
  void Function(String, bool) onDone;

  Completer<void> _openCompleter;

  void completeOpen() {
    assert(_openCompleter != null);

    _openCompleter.complete();
    _openCompleter = null;
  }

  void completeOpenError(dynamic error) {
    assert(_openCompleter != null);

    _openCompleter.completeError(error);
    _openCompleter = null;
  }

  @override
  Future open(void Function(Push push) onPush,
      {Function onError, void Function(String, bool) onDone}) {
    assert(_openCompleter == null);
    _openCompleter = Completer<void>.sync();

    this.onPush = onPush;
    this.onError = onError;
    this.onDone = onDone;

    return _openCompleter.future;
  }

  final sendList = <Triplet>[];

  Triplet<Req, Res> sendListLast<Req extends GeneratedMessage,
          Res extends GeneratedMessage>() =>
      sendList.last;

  @override
  Future<Rep>
      sendMessage<Req extends GeneratedMessage, Rep extends GeneratedMessage>(
          Req request, Rep result) {
    final completer = Completer<Rep>.sync();

    sendList.add(Triplet<Req, Rep>(request, result, completer));

    return completer.future;
  }
}

class Triplet<Req extends GeneratedMessage, Res extends GeneratedMessage> {
  Triplet(this.request, this.result, this.completer);

  Req request;
  Res result;
  Completer<Res> completer;

  void completeWith(Res result) => completer.complete(result);

  void completeWith2(Res Function(Res) updates) =>
      completer.complete(updates(result));

  void completeWithError(dynamic error) => completer.completeError(error);

  void complete() => completer.complete(result);

  @override
  String toString() => '($request, $result, $completer)';

  @override
  bool operator ==(dynamic other) {
    if (other is! Triplet) return false;
    return other.request == request &&
        other.completer == completer &&
        other.completer == completer;
  }

  @override
  int get hashCode => request.hashCode ^ completer.hashCode ^ result.hashCode;
}

class MockClient extends Mock with MockTransport implements ClientImpl {
  @override
  ClientConfig config;

  @override
  bool connected;
}
