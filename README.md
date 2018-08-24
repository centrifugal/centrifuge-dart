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

## Author

German Saprykin, saprykin.h@gmail.com
