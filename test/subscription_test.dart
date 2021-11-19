import 'dart:async';
import 'dart:convert';

import 'package:centrifuge/src/events.dart';
import 'package:centrifuge/src/proto/client.pb.dart' as protocol;
import 'package:centrifuge/src/subscription.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

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
      client.sendSubscribe(
        channel,
        token,
      ),
    ).thenAnswer((_) async => protocol.SubscribeResult()..recovered = true);

    subscription.subscribe();

    final event = await subscribeSuccess;

    expect(event.isRecovered, isTrue);
    expect(event.isResubscribed, isFalse);
  });

  test('subscription resubscribes if was subscribed', () async {
    var numOnSubscribeSuccessCalls = 0;
    var completer = new Completer<void>();
    final onSubscriptionEvent = (dynamic event) {
      numOnSubscribeSuccessCalls++;
      completer.complete();
      completer = new Completer<void>();
    };
    subscription.subscribeSuccessStream.listen(onSubscriptionEvent);

    when(client.getToken(channel)).thenAnswer((_) => Future.value(token));

    when(
      client.sendSubscribe(channel, token),
    ).thenAnswer((_) async => protocol.SubscribeResult()..recovered = true);

    when(
      client.sendUnsubscribe(channel),
    ).thenAnswer((_) async => protocol.UnsubscribeResult());

    await subscription.subscribe();
    await completer.future;
    await subscription.unsubscribe();
    await subscription.subscribe();
    await completer.future;

    expect(numOnSubscribeSuccessCalls, 2);
  });

  test('subscription doesn\'t resubscribe if wasn\'t subscribed', () async {
    subscription.resubscribeOnConnect();

    verifyNoMoreInteractions(client);
  });

  test('subscription unsubscribes if was not subscribed', () async {
    final subscribeSuccess = subscription.subscribeSuccessStream.first;
    final unsubscribe = subscription.unsubscribeStream.first;

    when(client.getToken(channel)).thenAnswer((_) => Future.value(token));

    when(
      client.sendSubscribe(
        channel,
        token,
      ),
    ).thenAnswer((_) async => protocol.SubscribeResult()..recovered = true);

    when(
      client.sendUnsubscribe(channel),
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

  test('subscription doesn\'t send event if was subscribing', () async {
    final unsubscribe = subscription.unsubscribeStream.first;
    subscription.subscribe();

    subscription.unsubscribeOnDisconnect();

    expect(unsubscribe, doesNotComplete);
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
      client.sendSubscribe(
        channel,
        token,
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
      client.sendSubscribe(
        channel,
        token,
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
