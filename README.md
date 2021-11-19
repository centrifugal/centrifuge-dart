[![Build Status](https://travis-ci.org/centrifugal/centrifuge-dart.svg?branch=master)](https://travis-ci.org/centrifugal/centrifuge-dart)
[![Coverage Status](https://coveralls.io/repos/github/centrifugal/centrifuge-dart/badge.svg?branch=master)](https://coveralls.io/github/centrifugal/centrifuge-dart?branch=master)

This repo contains a Dart connector library to communicate with Centrifugo server or a server based on Centrifuge library for Go language. This client uses WebSocket transport with binary Protobuf protocol format for Centrifuge protocol message encoding. See feature matrix below to find out which protocol features are supported here at the moment.

## Example

* `example\flutter_app` simple chat application
* `example\chat_app` one more chat example
* `example\console` simple console application
* `example\console_server_subs` demonstrates working with server-side subscriptions

## Usage

Create a client instance:

```dart
import 'package:centrifuge/centrifuge.dart' as centrifuge;

final client = centrifuge.createClient("ws://localhost:8000/connection/websocket?format=protobuf");
```

**Note that using** `?format=protobuf` **is required for Centrifugo < v3 and can be skipped for later versions**.

Centrifuge-dart uses binary Protobuf protocol internally but nothing stops you from sending JSON-encoded data over it. Our examples demonstrate this.

Connect to a server:

```dart
await client.connect();
```

To handle connect and disconnect events you can listen to `connectStream` and `disconnectStream`:

```dart
client.connectStream.listen(onEvent);
client.disconnectStream.listen(onEvent);
await client.connect();
```

Connect and disconnect events can happen many times throughout client lifetime.

Subscribe to a channel:

```dart
final subscription = client.getSubscription(channel);

subscription.publishStream.listen(onEvent);
subscription.joinStream.listen(onEvent);  
subscription.leaveStream.listen(onEvent);
subscription.subscribeSuccessStream.listen(onEvent);
subscription.subscribeErrorStream.listen(onEvent);
subscription.unsubscribeStream.listen(onEvent);

await subscription.subscribe();
```

Publish to a channel:

```dart
final data = utf8.encode(jsonEncode({'input': message}));
await subscription.publish(data);
```

When using server-side subscriptions you don't need to create Subscription instances, just set appropriate event handlers on `Client` instance:

```dart
client.connectStream.listen(onEvent);
client.disconnectStream.listen(onEvent);
client.subscribeStream.listen(onEvent);
client.publishStream.listen(onEvent);
await client.connect();
```

## Usage in background

When mobile application goes to background there are many OS-specific limitations for established persistent connections. Thus in most cases you need to disconnect from a server when app moves to background and connect again when app goes to foreground.

## Feature matrix

- [ ] connect to server using JSON protocol format
- [x] connect to server using Protobuf protocol format
- [x] connect with token (JWT)
- [x] connect with custom header
- [x] automatic reconnect in case of errors, network problems etc
- [x] exponential backoff for reconnect
- [x] connect and disconnect events
- [x] handle disconnect reason
- [x] subscribe on channel and handle asynchronous Publications
- [x] handle Join and Leave messages
- [x] handle Unsubscribe notifications
- [x] reconnect on subscribe timeout
- [x] publish method of Subscription
- [x] unsubscribe method of Subscription
- [x] presence method of Subscription
- [x] presence stats method of Subscription
- [x] history method of Subscription
- [x] top-level publish method
- [x] top-level presence method
- [x] top-level presence stats method
- [x] top-level history method
- [x] send asynchronous messages to server
- [x] handle asynchronous messages from server
- [x] send RPC commands
- [x] subscribe to private channels with token (JWT)
- [ ] connection JWT refresh
- [ ] private channel subscription token (JWT) refresh
- [ ] handle connection expired error
- [ ] handle subscription expired error
- [x] ping/pong to find broken connection
- [ ] message recovery mechanism for client-side subscriptions
- [x] server-side subscriptions
- [x] message recovery mechanism for server-side subscriptions
- [x] history stream pagination
- [ ] subscribe from the known StreamPosition

## Instructions for maintainers/contributors

### How to update protobuf definitions

1) Install `protoc` compiler
2) Install `protoc_plugin` https://pub.dev/packages/protoc_plugin (`dart pub global activate protoc_plugin`)
3) cd `lib/src/proto` and run `protoc --dart_out=. -I . client.proto`
4) cd to root and run `dartfmt -w lib/ test/` (install dartfmt with `dart pub global activate dart_style`)

### How to release

1) Update changelog
2) Bump version in `pubspec.yaml`, push, create new tag
3) `pub publish`

## Author

German Saprykin, saprykin.h@gmail.com
