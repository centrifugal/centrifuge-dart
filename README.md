[![Build Status](https://travis-ci.org/centrifugal/centrifuge-dart.svg?branch=master)](https://travis-ci.org/centrifugal/centrifuge-dart)
[![Coverage Status](https://coveralls.io/repos/github/centrifugal/centrifuge-dart/badge.svg?branch=master)](https://coveralls.io/github/centrifugal/centrifuge-dart?branch=master)

## Example

Examples:
* `example\flutter_app` simple chat application
* `example\console` simple console application 

## Usage

Create client:

```dart
import 'package:centrifuge/centrifuge.dart' as centrifuge;

final client = centrifuge.createClient("ws://localhost:8000/connection/websocket?format=protobuf");
```

Note that `?format=protobuf` is required because this library only works with Protobuf protocol.

Connect to server:
```dart
client.connect();
```
Subscribe to channel:
```dart
final subscription = client.getSubscription(channel);

subscription.publishStream.listen(onEvent);
subscription.joinStream.listen(onEvent);  
subscription.leaveStream.listen(onEvent);
subscription.subscribeSuccessStream.listen(onEvent);
subscription.subscribeErrorStream.listen(onEvent);
subscription.unsubscribeStream.listen(onEvent);

subscription.subscribe();
```

Publish:
```dart
final output = jsonEncode({'input': message});
final data = utf8.encode(output);
await subscription.publish(data);
```

## Feature matrix

- [ ] connect to server using JSON protocol format
- [x] connect to server using Protobuf protocol format
- [x] connect with JWT
- [x] connect with custom header
- [x] automatic reconnect in case of errors, network problems etc
- [x] exponential backoff for reconnect
- [x] connect and disconnect events
- [x] handle disconnect reason
- [x] subscribe on channel and handle asynchronous Publications
- [x] handle Join and Leave messages
- [x] handle Unsubscribe notifications
- [ ] reconnect on subscribe timeout
- [x] publish method of Subscription
- [x] unsubscribe method of Subscription
- [ ] presence method of Subscription
- [ ] presence stats method of Subscription
- [x] history method of Subscription
- [ ] send asynchronous messages to server
- [x] handle asynchronous messages from server
- [x] send RPC commands
- [x] publish to channel without being subscribed
- [x] subscribe to private channels with JWT
- [ ] connection JWT refresh
- [ ] private channel subscription JWT refresh
- [ ] handle connection expired error
- [ ] handle subscription expired error
- [x] ping/pong to find broken connection
- [ ] message recovery mechanism

## Author

German Saprykin, saprykin.h@gmail.com
