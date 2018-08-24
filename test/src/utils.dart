import 'dart:async';
import 'dart:io';

import 'package:centrifuge/src/proto/client.pb.dart' hide Error;
import 'package:centrifuge/src/transport.dart';
import 'package:mockito/mockito.dart';
import 'package:protobuf/protobuf.dart';

class MockWebSocket implements WebSocket {
  final List<Command> commands = <Command>[];

  final _stubs = <CommandMatcher, SendAction>{};

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

class MockTransport extends Mock implements Transport {
  Function(Push) get triggerOnPush => _openCaptured[0];

  Function(dynamic) get triggerOnError => _openCaptured[1];

  Function get triggerOnDone => _openCaptured[2];

  List get _openCaptured => verify(open(captureAny,
          onError: captureAnyNamed('onError'),
          onDone: captureAnyNamed('onDone')))
      .captured;
}
