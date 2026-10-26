Websocket client for [Centrifugo](https://github.com/centrifugal/centrifugo) server and [Centrifuge](https://github.com/centrifugal/centrifuge) library. 

Since there is no v1 release yet, patch version updates only contain backwards compatible changes, minor version updates can have backwards incompatible API changes.

Check out [client SDK API specification](https://centrifugal.dev/docs/transports/client_api) to learn how this SDK behaves. It's recommended to read that before starting to work with this SDK as the spec covers common SDK behavior - describes client and subscription state transitions, main options and methods. Also check out examples folder.

The features implemented by this SDK can be found in [SDK feature matrix](https://centrifugal.dev/docs/transports/client_sdk#sdk-feature-matrix).

Note that custom WebSocket connection Upgrade headers are sent natively on platforms that support `dart:io` and in web context headers are sent using Centrifugo v6 [Headers Emulation](https://centrifugal.dev/blog/2025/01/16/centrifugo-v6-released#headers-emulation) feature.

> **The latest `centrifuge-dart` is compatible with [Centrifugo](https://github.com/centrifugal/centrifugo) server v6, v5 and v4 and [Centrifuge](https://github.com/centrifugal/centrifuge) >= 0.25.0. For Centrifugo v2, Centrifugo v3 and Centrifuge < 0.25.0 you should use `centrifuge-dart` v0.8.0.**

## Examples

* `example\flutter_app` simple chat application
* `example\console` simple console application

## Usage in background

When a mobile application goes to the background there are OS-specific limitations for established persistent connections - which can be silently closed shortly. Thus in most cases you need to disconnect from a server when app moves to the background and connect again when app goes to the foreground.

## Errors in event listeners

Event listeners should not throw: catch errors in your listeners. The SDK can't know what a throwing listener left undone, so it fails loudly instead of going on as if nothing happened:

* the error is reported to the zone the listener was registered in, as an uncaught error;
* the client disconnects with code `2` (bad protocol) and the reason `exception in event handler: <error>`, and doesn't reconnect – call `connect()` to start again;
* the listeners after the failing one don't get that event; the SDK's own work completes as if the listener had returned;
* a publication whose listener threw is not counted as delivered: after `connect()`, a recoverable subscription receives it again.

## Dictionary compression

A server can compress what it sends against a dictionary trained on your traffic. There is nothing to enable here: the client tells the server it can decode such frames, and the server decides whether this connection gets a dictionary. It arrives in the connect reply. A client that doesn't get one works exactly as before.

The client keeps the dictionary in memory for its lifetime, so a reconnect is sent only its id.

Supported on the VM and Flutter native platforms. Not in browsers (dart2js, dart2wasm), which have no DEFLATE with a preset dictionary to use: there the client doesn't offer it, and the server sends ordinary frames.

Which dictionary a connection gets depends on its profile, best set by your backend in the connection token. A client may also ask for one by name with `ClientConfig.profile`, e.g. `'trading-dashboard'`; the server grants it only for profiles configured to allow that.

To see what compression does for a connection:

```dart
final stats = client.dictionaryCompressionStats();
// DictionaryCompressionStats{accepted: true, active: true, dictionaryId: …,
//   frames: 102, bytesReceived: 2431, bytesDecompressed: 11390,
//   dictionaryBytes: 215, bytesSaved: 8744, ratio: 4.69,
//   transportBytesReceived: 2721}
```

`accepted` says the server enabled compression for this connection, `dictionaryBytes` what the dictionary cost to receive (zero when the client already held it), and `bytesSaved` the net saving after that cost.

## Alternative SDK

See also [PlugFox/spinify](https://github.com/PlugFox/spinify) for an alternative Dart (Flutter) real-time client SDK implementation.

## Run tests locally

Start test Centrifugo server:

```
docker compose up
```

Then run tests:

```
dart run test --reporter expanded
```

## Instructions for maintainers/contributors

### How to update protobuf definitions

1) Install `protoc` compiler
2) Install `protoc_plugin` https://pub.dev/packages/protoc_plugin (`dart pub global activate protoc_plugin`)
3) cd `lib/src/proto` and run `protoc --dart_out=. -I . client.proto`
4) cd to root and run `dartfmt -w lib/ test/` (install dartfmt with `dart pub global activate dart_style`)

### How to release

1) Update CHANGELOG.md, bump version in `pubspec.yaml`, push, create new tag
2) [ONLY IF THERE ARE ISSUES WITH CI PUBLISH] `dart pub publish`

## Author

German Saprykin, saprykin.h@gmail.com
