Websocket client for [Centrifugo](https://github.com/centrifugal/centrifugo) server and [Centrifuge](https://github.com/centrifugal/centrifuge) library. 

Since there is no v1 release yet, patch version updates only contain backwards compatible changes, minor version updates can have backwards incompatible API changes.

Check out [client SDK API specification](https://centrifugal.dev/docs/transports/client_api) to learn how this SDK behaves. It's recommended to read that before starting to work with this SDK as the spec covers common SDK behavior - describes client and subscription state transitions, main options and methods. Also check out examples folder.

The features implemented by this SDK can be found in [SDK feature matrix](https://centrifugal.dev/docs/transports/client_sdk#sdk-feature-matrix).

Note that custom WebSocket connection Upgrade headers are sent natively on platforms that support `dart:io` and in web context headers are sent using Centrifugo v6 [Headers Emulation](https://centrifugal.dev/blog/2025/01/16/centrifugo-v6-released#headers-emulation) feature.

> **The latest `centrifuge-dart` is compatible with [Centrifugo](https://github.com/centrifugal/centrifugo) server v6, v5 and v4 and [Centrifuge](https://github.com/centrifugal/centrifuge) >= 0.25.0. For Centrifugo v2, Centrifugo v3 and Centrifuge < 0.25.0 you should use `centrifuge-dart` v0.8.0.**

## Examples

* `example\flutter_app` simple chat application
* `example\chat_app` one more chat example
* `example\console` simple console application

## Usage in background

When a mobile application goes to the background there are OS-specific limitations for established persistent connections - which can be silently closed shortly. Thus in most cases you need to disconnect from a server when app moves to the background and connect again when app goes to the foreground.

## Alternative SDK

See also [PlugFox/spinify](https://github.com/PlugFox/spinify) for an alternative Dart (Flutter) real-time client SDK implementation.

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
