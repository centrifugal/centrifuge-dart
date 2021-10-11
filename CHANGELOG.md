## [0.7.1]

* Add support for `data` in `SubscribeSuccessEvent`. This is a custom data which can be sent by a server towards client connection in subscribe result. Note that due to the bug in Centrifugo server this feature only works in Centrifugo >= v3.0.3.

## [0.7.0]

Update to work with Centrifuge >= v0.18.0 and Centrifugo v3.

**Breaking change** in server behavior. Client History API behavior changed in Centrifuge >= v0.18.0 and Centrifugo >= v3.0.0. When using history call it won't return all publications in a stream by default. See Centrifuge [v0.18.0 release notes](https://github.com/centrifugal/centrifuge/releases/tag/v0.18.0) or [Centrifugo v3 migration guide](https://centrifugal.dev/docs/getting-started/migration_v3) for more information and workaround on server-side.

* Protocol definitions updated to the latest version 
* History method now accepts optional `limit`, `since` and `reverse` arguments and returns `HistoryResult`
* RPC call now requires method name as first argument (you can pass empty string to mimic previous behavior)
* Publish now returns `PublishResult`
* When working with Centrifugo v3 or Centrifuge >= v0.18.0 it's now possible to avoid using `?format=protobuf` in connection URL. Client will negotiate Protobuf protocol with a server using WebSocket subprotocol mechanism (in request headers).

## [0.6.0]

Null safety migration

* library dependencies updated to null safe versions
* library code updated to support null safety in places where required

See issue [#47](https://github.com/centrifugal/centrifuge-dart/issues/47) and pull request [#48](https://github.com/centrifugal/centrifuge-dart/pull/48) for details.

## [0.5.1]
* Skip handling for events from server-side subscriptions resulted in null pointer dereference 

## [0.5.0]
* Update protobuf dependency to `^1.0.1`, thanks [@Holofox](https://github.com/Holofox)

## [0.4.1]
* Implement `removeSubscription` method, thanks [@tiamo](https://github.com/tiamo)

## [0.4.0]
* **Breaking changes** `connected` property removed

## [0.3.0]
* **Breaking changes** Changed API to avoid returning futures where they do not make sense – in `connect` and `subscribe` methods.
* Client now uses Websocket Ping/Pong frames to find broken connection
* Support for private channel subscription using `onPrivateSub` configuration callback function
* Fix several null pointer dereferences in edge cases, throw `ClientDisconnectedError` when there is an attempt to send protocol request over non-connected client.
* Fix examples where subscribe could happen before stream handlers set

## [0.2.0]
* **Breaking changes** Replaced subscribe method with getSubscription in Client. 
* Added reconnection.
* Added history method to Subscription. Thanks [vanelizarov](https://github.com/vanelizarov).
* Added rpc method.

## [0.1.0]
* Added authorization with JWT
* Added subscription to private channel with JWT

## [0.0.1]

* Initial release