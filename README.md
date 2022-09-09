[![Build Status](https://travis-ci.org/centrifugal/centrifuge-dart.svg?branch=master)](https://travis-ci.org/centrifugal/centrifuge-dart)

Websocket client for [Centrifugo](https://github.com/centrifugal/centrifugo) server and [Centrifuge](https://github.com/centrifugal/centrifuge) library. 

There is no v1 release of this library yet – API still evolves. At the moment patch version updates only contain backwards compatible changes, minor version updates can have backwards incompatible API changes.

Check out [client SDK API specification](https://centrifugal.dev/docs/transports/client_api) to learn how this SDK behaves. It's recommended to read that before starting to work with this SDK as the spec covers common SDK behavior - describes client and subscription state transitions, main options and methods. Also check out examples folder.

The features implemented by this SDK can be found in [SDK feature matrix](https://centrifugal.dev/docs/transports/client_sdk#sdk-feature-matrix).

## Example

* `example\flutter_app` simple chat application
* `example\chat_app` one more chat example
* `example\console` simple console application
* `example\console_server_subs` demonstrates working with server-side subscriptions

## Usage in background

When a mobile application goes to the background there are OS-specific limitations for established persistent connections - which can be silently closed shortly. Thus in most cases you need to disconnect from a server when app moves to the background and connect again when app goes to the foreground.

## Instructions for maintainers/contributors

### How to update protobuf definitions

1) Install `protoc` compiler
2) Install `protoc_plugin` https://pub.dev/packages/protoc_plugin (`dart pub global activate protoc_plugin`)
3) cd `lib/src/proto` and run `protoc --dart_out=. -I . client.proto`
4) cd to root and run `dartfmt -w lib/ test/` (install dartfmt with `dart pub global activate dart_style`)

### How to release

1) Update changelog
2) Bump version in `pubspec.yaml`, push, create new tag
3) `dart pub publish`

## Author

German Saprykin, saprykin.h@gmail.com
