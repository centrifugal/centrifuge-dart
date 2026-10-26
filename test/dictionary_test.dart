@TestOn('vm')
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'package:centrifuge/src/codec.dart';
import 'package:centrifuge/src/dictionary.dart';
import 'package:centrifuge/src/inflate_io.dart';
import 'package:centrifuge/src/proto/client.pb.dart' as protocol;
import 'package:centrifuge/src/transport.dart';
import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';

import 'dictionary_vectors.dart';
import 'fake_server.dart';

// The OSS docker-compose server does not compress, so the codec is checked
// against frames the protocol's own Go codec produced, and the client against
// the in-process FakeCentrifugoServer compressing what it sends.

/// Raw DEFLATE of [data] against [dictionary], as the server's codec emits it.
///
/// dart:io ignores a preset dictionary in raw mode, so this deflates a zlib
/// stream with one and strips the zlib header (with its dictionary id) and
/// trailer, which leaves the raw stream.
List<int> deflateWithDictionary(List<int> data, List<int> dictionary) {
  final zlib = ZLibEncoder(dictionary: dictionary, level: 7).convert(data);
  return zlib.sublist(6, zlib.length - 4);
}

List<int> compressedFrame(List<int> frame, List<int> dictionary) => [
  frameCodecCompressed,
  ...deflateWithDictionary(frame, dictionary),
];

protocol.Dictionary deliveredDictionary(List<int> content, {String? id}) =>
    protocol.Dictionary()
      ..id = id ?? 'dict-1'
      ..data = ZLibEncoder(raw: true).convert(content);

final _dictionary = utf8.encode(
  '{"type":"quote","symbol":"BTC-USD","bid":,"ask":,"last":,"volume":}',
);

Future<T> _next<T>(Stream<T> stream) =>
    stream.first.timeout(const Duration(seconds: 5));

void main() {
  group('FrameCodec', () {
    test('decodes frames compressed by the protocol codec', () {
      final codec = FrameCodec(
        vectorDictionaryId,
        vectorDictionary,
        transferred: 10,
      );
      for (var i = 0; i < vectorFrames.length; i++) {
        expect(codec.decode(vectorCompressedFrames[i]), vectorFrames[i]);
      }
      expect(codec.frames, vectorFrames.length);
      expect(
        codec.bytesReceived,
        vectorCompressedFrames.fold<int>(0, (n, f) => n + f.length),
      );
      expect(
        codec.bytesDecompressed,
        vectorFrames.fold<int>(0, (n, f) => n + f.length),
      );
    });

    test('passes a raw frame through without its marker', () {
      final codec = FrameCodec('d', vectorDictionary, transferred: 0);
      expect(codec.decode([frameCodecRaw, 1, 2, 3]), [1, 2, 3]);
    });

    test('refuses an empty frame and an unknown marker', () {
      final codec = FrameCodec('d', vectorDictionary, transferred: 0);
      expect(() => codec.decode([]), throwsFormatException);
      expect(() => codec.decode([7, 1, 2]), throwsFormatException);
    });

    test('refuses a frame decoded against another dictionary', () {
      final codec = FrameCodec('d', utf8.encode('unrelated'), transferred: 0);
      expect(
        () => codec.decode(vectorCompressedFrames.first),
        throwsA(isA<Exception>()),
      );
    });

    test('refuses a frame that expands past the limit', () {
      final codec = FrameCodec('d', vectorDictionary, transferred: 0);
      final huge = List<int>.filled(maxDecompressedFrameSize + 1, 0);
      expect(
        () => codec.decode(compressedFrame(huge, vectorDictionary)),
        throwsA(isA<InflateLimitError>()),
      );
    });
  });

  group('frameCodecFromDictionary', () {
    test('inflates the dictionary the protocol delivers', () {
      final cache = DictionaryCache();
      final codec =
          frameCodecFromDictionary(
            protocol.Dictionary()
              ..id = vectorDictionaryId
              ..data = vectorDictionaryDelivered,
            cache,
          )!;
      expect(codec.dictionary, vectorDictionary);
      expect(codec.transferred, vectorDictionaryDelivered.length);
      expect(cache.id, vectorDictionaryId);
    });

    test('reads base64 content and charges its encoded length', () {
      final codec =
          frameCodecFromDictionary(
            protocol.Dictionary()
              ..id = vectorDictionaryId
              ..dataB64 = vectorDictionaryDeliveredB64,
            DictionaryCache(),
          )!;
      expect(codec.dictionary, vectorDictionary);
      expect(codec.transferred, vectorDictionaryDeliveredB64.length);
    });

    test('takes an id alone from the cache, charging nothing', () {
      final cache = DictionaryCache()..put('d', vectorDictionary);
      final codec =
          frameCodecFromDictionary(protocol.Dictionary()..id = 'd', cache)!;
      expect(codec.dictionary, vectorDictionary);
      expect(codec.transferred, 0);
    });

    test('returns null for what it cannot use', () {
      final cache = DictionaryCache()..put('d', vectorDictionary);
      // An id this client doesn't hold.
      expect(
        frameCodecFromDictionary(protocol.Dictionary()..id = 'other', cache),
        isNull,
      );
      // Content that isn't base64, or isn't DEFLATE.
      expect(
        frameCodecFromDictionary(
          protocol.Dictionary()
            ..id = 'x'
            ..dataB64 = '%%%',
          cache,
        ),
        isNull,
      );
      expect(
        frameCodecFromDictionary(
          protocol.Dictionary()
            ..id = 'x'
            ..data = [0xff, 0xff, 0xff, 0xff],
          cache,
        ),
        isNull,
      );
      // Content past the limit.
      expect(
        frameCodecFromDictionary(
          deliveredDictionary(
            List<int>.filled(maxDictionarySize + 1, 0x61),
            id: 'x',
          ),
          cache,
        ),
        isNull,
      );
      expect(cache.id, 'd');
    });
  });

  group('Transport', () {
    test(
      'applies a dictionary from the frame after the one carrying it',
      () async {
        final incoming = StreamController<dynamic>(sync: true);
        addTearDown(incoming.close);
        final cache = DictionaryCache();
        final transport = Transport(
          () async => FakeWebSocketChannel(incoming.stream),
          TransportConfig(dictionaryCache: cache),
          ProtobufCommandEncoder(),
          ProtobufReplyDecoder(),
        );
        final pushes = <String>[];
        await transport.open((push, isPing) {
          if (push.hasPub()) pushes.add(utf8.decode(push.pub.data));
        }, onDone: (code, reason, reconnect) {});
        final connected = transport.sendMessage(
          protocol.ConnectRequest(),
          protocol.ConnectResult(),
        );
        protocol.Reply pub(String data) =>
            protocol.Reply()
              ..push =
                  (protocol.Push()
                    ..channel = 'prices'
                    ..pub = (protocol.Publication()..data = utf8.encode(data)));
        // A push in the same message as the connect reply is raw.
        incoming.add(
          encodeReplies([
            protocol.Reply()
              ..id = 1
              ..connect =
                  (protocol.ConnectResult()
                    ..flag = Int64(connectionFlagDictionaryCompression)
                    ..dict = deliveredDictionary(_dictionary)),
            pub('"a"'),
          ]),
        );
        await connected;
        incoming.add(compressedFrame(encodeReplies([pub('"b"')]), _dictionary));
        incoming.add([
          frameCodecRaw,
          ...encodeReplies([pub('"c"')]),
        ]);
        expect(pushes, ['"a"', '"b"', '"c"']);
        final stats = transport.dictionaryCompressionStats;
        expect(stats.accepted, isTrue);
        expect(stats.frames, 2);
        expect(cache.id, 'dict-1');
      },
    );
  });

  group('DictionaryCache', () {
    test('holds the latest dictionary and forgets only its own id', () {
      final cache = DictionaryCache();
      expect(cache.id, '');
      cache.put('a', [1]);
      cache.put('b', [2]);
      expect(cache.get('a'), isNull);
      expect(cache.get('b'), [2]);
      cache.forget('a');
      expect(cache.id, 'b');
      cache.forget('b');
      expect(cache.id, '');
      expect(cache.get('b'), isNull);
    });
  });

  group('Dictionary compression', () {
    late FakeCentrifugoServer server;
    late centrifuge.Client client;

    setUp(() async {
      server = FakeCentrifugoServer();
      await server.start();
      server.compressFrame = (frame) => compressedFrame(frame, _dictionary);
      // The dictionary is sent in full to a client that doesn't hold it, and
      // named alone to one that does.
      server.onCommand = (cmd) {
        if (!cmd.hasConnect()) return null;
        final result =
            protocol.ConnectResult()
              ..client = 'fake-client'
              ..flag = Int64(connectionFlagDictionaryCompression);
        result.subs['prices'] = protocol.SubscribeResult();
        result.dict =
            cmd.connect.dict == 'dict-1'
                ? (protocol.Dictionary()..id = 'dict-1')
                : deliveredDictionary(_dictionary);
        return protocol.Reply()
          ..id = cmd.id
          ..connect = result;
      };
    });

    tearDown(() async {
      await client.close();
      await server.stop();
    });

    test('advertises the capability and the profile', () async {
      server.onCommand = null;
      server.compressFrame = null;
      client = centrifuge.createClient(
        server.url,
        centrifuge.ClientConfig(profile: 'trading'),
      );
      await client.connect();
      final connect = server.received.first.connect;
      expect(connect.flag.toInt(), connectionFlagDictionaryCompression);
      expect(connect.profile, 'trading');
      expect(connect.hasDict(), isFalse);
      final stats = client.dictionaryCompressionStats();
      expect(stats.accepted, isFalse);
      expect(stats.active, isFalse);
    });

    test('decodes the frames after the connect reply', () async {
      client = centrifuge.createClient(server.url, centrifuge.ClientConfig());
      final pub = _next(client.publication);
      await client.connect();
      final data = utf8.encode('{"type":"quote","symbol":"BTC-USD"}');
      server.publish(channel: 'prices', data: data);
      expect((await pub).data, data);

      final stats = client.dictionaryCompressionStats();
      expect(stats.accepted, isTrue);
      expect(stats.active, isTrue);
      expect(stats.dictionaryId, 'dict-1');
      expect(stats.frames, 1);
      expect(
        stats.dictionaryBytes,
        deliveredDictionary(_dictionary).data.length,
      );
      expect(stats.bytesDecompressed, greaterThan(stats.bytesReceived));
      expect(stats.transportBytesReceived, greaterThan(stats.bytesReceived));
      expect(
        stats.bytesSaved,
        stats.bytesDecompressed - stats.bytesReceived - stats.dictionaryBytes,
      );
    });

    test('a returning client sends the id and gets no transfer', () async {
      client = centrifuge.createClient(
        server.url,
        centrifuge.ClientConfig(minReconnectDelay: Duration.zero),
      );
      await client.connect();
      final reconnected = _next(
        client.connected.where((_) => server.received.length > 1),
      );
      await server.closeConnection();
      await reconnected;
      final connects = server.received.where((c) => c.hasConnect()).toList();
      expect(connects.length, 2);
      expect(connects[1].connect.dict, 'dict-1');

      final pub = _next(client.publication);
      server.publish(channel: 'prices', data: utf8.encode('"after"'));
      expect(utf8.decode((await pub).data), '"after"');
      final stats = client.dictionaryCompressionStats();
      expect(stats.active, isTrue);
      expect(stats.dictionaryBytes, 0);
      expect(stats.frames, 1);
    });

    // While connecting, a dictionary the client can't use closes the
    // connection and starts the next attempt, which offers no dictionary: the
    // client never connects with it.
    Future<void> expectRetriedWithoutDictionary() async {
      var connected = false;
      client.connected.listen((_) => connected = true);
      unawaited(client.connect());
      await _until(
        () => server.received.where((c) => c.hasConnect()).length >= 2,
      );
      final connects = server.received.where((c) => c.hasConnect()).toList();
      expect(connects.last.connect.hasDict(), isFalse);
      expect(connected, isFalse);
      expect(client.state, centrifuge.State.connecting);
    }

    test('an id the client does not hold reconnects without it', () async {
      server.onCommand = (cmd) {
        if (!cmd.hasConnect()) return null;
        return protocol.Reply()
          ..id = cmd.id
          ..connect =
              (protocol.ConnectResult()
                ..client = 'fake-client'
                ..dict = (protocol.Dictionary()..id = 'never-sent'));
      };
      server.compressFrame = null;
      client = centrifuge.createClient(
        server.url,
        centrifuge.ClientConfig(minReconnectDelay: Duration.zero),
      );
      await expectRetriedWithoutDictionary();
    });

    test('content that does not inflate reconnects without it', () async {
      server.onCommand = (cmd) {
        if (!cmd.hasConnect()) return null;
        return protocol.Reply()
          ..id = cmd.id
          ..connect =
              (protocol.ConnectResult()
                ..client = 'fake-client'
                ..dict =
                    (protocol.Dictionary()
                      ..id = 'broken'
                      ..data = [0xff, 0xff, 0xff]));
      };
      server.compressFrame = null;
      client = centrifuge.createClient(
        server.url,
        centrifuge.ClientConfig(minReconnectDelay: Duration.zero),
      );
      await expectRetriedWithoutDictionary();
    });

    test('a frame that fails to decode forgets the dictionary', () async {
      client = centrifuge.createClient(
        server.url,
        centrifuge.ClientConfig(minReconnectDelay: Duration.zero),
      );
      await client.connect();
      final connecting = _next(client.connecting);
      server.sendBytes([frameCodecCompressed, 0xff, 0xff, 0xff]);
      final event = await connecting;
      expect(event.code, 2);
      expect(event.reason, 'frame decode error');
      await _until(
        () => server.received.where((c) => c.hasConnect()).length >= 2,
      );
      final connects = server.received.where((c) => c.hasConnect()).toList();
      expect(connects.last.connect.hasDict(), isFalse);
    });
  });
}

Future<void> _until(bool Function() condition) async {
  final deadline = DateTime.now().add(const Duration(seconds: 5));
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException('condition not met');
    }
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
}
