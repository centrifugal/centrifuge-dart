import 'package:fixnum/fixnum.dart' as $fixnum;

class ServerSubscription {
  ServerSubscription(this.channel, this.recoverable, this.offset, this.epoch);

  final String channel;
  bool recoverable;
  $fixnum.Int64 offset;
  String epoch;

  static ServerSubscription from(String channel, bool recoverable, $fixnum.Int64 offset, String epoch) =>
      ServerSubscription(channel, recoverable, offset, epoch);

  @override
  String toString() {
    return 'ServerSubscription{channel: $channel}';
  }
}
