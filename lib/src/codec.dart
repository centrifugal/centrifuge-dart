import 'dart:convert';

import 'package:centrifuge/src/proto/client.pb.dart';
import 'package:protobuf/protobuf.dart';

abstract class CommandEncoder extends Converter<Command, List<int>> {}

abstract class ReplyDecoder extends Converter<List<int>, List<Reply>> {}

class ProtobufCommandEncoder extends CommandEncoder {
  @override
  List<int> convert(Command input) {
    final commandData = input.writeToBuffer();
    final length = commandData.lengthInBytes;

    final writer = CodedBufferWriter();
    writer.writeInt32NoTag(length);

    return writer.toBuffer() + commandData;
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
  List<int> convert(Command input) {
    return utf8.encode(input.writeToJson());
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
