import 'dart:async';
import 'dart:io';

import 'package:centrifuge/centrifuge.dart';
import 'package:centrifuge/src/client.dart';
import 'package:centrifuge/src/events.dart';
import 'package:centrifuge/src/proto/client.pb.dart'
    hide Error, HistoryResult, StreamPosition;
import 'package:centrifuge/src/proto/client.pb.dart' as proto;
import 'package:centrifuge/src/transport.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:mockito/mockito.dart';
import 'package:protobuf/protobuf.dart';

class MockWebSocket implements WebSocket {
  final List<Command> commands = <Command>[];

  final _stubs = <CommandMatcher, SendAction>{};

  @override
  Duration? pingInterval;

  @override
  String? closeReason;

  @override
  void add(dynamic data) {
    final reader = CodedBufferReader(data);
    final command = Command();
    reader.readMessage(command, ExtensionRegistry.EMPTY);

    for (CommandMatcher func in _stubs.keys) {
      if (func(command)) {
        final reply = Reply()..id = command.id;
        if (_stubs[func]?._error != null) {
          // ignore: avoid_as
          reply.error = _stubs[func]!._error as proto.Error;
        } else if (_stubs[func]?.result != null) {
          reply.result = _stubs[func]!._result.writeToBuffer();
        }

        final replyData = reply.writeToBuffer();
        final length = replyData.lengthInBytes;

        final writer = CodedBufferWriter();
        writer.writeInt32NoTag(length);
        onData!(writer.toBuffer() + replyData);
      }
    }

    commands.add(command);
  }

  SendAction onCommand(CommandMatcher matcher) {
    final action = SendAction();
    _stubs[matcher] = action;
    return action;
  }

  Function? onData;
  Function? onError;
  Function? onDone;

  @override
  StreamSubscription listen(void onData(dynamic event)?,
      {Function? onError, void onDone()?, bool? cancelOnError}) {
    this.onData = onData;
    this.onError = onError;
    this.onDone = onDone;
    return MockStreamSubscription<void>();
  }

  @override
  Future close([int? code, String? reason]) {
    closeReason = reason;
    onDone!();
    return Future<void>.value();
  }

  @override
  void noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class SendAction {
  GeneratedMessage? _error;
  late GeneratedMessage _result;

  void result(GeneratedMessage result) {
    _result = result;
  }

  void error(GeneratedMessage error) {
    _error = error;
  }
}

typedef CommandMatcher = Function(Command);

CommandMatcher withMethod(Command_MethodType type) =>
    (Command command) => command.method == type;

class MockTransport implements Transport {
  String? url;
  TransportConfig? transportConfig;

  @override
  Future? close() {
    // TODO: implement close
    return null;
  }

  void Function(Push push)? onPush;
  void Function(dynamic)? onError;
  void Function(String, bool)? onDone;

  Completer<void>? _openCompleter;

  void completeOpen() {
    assert(_openCompleter != null);

    _openCompleter!.complete();
    _openCompleter = null;
  }

  void completeOpenError(dynamic error) {
    assert(_openCompleter != null);

    _openCompleter!.completeError(error);
    _openCompleter = null;
  }

  @override
  Future open(void Function(Push push) onPush,
      {Function? onError, void Function(String, bool)? onDone}) {
    assert(_openCompleter == null);
    _openCompleter = Completer<void>.sync();

    this.onPush = onPush;
    this.onError = onError as void Function(dynamic)?;
    this.onDone = onDone;

    return _openCompleter!.future;
  }

  final sendList = <Triplet>[];

  Triplet<Req, Res> sendListLast<Req extends GeneratedMessage,
          Res extends GeneratedMessage>() =>
      // ignore: avoid_as
      sendList.last as Triplet<Req, Res>;

  @override
  Future<Rep>
      sendMessage<Req extends GeneratedMessage, Rep extends GeneratedMessage>(
          Req request, Rep result) {
    final completer = Completer<Rep>.sync();

    sendList.add(Triplet<Req, Rep>(request, result, completer));

    return completer.future;
  }

  @override
  Future<void> sendAsyncMessage<Req extends GeneratedMessage>(Req request) {
    // TODO: implement sendAsyncMessage
    throw UnimplementedError();
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

class MockClient extends Mock implements ClientImpl {
  @override
  ClientConfig? config;

  @override
  bool connected = false;

  @override
  Future<Rep>
      sendMessage<Req extends GeneratedMessage, Rep extends GeneratedMessage>(
          Req request, Rep result) {
    return super.noSuchMethod(
        Invocation.method(#sendMessage, [request, result]),
        returnValue: Future.value(result));
  }

  @override
  Future<proto.SubscribeResult> sendSubscribe(String channel, String? token) {
    return super.noSuchMethod(
        Invocation.method(#sendSubscribe, [channel, token]),
        returnValue: Future.value(proto.SubscribeResult()));
  }

  @override
  Future<proto.UnsubscribeResult> sendUnsubscribe(String channel) {
    return super.noSuchMethod(
        Invocation.method(#sendUnsubscribe, [
          channel,
        ]),
        returnValue: Future.value(proto.UnsubscribeResult()));
  }

  @override
  Future<HistoryResult> history(String channel,
      {int limit = 0, StreamPosition? since, bool reverse = false}) {
    return super.noSuchMethod(Invocation.method(#history, [channel]),
        returnValue: Future.value(HistoryResult([], $fixnum.Int64(0), "")));
  }

  @override
  Future<String> getToken(String channel) {
    return super.noSuchMethod(Invocation.method(#getToken, [channel]),
        returnValue: Future.value(''));
  }
}

class MockStreamSubscription<T> extends Mock implements StreamSubscription<T> {}
