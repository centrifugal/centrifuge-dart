import 'dart:convert';

import 'package:centrifuge/centrifuge.dart';
import 'package:centrifuge/src/proto/client.pb.dart';
import 'package:test/test.dart';

import 'src/utils.dart';

void main() {
  final url = 'test url';

  Client client;
  MockTransport transport;
  ClientConfig config;

  setUp(() {
    transport = MockTransport();
    config = ClientConfig();

    client = Client(
        url,
        config,
        ({url, headers}) => transport
          ..url = url
          ..headers = headers);
  });

  group('Subscription', () {
    test('getSubscription returns valid subscriptions', () {
      final s1 = client.getSubscription('some_channel');
      final s2 = client.getSubscription('some_channel');
      final s3 = client.getSubscription('some_another_channel');

      expect(s1, same(s2));
      expect(s1.channel, 'some_channel');

      expect(s3, isNot(same(s1)));
      expect(s3.channel, 'some_another_channel');
    });
  });

  group('Connection', () {
    test('connect uses correct url and headers', () async {
      client.connect();

      transport.completeOpen();

      expect(transport.url, equals(url));
      expect(transport.headers, same(config.headers));
    });
    test('connect sends request with data and token', () async {
      client.setToken('test token');
      client.setConnectData(utf8.encode('test connect data'));

      client.connect();

      transport.completeOpen();

      final request =
          transport.sendListLast<ConnectRequest, ConnectResult>().request;

      expect(request.token, equals('test token'));
      expect(utf8.decode(request.data), equals('test connect data'));
    });

    test('connect sends request and emits connect event', () async {
      final eventFuture = client.connectStream.first;

      final connectFinish = client.connect();
      transport.completeOpen();

      final send = transport.sendListLast<ConnectRequest, ConnectResult>();
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
}
