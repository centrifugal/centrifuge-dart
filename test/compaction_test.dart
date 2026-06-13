import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:centrifuge/src/proto/client.pb.dart' as protocol;
import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as pb;
import 'package:test/test.dart';

/// Minimal in-process Centrifugo stand-in speaking the protobuf protocol over
/// a WebSocket. Channel compaction is a Centrifugo PRO feature, so it can't be
/// exercised against the docker-compose OSS server — this fake negotiates a
/// numeric channel ID in the subscribe reply and then sends pushes carrying
/// the ID instead of the channel name, which is exactly what the real server
/// does when compaction is enabled.
class FakeCompactionServer {
  HttpServer? _httpServer;
  WebSocket? _socket;
  final _connections = <WebSocket>[];

  /// flag value seen in the last SubscribeRequest.
  int lastSubscribeFlag = 0;

  /// Numeric channel ID to assign on the next subscribe.
  int nextChannelId = 42;

  String get url => 'ws://localhost:${_httpServer!.port}/connection/websocket';

  Future<void> start() async {
    _httpServer = await HttpServer.bind('localhost', 0);
    _httpServer!.listen((HttpRequest request) async {
      final socket = await WebSocketTransformer.upgrade(request, protocolSelector: (_) => 'centrifuge-protobuf');
      _socket = socket;
      _connections.add(socket);
      socket.listen((dynamic data) => _onData(socket, data as List<int>));
    });
  }

  void _onData(WebSocket socket, List<int> data) {
    final reader = pb.CodedBufferReader(data);
    while (!reader.isAtEnd()) {
      final cmd = protocol.Command();
      reader.readMessage(cmd, pb.ExtensionRegistry.EMPTY);
      _handleCommand(socket, cmd);
    }
  }

  void _handleCommand(WebSocket socket, protocol.Command cmd) {
    if (cmd.hasConnect()) {
      final reply = protocol.Reply()
        ..id = cmd.id
        ..connect = (protocol.ConnectResult()
          ..client = 'fake-client'
          ..version = '0.0.0'
          ..ping = 25);
      _send(socket, reply);
    } else if (cmd.hasSubscribe()) {
      lastSubscribeFlag = cmd.subscribe.flag.toInt();
      final result = protocol.SubscribeResult();
      if (lastSubscribeFlag & 1 != 0) {
        // Client offered channel compaction — assign a numeric channel ID.
        result.id = Int64(nextChannelId);
      }
      final reply = protocol.Reply()
        ..id = cmd.id
        ..subscribe = result;
      _send(socket, reply);
    } else if (cmd.hasUnsubscribe()) {
      final reply = protocol.Reply()
        ..id = cmd.id
        ..unsubscribe = protocol.UnsubscribeResult();
      _send(socket, reply);
    } else if (cmd.id != 0) {
      // Reply to anything else with an empty result to avoid client timeouts.
      _send(socket, protocol.Reply()..id = cmd.id);
    }
  }

  /// Send a publication push carrying only the numeric channel ID.
  void sendCompactedPub(int id, List<int> data) {
    final push = protocol.Push()
      ..id = Int64(id)
      ..pub = (protocol.Publication()..data = data);
    _send(_socket!, protocol.Reply()..push = push);
  }

  void sendCompactedJoin(int id, String client) {
    final push = protocol.Push()
      ..id = Int64(id)
      ..join = (protocol.Join()..info = (protocol.ClientInfo()..client = client));
    _send(_socket!, protocol.Reply()..push = push);
  }

  void sendCompactedLeave(int id, String client) {
    final push = protocol.Push()
      ..id = Int64(id)
      ..leave = (protocol.Leave()..info = (protocol.ClientInfo()..client = client));
    _send(_socket!, protocol.Reply()..push = push);
  }

  void _send(WebSocket socket, protocol.Reply reply) {
    final replyData = reply.writeToBuffer();
    final framed = (pb.CodedBufferWriter()
          ..writeInt32NoTag(replyData.length)
          ..writeRawBytes(replyData))
        .toBuffer();
    socket.add(framed);
  }

  Future<void> stop() async {
    for (final socket in _connections) {
      await socket.close();
    }
    await _httpServer?.close(force: true);
  }
}

Future<T> _waitForEvent<T>(Stream<T> stream, {Duration timeout = const Duration(seconds: 5)}) {
  return stream.first.timeout(timeout);
}

void main() {
  group('Channel compaction', () {
    late FakeCompactionServer server;
    late centrifuge.Client client;

    setUp(() async {
      server = FakeCompactionServer();
      await server.start();
      client = centrifuge.createClient(server.url, centrifuge.ClientConfig());
    });

    tearDown(() async {
      await client.close();
      await server.stop();
    });

    test('subscribe offers compaction flag and pushes are routed by numeric id', () async {
      await client.connect();

      final sub = client.newSubscription('compacted-channel');
      final pubFuture = _waitForEvent<centrifuge.PublicationEvent>(sub.publication);
      final joinFuture = _waitForEvent<centrifuge.JoinEvent>(sub.join);
      final leaveFuture = _waitForEvent<centrifuge.LeaveEvent>(sub.leave);

      await sub.subscribe();

      // The subscribe request must carry the channelCompaction bit.
      expect(server.lastSubscribeFlag & 1, 1);

      // Publication push with numeric ID only (no channel name).
      server.sendCompactedPub(42, utf8.encode('{"compacted":true}'));
      final pub = await pubFuture;
      expect(jsonDecode(utf8.decode(pub.data)), {'compacted': true});

      // Join / leave pushes are compacted the same way.
      server.sendCompactedJoin(42, 'other-client');
      final join = await joinFuture;
      expect(join.client, 'other-client');

      server.sendCompactedLeave(42, 'other-client');
      final leave = await leaveFuture;
      expect(leave.client, 'other-client');
    });

    test('push with unknown id is dropped without affecting other subscriptions', () async {
      await client.connect();

      final sub = client.newSubscription('compacted-channel');
      await sub.subscribe();

      final received = <centrifuge.PublicationEvent>[];
      final pubSubscription = sub.publication.listen(received.add);
      addTearDown(() => pubSubscription.cancel());

      // Unknown ID — must not be delivered anywhere (and must not crash).
      server.sendCompactedPub(99, utf8.encode('{"stray":true}'));
      // Known ID delivered after the stray one proves the client survived it.
      server.sendCompactedPub(42, utf8.encode('{"ok":true}'));

      await Future<void>.delayed(Duration.zero);
      while (received.isEmpty) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(received, hasLength(1));
      expect(jsonDecode(utf8.decode(received.first.data)), {'ok': true});
    });

    test('same id is re-registered after disconnect/reconnect', () async {
      // Regression test: the client drops the ID registry on disconnect
      // (IDs are server-session-scoped), and on reconnect the server commonly
      // assigns the SAME ID to the channel again. The subscription must
      // re-register it even though its own remembered ID is unchanged.
      await client.connect();

      final sub = client.newSubscription('compacted-channel');
      await sub.subscribe();

      await client.disconnect();

      final resubscribed = _waitForEvent<centrifuge.SubscribedEvent>(sub.subscribed);
      await client.connect();
      await resubscribed;

      // Same ID 42 as before the reconnect.
      final received = <centrifuge.PublicationEvent>[];
      final pubSubscription = sub.publication.listen(received.add);
      addTearDown(() => pubSubscription.cancel());

      server.sendCompactedPub(42, utf8.encode('{"after_reconnect":true}'));
      while (received.isEmpty) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(jsonDecode(utf8.decode(received.first.data)), {'after_reconnect': true});
    });

    test('id mapping is dropped on unsubscribe and refreshed on resubscribe', () async {
      await client.connect();

      final sub = client.newSubscription('compacted-channel');
      await sub.subscribe();

      final received = <centrifuge.PublicationEvent>[];
      final pubSubscription = sub.publication.listen(received.add);
      addTearDown(() => pubSubscription.cancel());

      await sub.unsubscribe();

      // Old ID must no longer route to the unsubscribed subscription.
      server.sendCompactedPub(42, utf8.encode('{"stale":true}'));

      // Resubscribe — the server assigns a fresh ID.
      server.nextChannelId = 43;
      await sub.subscribe();

      server.sendCompactedPub(43, utf8.encode('{"fresh":true}'));
      while (received.isEmpty) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(received, hasLength(1));
      expect(jsonDecode(utf8.decode(received.first.data)), {'fresh': true});
    });
  });
}
