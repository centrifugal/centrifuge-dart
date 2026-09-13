import 'dart:async';
import 'dart:io';

import 'package:centrifuge/src/proto/client.pb.dart' as protocol;
import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as pb;

/// In-process Centrifugo fake server for tests, speaking the protobuf protocol
/// over a WebSocket. It is intentionally protocol-level and generic: it provides
/// sensible defaults for the connect/subscribe/unsubscribe handshake, captures
/// received commands for assertions, and exposes hooks + raw push senders so new
/// scenarios can be added WITHOUT touching the client under test or this helper.
///
/// This exists because some features (channel compaction, and in future others)
/// are Centrifugo PRO only and can't be exercised against the OSS docker-compose
/// server the other suites use; and because a fake gives deterministic control
/// of timing, errors and reconnects.
///
/// How to extend (most→least common):
///   - Customize a subscribe reply:      server.onSubscribe = (ch, req) { final r = SubscribeResult(); r.recoverable = true; return r; };
///   - Negotiate channel compaction:     server.onSubscribe = (ch, req) { final r = SubscribeResult(); if (req.flag.toInt() & 1 != 0) r.id = Int64(42); return r; };
///   - Push to a subscription:           server.publish(id: 42, data: bytes);  // by numeric id (compaction)
///                                       server.publish(channel: 'news', data: bytes); // by channel name
///   - Fully control any command reply:  server.onCommand = (cmd) => cmd.hasRpc() ? (Reply()..id = cmd.id ..error = (Error()..code=1)) : null;
///   - Leave a command unanswered:       server.holdReply = (cmd) => cmd.hasConnect();
///   - Never answer the WS handshake:    server.holdHandshake = true;
///   - Send anything the protocol allows: server.sendReply(Reply()..push = (Push()..disconnect = (Disconnect()..code = 3000)));
///   - Drive a reconnect:                server.closeConnection();
///   - Assert on what the client sent:   server.received / server.lastSubscribe
///   - Assert on connections:            server.handshakeRequests / server.openConnections
class FakeCentrifugoServer {
  HttpServer? _httpServer;
  WebSocket? _socket;
  final _connections = <WebSocket>[];
  final _openConnections = <WebSocket>{};

  /// All commands received from the client, in order.
  final List<protocol.Command> received = <protocol.Command>[];

  /// connect reply fields. Override to set expires/ttl/data/etc.
  protocol.ConnectResult connectResult = protocol.ConnectResult()
    ..client = 'fake-client'
    ..version = '0.0.0'
    ..ping = 25;

  /// Full override for any command — return a Reply to send, or null to fall
  /// through to default handling.
  protocol.Reply? Function(protocol.Command cmd)? onCommand;

  /// Return true to leave a command unanswered (reply later with [sendReply],
  /// or never).
  bool Function(protocol.Command cmd)? holdReply;

  /// When true, new WebSocket upgrade requests are never answered, like a
  /// server that accepts TCP connections but never completes the handshake.
  bool holdHandshake = false;

  /// Number of WebSocket upgrade requests received, including held ones.
  int handshakeRequests = 0;

  /// Number of client connections that are still open.
  int get openConnections => _openConnections.length;

  /// Customize the subscribe result per channel (default: empty result).
  protocol.SubscribeResult Function(String channel, protocol.SubscribeRequest req)? onSubscribe;

  String get url => 'ws://localhost:${_httpServer!.port}/connection/websocket';

  /// The most recent subscribe request the client sent (or null).
  protocol.SubscribeRequest? get lastSubscribe {
    for (var i = received.length - 1; i >= 0; i--) {
      if (received[i].hasSubscribe()) return received[i].subscribe;
    }
    return null;
  }

  Future<void> start() async {
    _httpServer = await HttpServer.bind('localhost', 0);
    _httpServer!.listen((HttpRequest request) async {
      handshakeRequests++;
      if (holdHandshake) {
        // Left pending until the server stops.
        return;
      }
      final socket = await WebSocketTransformer.upgrade(request,
          protocolSelector: (_) => 'centrifuge-protobuf');
      _socket = socket;
      _connections.add(socket);
      _openConnections.add(socket);
      socket.listen((dynamic data) => _onData(socket, data as List<int>),
          onDone: () => _openConnections.remove(socket));
    });
  }

  /// Stop the server and close all connections.
  Future<void> stop() async {
    for (final socket in _connections) {
      await socket.close();
    }
    await _httpServer?.close(force: true);
  }

  /// Close the active connection from the server side, triggering the client's
  /// automatic reconnect.
  Future<void> closeConnection() async {
    await _socket?.close();
  }

  void _onData(WebSocket socket, List<int> data) {
    final reader = pb.CodedBufferReader(data);
    while (!reader.isAtEnd()) {
      final cmd = protocol.Command();
      reader.readMessage(cmd, pb.ExtensionRegistry.EMPTY);
      _dispatch(socket, cmd);
    }
  }

  void _dispatch(WebSocket socket, protocol.Command cmd) {
    received.add(cmd);

    if (holdReply != null && holdReply!(cmd)) {
      return;
    }

    if (onCommand != null) {
      final reply = onCommand!(cmd);
      if (reply != null) {
        _reply(socket, reply);
        return;
      }
    }

    if (cmd.hasConnect()) {
      _reply(
          socket,
          protocol.Reply()
            ..id = cmd.id
            ..connect = connectResult);
    } else if (cmd.hasSubscribe()) {
      final result = onSubscribe != null
          ? onSubscribe!(cmd.subscribe.channel, cmd.subscribe)
          : protocol.SubscribeResult();
      _reply(
          socket,
          protocol.Reply()
            ..id = cmd.id
            ..subscribe = result);
    } else if (cmd.hasUnsubscribe()) {
      _reply(
          socket,
          protocol.Reply()
            ..id = cmd.id
            ..unsubscribe = protocol.UnsubscribeResult());
    } else if (cmd.id != 0) {
      // Reply to anything else with an empty result to avoid client timeouts.
      _reply(socket, protocol.Reply()..id = cmd.id);
    }
  }

  /// Replies on the connection the command came from. A command can still
  /// arrive on a connection that closeConnection() already closed: its reply
  /// is dropped, as a real server's would be.
  void _reply(WebSocket socket, protocol.Reply reply) {
    final replyData = reply.writeToBuffer();
    final framed = (pb.CodedBufferWriter()
          ..writeInt32NoTag(replyData.length)
          ..writeRawBytes(replyData))
        .toBuffer();
    try {
      socket.add(framed);
    } on StateError {
      // Connection already closed.
    }
  }

  // --- raw escape hatches ---------------------------------------------------

  /// Send a raw reply.
  void sendReply(protocol.Reply reply) {
    final replyData = reply.writeToBuffer();
    final framed = (pb.CodedBufferWriter()
          ..writeInt32NoTag(replyData.length)
          ..writeRawBytes(replyData))
        .toBuffer();
    _socket!.add(framed);
  }

  /// Send a raw push (wrapped in a reply).
  void sendPush(protocol.Push push) => sendReply(protocol.Reply()..push = push);

  // --- typed push senders ---------------------------------------------------

  // Channel compaction pushes carry a numeric [id] and no channel; otherwise the
  // [channel] name is used. Provide exactly one.
  void _applyTarget(protocol.Push push, int? id, String? channel) {
    if (id != null) {
      push.id = Int64(id);
    } else if (channel != null) {
      push.channel = channel;
    }
  }

  void publish({int? id, String? channel, required List<int> data}) {
    final push = protocol.Push()..pub = (protocol.Publication()..data = data);
    _applyTarget(push, id, channel);
    sendPush(push);
  }

  void join({int? id, String? channel, required String client}) {
    final push = protocol.Push()
      ..join = (protocol.Join()..info = (protocol.ClientInfo()..client = client));
    _applyTarget(push, id, channel);
    sendPush(push);
  }

  void leave({int? id, String? channel, required String client}) {
    final push = protocol.Push()
      ..leave = (protocol.Leave()..info = (protocol.ClientInfo()..client = client));
    _applyTarget(push, id, channel);
    sendPush(push);
  }

  void unsubscribe(String channel, int code, String reason) {
    sendPush(protocol.Push()
      ..channel = channel
      ..unsubscribe = (protocol.Unsubscribe()
        ..code = code
        ..reason = reason));
  }

  void disconnect(int code, String reason) {
    sendPush(protocol.Push()
      ..disconnect = (protocol.Disconnect()
        ..code = code
        ..reason = reason));
  }
}
