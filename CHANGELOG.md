## [0.20.0]

* Add `SubscriptionConfig.getState` callback support (requires Centrifugo >= 6.8.0), mirroring the same option in centrifuge-js. The callback lets the application load its state from its own source of truth and return the corresponding stream position — the SDK then subscribes with recovery from that position, so no publications are lost between the state read and the subscribe. The callback is invoked on initial subscribe (when there is no saved position) and again when the server reports an unrecoverable position (error 112 — the SDK requests this behavior via the `reject_unrecovered` subscribe flag). It is NOT called on reconnects where server-side recovery succeeds. Errors thrown from the callback emit a subscription error event with the new `SubscriptionGetStateError` type and are retried with backoff.
* Support channel compaction, mirroring centrifuge-js: every subscribe request now offers the `channel_compaction` flag, and when the server supports and allows it (Centrifugo PRO `allow_channel_compaction` namespace option) publication/join/leave pushes carry a short numeric channel ID instead of the string channel name — the SDK routes such pushes via an internal ID registry. Servers without compaction support simply ignore the flag, so behavior is unchanged there.
* Support publication filtering by tags, mirroring centrifuge-js: a subscription can carry a tags filter so the server delivers only publications whose tags match, saving bandwidth. Build the filter with the new `Filter` helpers and pass it via `SubscriptionConfig.tagsFilter`, or change it at runtime with `Subscription.setTagsFilter()`. A tags filter cannot be combined with delta compression. [#112](https://github.com/centrifugal/centrifuge-dart/pull/112)
* Resubscribe from an unrecoverable position on state invalidation: on state invalidation the SDK now resets the recovery position to a sentinel epoch the server cannot match instead of clearing it, so a recoverable subscription resubscribes with `wasRecovering=true`, `recovered=false` — letting the app reload via its existing recovery-failure path rather than looking like a brand-new first subscribe. A non-recoverable subscription simply resubscribes. [#113](https://github.com/centrifugal/centrifuge-dart/pull/113)

## [0.19.1]

* More connection and subscription stability fixes [#109](https://github.com/centrifugal/centrifuge-dart/pull/109):
  * Fix `Client.send()` to use `SendRequest` instead of the deprecated `Message` type so async messages reach the server again.
  * Server-initiated unsubscribes that move the subscription to `subscribing` (codes 2500/3007 and other temporary codes) now trigger an immediate resubscribe instead of waiting for a reconnect that may never come.
  * Subscription resubscribe is now guarded against re-entry, and bails out cleanly if `unsubscribe()` or `disconnect()` arrives while `getToken` is awaiting.
  * `Client.close()` and `Subscription.close()` no longer emit error/unsubscribed events after the resource is closed; pending `ready()` futures on a closed subscription are completed with `SubscriptionUnsubscribedError` and any timers are cancelled.
  * `ClientDisconnectedError` thrown by an in-flight `ConnectRequest` no longer cancels the reconnect timer that the transport's `onDone` already scheduled (previously left the client stuck in `connecting`).
  * Reply decoding errors are now routed through the transport's `onError` callback instead of crashing the socket listener.
  * Errors thrown from the `getData` callback are caught: an error event is emitted and the transport is closed (instead of an unhandled async exception).
  * `_refreshToken` no longer issues a `RefreshRequest` if the client is not connected anymore by the time the token callback resolves.
  * `getToken` is no longer invoked when the user did not configure one (previous check could call a null callback in edge cases).
  * `backoffDelay` returns `minDelay` when the computed range collapses to zero, avoiding `RangeError` from `Random.nextInt(0)`.

## [0.19.0]

* Add `Client.close()` — disconnects and releases all client resources (closes every event stream and removes every subscription). The client is unusable after `close()`; subsequent public method calls throw `ClientClosedError`. Use `Client.disconnect()` for a temporary disconnect that keeps the client usable. [#106](https://github.com/centrifugal/centrifuge-dart/pull/106)
* Multiple connection stability fixes, see [#106](https://github.com/centrifugal/centrifuge-dart/pull/106) for the full list. Highlights:
  * `await client.disconnect()` now actually waits for transport teardown before resolving.
  * Disconnect code `3014` (connection state invalidated) and unsubscribe code `2502` (subscription state invalidated) now correctly clear the relevant token and recovery state, forcing a fresh `getToken` on reconnect.
  * WebSocket close code `1009` (message size limit) is now terminal (no auto-reconnect), matching the behavior in centrifuge-js.
  * Cancelling a subscription while its `SubscribeRequest` is in flight now sends a cleanup `Unsubscribe` to the server, preventing a "ghost" server-side subscription that keeps pushing publications to the local sub.
  * Concurrent `unsubscribe()`/disconnect during a subscribe round-trip can no longer flip the subscription state back to `Subscribed`.
  * Several smaller correctness fixes around connect-mutex resets, async error handling, ping-reply decoding, and the `ClientDisconnectedError` thrown type.
* Wire `ClientConfig.tlsSkipVerify` through to the WebSocket transport on VM/Flutter (`dart:io`) platforms — was a silent no-op before. Useful for `wss://` development against a self-signed cert. Web platforms ignore the flag, since the browser owns TLS validation. [#107](https://github.com/centrifugal/centrifuge-dart/pull/107)
* Substantially expand the integration test suite: server-initiated reconnection scenarios, extended stream recovery edge cases, client/subscription lifecycle ordering, `getToken` retries, and several race-condition tests, all running against the docker-compose Centrifugo.

## [0.18.0]

* Min SDK version is 3.7
* Allow usage of protobuf v6 as dependency
* Drop support for Protobuf v3, v4.

## [0.17.0]

* Allow usage of protobuf v5 as dependency

## [0.16.0]

* Allow usage of protobuf v4 as dependency, drop protobuf v2

## [0.15.1]

* Support Fossil delta compression, [#97](https://github.com/centrifugal/centrifuge-dart/pull/97)

## [0.15.0]

* Update `web_socket_channel`, min SDK is now 3.3 [#91](https://github.com/centrifugal/centrifuge-dart/pull/91) 
* Support [headers emulation](https://centrifugal.dev/blog/2025/01/16/centrifugo-v6-released#headers-emulation). Also added `setHeaders` method to update headers [#92](https://github.com/centrifugal/centrifuge-dart/pull/92).

This release changes `headers` in `ClientConfig` from `Map<String, dynamic>` to `Map<String, String>`. This is a **breaking change**, but it must not cause huge troubles beyond a simple refactoring.

Usages of `dart.html` were removed in this release. Also some internal optimizations were done to allocate less when constructing Protobuf command data.

## [0.14.1]

* Add callback to update connection data [#88](https://github.com/centrifugal/centrifuge-dart/pull/88)

## [0.14.0]

* `connInfo` and `chanInfo` for join/leave events by @hetao29 [#84](https://github.com/centrifugal/centrifuge-dart/pull/84)

## [0.13.0]

* Relax Protobuf dependency requirements to be `>=2.0.0 <4.0.0` instead of `^3.0.0`

## [0.12.0]

* Fix websocket usage in web env (fixes `The method 'sendByteBuffer' isn't defined for the type 'WebSocket'` error), add simple web example [#85](https://github.com/centrifugal/centrifuge-dart/pull/85)

## [0.11.0]

* Update protobuf dependency from `^2.0.0` to `^3.0.0`. Requires Dart 2.19

## [0.10.0]

**Breaking change!** This release changes the semantics of working with connection tokens described in [Centrifugo v5 release post](https://centrifugal.dev/blog/2023/06/29/centrifugo-v5-released#token-behaviour-adjustments-in-sdks).

Previously, returning an empty token string from `getToken` callback resulted in client disconnection with unauthorized reason.

Now returning an empty string from `getToken` is a valid scenario which won't result into disconnect on the client side. It's still possible to disconnect client by throwing a special `UnauthorizedException` from `getToken` function.

And we are putting back `setToken` method to the SDK – so it's now possible to reset the token to be empty upon user logout.

## [0.9.4]

* Improving reconnect behaviour upon bad network conditions (like connect timeout), [#79](https://github.com/centrifugal/centrifuge-dart/pull/79)
* [#79](https://github.com/centrifugal/centrifuge-dart/pull/79) also handles ClientDisconnectedError in _onPing method, addresses [#76](https://github.com/centrifugal/centrifuge-dart/issues/76)

## [0.9.3]

* Add support for web platform – [#73](https://github.com/centrifugal/centrifuge-dart/pull/73)

## [0.9.2]

* Fix null check for close reason, fixes [#66](https://github.com/centrifugal/centrifuge-dart/issues/66)
* Close subscription streams on remove [#67](https://github.com/centrifugal/centrifuge-dart/pull/67)

## [0.9.1]

* Fix setting initial connection token
* Fix setting connection data
* Fix LateInitializationError if transport is not initialized yet
* Better string representation of `UnsubscribedEvent`

## [0.9.0]

**Breaking changes**

This release adopts a new iteration of Centrifugal protocol and a new iteration of API. Client now behaves according to the client [SDK API specification](https://centrifugal.dev/docs/transports/client_api). The work has been done according to [Centrifugo v4 roadmap](https://github.com/centrifugal/centrifugo/issues/500).

Check out [Centrifugo v4 release post](https://centrifugal.dev/blog/2022/07/19/centrifugo-v4-released) that covers the reasoning behind changes.

All the current core features of Centrifugal client protocol are now supported here.  

New release only works with Centrifugo >= v4.0.0 and [Centrifuge](https://github.com/centrifugal/centrifuge) >= 0.25.0. See [Centrifugo v4 migration guide](https://centrifugal.dev/docs/getting-started/migration_v4) for details about the changes in the ecosystem.

Note, that Centrifugo v4 supports clients working over the previous protocol iteration, so you can update Centrifugo to v4 without any changes on the client side (but you need to turn on `use_client_protocol_v1_by_default` option in the configuration of Centrifugo, see Centrifugo v4 migration guide for details).

## [0.8.0]

Version 0.8.0 is the next iteration of `centrifuge-dart` development. It pushes client closer to other clients in the ecosystem. It also **contains several backwards incompatible changes**.

* Return Futures from `Client.connect`, `Client.disconnect`, `Subscription.subscribe`, `Subscription.unsubscribe` methods - addresses [#31](https://github.com/centrifugal/centrifuge-dart/issues/31).
* On initial connect fire `DisconnectEvent` on connection error - this makes behavior of `centrifuge-dart` similar to all other our clients - addresses [#56](https://github.com/centrifugal/centrifuge-dart/issues/56).
* Add client error stream to consume `ErrorEvent` - each transport failure will emit error to this stream - addresses [#56](https://github.com/centrifugal/centrifuge-dart/issues/56).
* Refactor subscription statuses - add `subscribing` and `error` statuses. This change is mostly internal should not affect working with Subscriptions.
* Do not call `UnsubscribeEvent` if subscription is not successfully subscribed (i.e. in `subscribed` state). This makes behavior of `centrifuge-dart` similar to all other our clients.
* Update disconnect reasons due to failed connection and calling `Client.Disconnect` method - make it more similar to all other connector libraries in ecosystem.
* Add default transport timeout (10 sec) – on connect and subscribe timeouts client will auto reconnect, calls like publish, history, rpc can now throw `TimeoutException`. Also - properly pass timeout to the transport (was not before!). Again – this makes client behave similarly to all other connectors.
* Add `presence` and `presenceStats` methods for Subscription and on client top level (for server-side subscriptions).
* Support `streamPosition` in `SubscribeSuccessEvent`.
* Support `streamPosition` in `ServerSubscribeEvent`.
* Support `data` in `ServerSubscribeEvent`.
* Implement `send` method to send async messages to a server.
* Fix deletion during iteration over map when working with server-side subscriptions.
* Better event String representations.
* Improvements and fixes in examples.

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
