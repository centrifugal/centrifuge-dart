import 'dart:async';
import 'dart:convert';

import 'package:centrifuge/src/proto/client.pb.dart' as protocol;
import 'package:centrifuge/src/subscription.dart';
import 'package:centrifuge/src/events.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;

import 'src/utils.dart';

void main() {
  late MockClient client;
  late SubscriptionImpl subscription;
  final channel = 'test channel';
  final token = 'test channel token';

  setUp(() {
    client = MockClient();
    client.connected = true;
    subscription = SubscriptionImpl(channel, client);
  });

  test('subscribe sends request and triggers success event', () async {
    final subscribeSuccess = subscription.subscribeSuccessStream.first;

    when(client.getToken(channel)).thenAnswer((_) => Future.value(token));

    when(
      client.sendMessage(
        protocol.SubscribeRequest()
          ..channel = channel
          ..token = token,
        protocol.SubscribeResult(),
      ),
    ).thenAnswer((_) async => protocol.SubscribeResult()..recovered = true);

    subscription.subscribe();

    final event = await subscribeSuccess;

    expect(event.isRecovered, isTrue);
    expect(event.isResubscribed, isFalse);
  });

  test('subscription resubscribes if was subscribed', () async {
    final subscribeSuccess = () => subscription.subscribeSuccessStream.first;
    final request = protocol.SubscribeRequest()
      ..channel = channel
      ..token = token;
    final result = protocol.SubscribeResult();

    when(client.getToken(channel)).thenAnswer((_) => Future.value(token));

    when(
      client.sendMessage(request, result),
    ).thenAnswer((_) async => protocol.SubscribeResult()..recovered = true);

    subscription.subscribe();

    await subscribeSuccess();

    subscription.resubscribeOnConnect();

    await subscribeSuccess();

    verify(client
            .sendMessage<protocol.SubscribeRequest, protocol.SubscribeResult>(
                request, result))
        .called(2);
  });

  test('subscription doesn\'t resubscribe if wasn\'t subscribed', () async {
    subscription.resubscribeOnConnect();

    verifyNoMoreInteractions(client);
  });

  test('subscription unsubscribes if wasn subscribed', () async {
    final subscribeSuccess = subscription.subscribeSuccessStream.first;
    final unsubscribe = subscription.unsubscribeStream.first;

    when(client.getToken(channel)).thenAnswer((_) => Future.value(token));

    when(
      client.sendMessage(
        protocol.SubscribeRequest()
          ..channel = channel
          ..token = token,
        protocol.SubscribeResult(),
      ),
    ).thenAnswer((_) async => protocol.SubscribeResult()..recovered = true);

    when(
      client.sendMessage(
        protocol.UnsubscribeRequest()..channel = channel,
        protocol.UnsubscribeResult(),
      ),
    ).thenAnswer((_) async => protocol.UnsubscribeResult());

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

    subscription.unsubscribeOnDisconnect();

    expect(unsubscribe, completion(isNotNull));
  });

  test('subscription doesn\'t send event if wasn\'t subscribed', () async {
    final unsubscribe = subscription.unsubscribeStream.first;

    subscription.unsubscribeOnDisconnect();

    expect(unsubscribe, doesNotComplete);
  });

  test('success subscribe triggers publish events', () async {
    final publish = subscription.publishStream.take(2).toList();

    when(client.getToken(channel)).thenAnswer((_) => Future.value(token));

    when(
      client.sendMessage(
        protocol.SubscribeRequest()
          ..channel = channel
          ..token = token,
        protocol.SubscribeResult(),
      ),
    ).thenAnswer(
      (_) async => protocol.SubscribeResult()
        ..recovered = true
        ..publications.addAll(
          [
            protocol.Publication()..data = utf8.encode('test message 1'),
            protocol.Publication()..data = utf8.encode('test message 2'),
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
    when(client.getToken(channel)).thenAnswer((_) => Future.value(token));

    subscription.subscribe();

    when(
      client.sendMessage(
        protocol.SubscribeRequest()
          ..channel = channel
          ..token = token,
        protocol.SubscribeResult(),
      ),
    ).thenAnswer((_) => Future.error('test error'));

    final error = await errorFuture;
    expect(error.message, 'test error');
  });

  test('history sends correct data', () async {
    when(
      client.history(
        channel,
      ),
    ).thenAnswer((_) async => HistoryResult([], $fixnum.Int64(0), "")
      ..publications.addAll(
        [
          Publication(utf8.encode('test history 1'), $fixnum.Int64(0), null),
          Publication(utf8.encode('test history 2'), $fixnum.Int64(0), null),
        ],
      ));

    final historyFuture = subscription.history();

    final result = await historyFuture;

    expect(result.publications, hasLength(equals(2)));
    expect(utf8.decode(result.publications[0].data), equals('test history 1'));
    expect(utf8.decode(result.publications[1].data), equals('test history 2'));
  });
}
