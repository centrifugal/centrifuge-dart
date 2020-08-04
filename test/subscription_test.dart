import 'dart:async';
import 'dart:convert';

import 'package:centrifuge/src/proto/client.pb.dart';
import 'package:centrifuge/src/subscription.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'src/utils.dart';

void main() {
  MockClient client;
  SubscriptionImpl subscription;
  final channel = 'test channel';

  setUp(() {
    client = MockClient();
    client.connected = true;
    subscription = SubscriptionImpl(channel, client);
  });

  test('subscribe sends request and triggers success event', () async {
    final subscribeSuccess = subscription.subscribeSuccessStream.first;

    when(
      client.sendMessage(
        SubscribeRequest()
          ..channel = channel
          ..token = '',
        SubscribeResult(),
      ),
    ).thenAnswer((_) async => SubscribeResult()..recovered = true);

    subscription.subscribe();

    final event = await subscribeSuccess;

    expect(event.isRecovered, isTrue);
    expect(event.isResubscribed, isFalse);
  });

  test('subscription resubscribes if was subscribed', () async {
    final subscribeSuccess = () => subscription.subscribeSuccessStream.first;

    when(
      client.sendMessage(
        SubscribeRequest()
          ..channel = channel
          ..token = '',
        SubscribeResult(),
      ),
    ).thenAnswer((_) async => SubscribeResult()..recovered = true);

    subscription.subscribe();

    await subscribeSuccess();

    subscription.resubscribeIfNeeded();

    await subscribeSuccess();

    verify(client.sendMessage(any, any)).called(2);
  });

  test('subscription doesn\'t resubscribe if wasn\'t subscribed', () async {
    subscription.resubscribeIfNeeded();

    verifyNoMoreInteractions(client);
  });

  test('subscription unsubscribes if wasn subscribed', () async {
    final subscribeSuccess = subscription.subscribeSuccessStream.first;
    final unsubscribe = subscription.unsubscribeStream.first;

    when(
      client.sendMessage(
        SubscribeRequest()
          ..channel = channel
          ..token = '',
        SubscribeResult(),
      ),
    ).thenAnswer((_) async => SubscribeResult()..recovered = true);

    when(
      client.sendMessage(
        UnsubscribeRequest()..channel = channel,
        UnsubscribeResult(),
      ),
    ).thenAnswer((_) async => UnsubscribeResult());

    subscription.subscribe();

    await subscribeSuccess;

    subscription.unsubscribe();

    expect(unsubscribe, completion(isNotNull));
  });

  test('subscription doesn\'t unsubscribe if wasn\'t subscribed', () async {
    subscription.unsubscribe();

    verifyNoMoreInteractions(client);
  });

  test('subscription sends event if was subscribed', () async {
    final unsubscribe = subscription.unsubscribeStream.first;
    subscription.subscribe();

    subscription.sendUnsubscribeEventIfNeeded();

    expect(unsubscribe, completion(isNotNull));
  });

  test('subscription doesn\'t send event if wasn\'t subscribed', () async {
    final unsubscribe = subscription.unsubscribeStream.first;

    subscription.sendUnsubscribeEventIfNeeded();

    expect(unsubscribe, doesNotComplete);
  });

  test('success subscribe triggers publish events', () async {
    final publish = subscription.publishStream.take(2).toList();

    when(
      client.sendMessage(
        SubscribeRequest()
          ..channel = channel
          ..token = '',
        SubscribeResult(),
      ),
    ).thenAnswer(
      (_) async => SubscribeResult()
        ..recovered = true
        ..publications.addAll(
          [
            Publication()..data = utf8.encode('test message 1'),
            Publication()..data = utf8.encode('test message 2'),
          ],
        ),
    );

    subscription.subscribe();

    final events = await publish;

    expect(utf8.decode(events[0].data), equals('test message 1'));
    expect(utf8.decode(events[1].data), equals('test message 2'));
  });

  test('failed subscribe triggers error events', () async {
    final errorFuture = subscription.subscribeErrorStream.first;

    subscription.subscribe();

    when(
      client.sendMessage(
        SubscribeRequest()
          ..channel = channel
          ..token = '',
        SubscribeResult(),
      ),
    ).thenAnswer((_) => Future.error('test error'));

    final error = await errorFuture;
    expect(error.message, 'test error');
  });

  test('history sends correct data', () async {
    when(
      client.sendMessage(
        HistoryRequest()..channel = channel,
        HistoryResult(),
      ),
    ).thenAnswer((_) async => HistoryResult()
      ..publications.addAll(
        [
          Publication()..data = utf8.encode('test history 1'),
          Publication()..data = utf8.encode('test history 2')
        ],
      ));

    final historyFuture = subscription.history();

    final events = await historyFuture;

    expect(events, hasLength(equals(2)));
    expect(utf8.decode(events[0].data), equals('test history 1'));
    expect(utf8.decode(events[1].data), equals('test history 2'));
  });
}
