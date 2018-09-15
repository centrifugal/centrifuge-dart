[![Build Status](https://travis-ci.org/centrifugal/centrifuge-dart.svg?branch=master)](https://travis-ci.org/centrifugal/centrifuge-dart)


## Example

Examples:
* `example\flutter_app` simple chat application
* `example\console` simple console application 

## Usage

Create client:

```dart
import 'package:centrifuge/centrifuge.dart' as centrifuge;

final client = centrifuge.createClient(url);
```
Connect to server:
```dart
await client.connect();
```
Subscribe to channel:
```dart
final subscription = client.subscribe(channel);

subscription.publishStream.listen(onEvent);
subscription.joinStream.listen(onEvent);
subscription.leaveStream.listen(onEvent);

subscription.subscribeSuccessStream.listen(onEvent);
subscription.subscribeErrorStream.listen(onEvent);
subscription.unsubscribeStream.listen(onEvent);
```
Subscribe to private channel:
```dart
final privateSubscription = client.subscribe(channel, token: 'token');
```
Publish:
```dart
final output = jsonEncode({'input': message});
final data = utf8.encode(output);
await subscription.publish(data);
```


## Checklist:

- [ ] connect to server using JSON protocol format
- [x] connect to server using Protobuf protocol format
- [x] connect with JWT
- [ ] connect with custom header
- [ ] support automatic reconnect in case of errors, network problems etc
- [x] connect and disconnect events
- [ ] handle disconnect reason
- [x] subscribe on channel and handle asynchronous Publications
- [x] handle Join and Leave messages
- [x] handle unsubscribe notifications
- [ ] handle subscribe error
- [ ] support publish, presence, presence stats and history methods
- [ ] send asynchronous messages to server
- [x] handle asynchronous messages from server
- [ ] send RPC commands
- [x] subscribe to private channels with JWT
- [ ] support connection JWT refresh
- [ ] support private channel subscription JWT refresh
- [ ] ping/pong to find broken connection
- [ ] support message recovery mechanism

## Author

German Saprykin, saprykin.h@gmail.com
