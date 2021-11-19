import 'dart:async';
import 'dart:convert';

import 'package:centrifuge/centrifuge.dart';
import 'package:centrifuge/src/client.dart';
import 'package:centrifuge/src/proto/client.pb.dart' as protocol;
import 'package:test/test.dart';

import 'src/utils.dart';

void main() {
  final url = 'test url';

  late Client client;
  late MockTransport transport;
  late ClientConfig clientConfig;
  WaitRetry? retry;

  final subscription = (String name) => client.getSubscription(name);

  setUp(() {
    transport = MockTransport();
    clientConfig = ClientConfig(retry: (count) => retry?.call(count));

    client = ClientImpl(
      url,
      clientConfig,
      ({required url, required config}) => transport
        ..url = url
        ..transportConfig = config,
    );
  });

  group('Subscription', () {
    test('getSubscription returns valid subscriptions', () {
      final s1 = subscription('some_channel');
      final s2 = subscription('some_channel');
      final s3 = subscription('some_another_channel');

      expect(s1, same(s2));
      expect(s1.channel, 'some_channel');

      expect(s3, isNot(same(s1)));
      expect(s3.channel, 'some_another_channel');
    });

    test('removeSubscription works correctly', () {
      final s1 = subscription('some_channel');
      expect(true, client.hasSubscription(s1.channel));
      client.removeSubscription(s1);
      expect(false, client.hasSubscription(s1.channel));
    });
  });

  group('Connection', () {
    test('connect uses correct url and headers', () async {
      client.connect();

      transport.completeOpen();

      expect(transport.url, equals(url));
      expect(transport.transportConfig!.headers, same(clientConfig.headers));
    });
    test('connect sends request with data and token', () async {
      client.setToken('test token');
      client.setConnectData(utf8.encode('test connect data'));

      client.connect();

      transport.completeOpen();

      final request = transport
          .sendListLast<protocol.ConnectRequest, protocol.ConnectResult>()
          .request;

      expect(request.token, equals('test token'));
      expect(utf8.decode(request.data), equals('test connect data'));
    });

    test('connect sends request and emits connect event', () async {
      final eventFuture = client.connectStream.first;

      final connectFinish = client.connectStream.first;
      client.connect();
      transport.completeOpen();

      final send = transport
          .sendListLast<protocol.ConnectRequest, protocol.ConnectResult>();
      send.result
        ..client = 'mock client'
        ..version = '0.0.0'
        ..data = utf8.encode('test data');
      send.complete();

      await connectFinish;

      final event = await eventFuture;

      expect(event.version, equals('0.0.0'));
      expect(event.client, equals('mock client'));
      expect(utf8.decode(event.data), equals('test data'));
    });
  });

  group('Connected client', () {
    setUp(() {
      client.connect();
      transport.completeOpen();
    });

    test('publish sends correct data', () async {
      client.publish('test channel', utf8.encode('test message'));

      final publish = transport
          .sendListLast<protocol.PublishRequest, protocol.PublishResult>()
          .request;
      expect(publish.channel, equals('test channel'));
      expect(utf8.decode(publish.data), equals('test message'));
    });

    test('rpc sends correct data', () async {
      client.rpc("test", utf8.encode('test rpc message'));

      final rpc = transport
          .sendListLast<protocol.RPCRequest, protocol.RPCResult>()
          .request;
      expect(utf8.decode(rpc.data), equals('test rpc message'));
    });
  });

  group('Disconnect', () {
    setUp(() {
      client.connect();
      transport.completeOpen();
      transport
          .sendListLast<protocol.ConnectRequest, protocol.ConnectResult>()
          .complete();
    });

    test('socket closing triggers the corresponding events', () async {
      final disconnectFuture = client.disconnectStream.first;

      transport.onDone!('test reason', true);

      final disconnect = await disconnectFuture;

      expect(disconnect.reason, equals('test reason'));
      expect(disconnect.shouldReconnect, isTrue);
    });

    test('socket error triggers the corresponding events', () async {
      final disconnectFuture = client.disconnectStream.first;

      transport.onError!('test error');

      final disconnect = await disconnectFuture;

      expect(disconnect.reason, equals('connection closed'));
      expect(disconnect.shouldReconnect, isTrue);
    });

    test('client does not reconnect if reconnect = false', () async {
      bool retryCalled = false;

      retry = (_) async {
        retryCalled = true;
      };

      for (var i = 1; i < 20; i++) {
        transport.onDone!('test reason', false);
        expect(retryCalled, isFalse);
      }
    });

    test('client reconnects on error', () async {
      late Completer<void> retryCompleter;
      int? count;

      retry = (c) {
        count = c;
        return retryCompleter.future;
      };

      for (var i = 1; i < 20; i++) {
        final connectFuture = client.connectStream.first;

        retryCompleter = Completer<void>.sync();
        transport.onError!('test error');

        expect(count, 1);
        retryCompleter.complete();
        transport.completeOpen();
        transport
            .sendListLast<protocol.ConnectRequest, protocol.ConnectResult>()
            .complete();
        expect(connectFuture, completion(isNotNull));
      }
    });

    test('client doesn\'t reconnect on disconnect()', () async {
      final expectedMessages = transport.sendList.length;

      retry = (_) => fail('retry shouldn\'t be called');

      client.disconnect();
      transport.onDone!("", true);

      expect(transport.sendList, hasLength(expectedMessages));
    });

    test('client reconnect increases retry count', () async {
      Completer<void> retryCompleter = Completer<void>.sync();
      int? count;

      retry = (c) {
        count = c;
        return retryCompleter.future;
      };

      transport.onError!('test error');

      for (var i = 1; i < 20; i++) {
        expect(count, i);
        retryCompleter.complete();

        retryCompleter = Completer<void>.sync();
        transport.completeOpenError('test server not available');
      }
    });

    test(
        'client reconnect sends disconnect and unsubscribe events only once for the first error',
        () async {
      var countOneChannelSubscribe = 0;
      var countOneChannelUnsubscribe = 0;
      var countTwoChannelSubscribe = 0;
      var countTwoChannelUnsubscribe = 0;
      var countClientConnect = 0;
      var countClientDisconnect = 0;

      subscription('test one').subscribe();

      subscription('test one')
          .unsubscribeStream
          .listen((_) => countOneChannelUnsubscribe += 1);
      subscription('test two')
          .unsubscribeStream
          .listen((_) => countTwoChannelUnsubscribe += 1);

      subscription('test one')
          .subscribeSuccessStream
          .listen((_) => countOneChannelSubscribe += 1);
      subscription('test two')
          .subscribeSuccessStream
          .listen((_) => countTwoChannelSubscribe += 1);

      client.connectStream.listen((_) => countClientConnect += 1);
      client.disconnectStream.listen((_) => countClientDisconnect += 1);

      Completer<void> retryCompleter = Completer<void>.sync();
      retry = (c) => retryCompleter.future;

      transport.onError!('test error');

      for (var i = 1; i < 20; i++) {
        retryCompleter.complete();
        retryCompleter = Completer<void>.sync();
        transport.completeOpenError('test server not available');
      }

      await Future<void>.delayed(Duration(milliseconds: 1));

      expect(countClientConnect, 0);
      expect(countClientDisconnect, 1);

      expect(countOneChannelSubscribe, 0);
      expect(countOneChannelUnsubscribe, 0);

      expect(countTwoChannelSubscribe, 0);
      expect(countTwoChannelUnsubscribe, 0);
    });

    test(
        'client reconnect notifies client and subscription every success and error',
        () async {
      var countOneChannelSubscribe = 0;
      var countOneChannelUnsubscribe = 0;
      var countTwoChannelSubscribe = 0;
      var countTwoChannelUnsubscribe = 0;
      var countClientConnect = 0;
      var countClientDisconnect = 0;

      subscription('test one').subscribe();

      subscription('test one')
          .subscribeSuccessStream
          .listen((_) => countOneChannelSubscribe += 1);
      subscription('test one')
          .unsubscribeStream
          .listen((_) => countOneChannelUnsubscribe += 1);

      subscription('test two')
          .subscribeSuccessStream
          .listen((_) => countTwoChannelSubscribe += 1);
      subscription('test two')
          .unsubscribeStream
          .listen((_) => countTwoChannelUnsubscribe += 1);

      client.connectStream.listen((_) => countClientConnect += 1);
      client.disconnectStream.listen((_) => countClientDisconnect += 1);

      late Completer<void> retryCompleter;

      retry = (c) => retryCompleter.future;

      for (var i = 0; i < 20; i++) {
        final connectFuture = client.connectStream.first;

        retryCompleter = Completer<void>.sync();

        final disconnect = client.disconnectStream.first;
        transport.onError!('test error');
        await disconnect;

        retryCompleter.complete();
        transport.completeOpen();
        transport
            .sendListLast<protocol.ConnectRequest, protocol.ConnectResult>()
            .complete();
        expect(connectFuture, completion(isNotNull));

        transport.sendList
            .where((t) => t
                is Triplet<protocol.SubscribeRequest, protocol.SubscribeResult>)
            .where((t) => !t.completer.isCompleted)
            .forEach((t) => t.complete());
      }

      await Future<void>.delayed(Duration(milliseconds: 1));

      expect(countClientConnect, 20);
      expect(countClientDisconnect, 20);

      expect(countOneChannelSubscribe, 20);
      expect(countOneChannelUnsubscribe, 19);

      expect(countTwoChannelSubscribe, 0);
      expect(countTwoChannelUnsubscribe, 0);
    });
  });
}
