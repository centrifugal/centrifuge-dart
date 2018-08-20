import 'dart:async';
import 'dart:io';

import 'package:centrifuge/src/proto/client.pb.dart';
import 'package:centrifuge/src/transport.dart';
import 'package:mockito/mockito.dart';
import 'package:protobuf/protobuf.dart';

class MockWebSocket extends Mock implements WebSocket {
  final List<Command> commands = <Command>[];

  final _stubs = <CommandMatcher, SendAction>{};

  @override
  void add(dynamic data) {
    final reader = CodedBufferReader(data);
    final command = Command();
    reader.readMessage(command, ExtensionRegistry.EMPTY);

    for (CommandMatcher func in _stubs.keys) {
      if (func(command)) {
        final reply = Reply()
          ..id = command.id
          ..result = _stubs[func]._payload.writeToBuffer();

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
}

class SendAction {
  GeneratedMessage _payload;

  void send(GeneratedMessage payload) {
    _payload = payload;
  }
}

typedef CommandMatcher = Function(Command);

CommandMatcher withMethod(MethodType type) =>
    (Command command) => command.method == type;

class MockTransport extends Mock implements CentrifugeTransport {}
