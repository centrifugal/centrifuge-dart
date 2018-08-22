import 'dart:async';

import 'package:centrifuge/src/client.dart';
import 'package:centrifuge/src/proto/client.pb.dart';
import 'package:centrifuge/src/subscription.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'src/utils.dart';

void main() {
  ClientImpl client;
  MockTransport transport;

  setUp(() {
    transport = MockTransport();
    client = ClientImpl(transport);
  });

  group('Not connected', () {
    test('Client.connect sends ConnectRequest', () async {
      ConnectEvent connect;
      client.connectStream.listen((c) => connect = c);

      when(transport.send(ConnectRequest(), ConnectResult())).thenAnswer(
        (_) => Future.value(ConnectResult()
          ..client = 'client1'
          ..version = 'v0.0.0'),
      );

      await client.connect();

      verify(transport.open(
        any,
        onError: anyNamed('onError'),
        onDone: anyNamed('onDone'),
      ));
      expect(connect, isNotNull);
      expect(connect.client, 'client1');
      expect(connect.version, 'v0.0.0');
    });
  });
  group('Connected client', () {
    setUp(() async {
      when(transport.send(ConnectRequest(), ConnectResult())).thenAnswer(
        (_) => Future.value(ConnectResult()
          ..client = 'client1'
          ..version = 'v0.0.0'),
      );
      await client.connect();
    });

    test('Client.disconnect closes transport', () async {
      await client.disconnect();

      verify(transport.close());
    });

    test('Client.publish sends DisconnectEvent', () async {
      await client.publish('any channel', [1, 2, 3]);

      verify(transport.send(
        PublishRequest()
          ..channel = 'any channel'
          ..data = [1, 2, 3],
        PublishResult(),
      ));
    });

    test('Client.sendSubscribe sends SubscribeRequest', () async {
      client.sendSubscribe('any channel');

      verify(transport.send(
          SubscribeRequest()..channel = 'any channel', SubscribeResult()));
    });

    test('Client.sendUnsubscribe sends SubscribeRequest', () async {
      client.sendUnsubscribe('any channel');

      verify(transport.send(
          UnsubscribeRequest()..channel = 'any channel', UnsubscribeResult()));
    });

    test('Client.subscribe sends SubscribeSuccessEvent', () async {
      SubscribeSuccessEvent subscribeSuccessEvent;
      final completer = Completer<SubscribeResult>.sync();

      when(transport.send(ConnectRequest(), ConnectResult()))
          .thenAnswer((_) => Future.value(ConnectResult()));
      when(transport.send(
              SubscribeRequest()..channel = 'any channel', SubscribeResult()))
          .thenAnswer((_) => completer.future);
      await client.connect();

      final subscription = client.subscribe('any channel');
      subscription.subscribeSuccessStream
          .listen((e) => subscribeSuccessEvent = e);

      completer.complete(SubscribeResult());

      expect(subscribeSuccessEvent, isNotNull);
    });

    test('Client unsubscribes subscriptions on onDone', () async {
      UnsubscribeEvent unsubscribeEvent;

      final subscription = client.subscribe('any channel');
      subscription.unsubscribeStream.listen((e) => unsubscribeEvent = e);

      transport.triggerOnDone();

      expect(unsubscribeEvent, isNotNull);
    });

    test('Client sends DisconnectEvent on onDone', () async {
      DisconnectEvent disconnectEvent;
      client.disconnectStream.listen((e) => disconnectEvent = e);

      transport.triggerOnDone();

      expect(disconnectEvent, isNotNull);
    });
  });
}
