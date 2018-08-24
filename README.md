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
Publish:
```dart
final output = jsonEncode({'input': message});
final data = utf8.encode(output);
await subscription.publish(data);
```


## Checklist:

- [ ] connect to server using JSON protocol format
- [x] connect to server using Protobuf protocol format
- [ ] support automatic reconnect in case of errors, network problems etc
- [x] subscribe on channel and handle asynchronous Publications
- [x] handle Join and Leave messages
- [x] handle unsubscribe notifications
- [ ] send asynchronous messages to server
- [x] handle asynchronous messages from server
- [ ] send RPC commands
- [ ] connect with JWT
- [ ] subscribe to private channels with JWT
- [ ] call publish, presence, presence_stats, history methods.
- [ ] support connection JWT refresh
- [ ] support private channel subscription JWT refresh
- [ ] ping/pong to find broken connection
- [ ] support message recovery mechanism

## Author

German Saprykin, saprykin.h@gmail.com
