import 'dart:convert';

import 'package:centrifuge/src/proto/client.pb.dart';
import 'package:protobuf/protobuf.dart';

abstract class CommandEncoder extends Converter<List<Command>, List<int>> {}

abstract class ReplyDecoder extends Converter<List<int>, List<Reply>> {}

class ProtobufCommandEncoder extends CommandEncoder {
  @override
  List<int> convert(List<Command> commands) {
    final writer = CodedBufferWriter();
    var commandsData = <int>[];

    for (final c in commands) {
      final cmdData = c.writeToBuffer();
      commandsData += cmdData;
      writer.writeInt32NoTag(cmdData.lengthInBytes);
    }

    return writer.toBuffer() + commandsData;
  }
}

class ProtobufReplyDecoder extends ReplyDecoder {
  @override
  List<Reply> convert(List<int> input) {
    final replies = <Reply>[];

    final reader = CodedBufferReader(input);
    while (!reader.isAtEnd()) {
      final reply = Reply();
      reader.readMessage(reply, ExtensionRegistry.EMPTY);
      replies.add(reply);
    }

    return replies;
  }
}

class JsonCommandEncoder extends CommandEncoder {
  @override
  List<int> convert(List<Command> commands) {
    const jsonCommands = <String>[];
    for (final c in commands) {
      jsonCommands.add(c.writeToJson());
    }
    return utf8.encode(jsonCommands.join('\n'));
  }
}

class JsonReplyDecoder extends ReplyDecoder {
  @override
  List<Reply> convert(List<int> input) {
    final replies = <Reply>[];

    final List<Map<String, dynamic>> data = jsonDecode(utf8.decode(input));
    for (Map<String, dynamic> map in data) {
      final reply = Reply();
      reply.mergeFromJsonMap(map);
      replies.add(reply);
    }

    return replies;
  }
}
