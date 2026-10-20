## [0.21.0]

A stability release. Connection, subscription and token handling were reviewed against a validation harness and against centrifuge-js. The harness covers seeded chaos against a fake server, a real Centrifugo behind fault-injecting proxies, and browsers under dart2js and dart2wasm. Most fixes cover races between reconnects, event listeners calling back into the client, teardown, token refresh, and browser behaviour. Every fix comes with a regression test.

Centrifugo v6.9.6 or later is recommended; see "Server versions" below.

### Behaviour changes to check when upgrading

* **`connect()` validates the endpoint.** It throws the new `ConfigurationError`, without changing the client state, when the endpoint can't be opened as a websocket on the platform. Such endpoints used to be retried forever as transport errors, calling `getToken` and `getData` on every attempt.
  * **VM:** the endpoint must be a `ws://` or `wss://` URL with a host and a valid port.
  * **Browsers:** it's checked with the browser's own URL parser, as `new WebSocket()` does. `ws:`, `wss:`, `http:`, `https:` and page-relative URLs are accepted; a fragment is not.
  * PRs: [#159](https://github.com/centrifugal/centrifuge-dart/pull/159), [#161](https://github.com/centrifugal/centrifuge-dart/pull/161), [#166](https://github.com/centrifugal/centrifuge-dart/pull/166).
* **An expired connection token with no `getToken` stops the client.** The client emits a `ConfigurationError` error event and disconnects as unauthorized, as centrifuge-js does, instead of reconnecting with the expired token forever. Call `setToken()` with a new token, then `connect()`. With `getToken` configured, the next attempt still calls `getToken`, even after `setToken()`. PRs: [#129](https://github.com/centrifugal/centrifuge-dart/pull/129), [#154](https://github.com/centrifugal/centrifuge-dart/pull/154).
* **An exception while handling a message from the server stops the client.** An example is a fossil delta publication without base data. The client disconnects with `badProtocol` and reason "exception during message handling: ...", without reconnecting, as centrifuge-js does. The exception is still reported as uncaught. Before, the rest of that websocket message was lost, including replies to pending calls, and the client went on. The same now applies to a publication recovered in a subscribe reply that fails to decode, e.g. a delta without base data: before, the error went unnoticed and the rest of the recovered publications were dropped. PRs: [#131](https://github.com/centrifugal/centrifuge-dart/pull/131), [#177](https://github.com/centrifugal/centrifuge-dart/pull/177).
* **An exception thrown by an event listener stops the client.** The client disconnects with `badProtocol` and reason "exception in event handler: ...", without reconnecting, as centrifuge-js does; call `connect()` to start again. The exception is still reported as uncaught in the listener's zone. Listeners after the failing one don't get that event, and the SDK's own processing completes as if the listener had returned. A publication whose listener threw doesn't count as delivered, so after `connect()` a recoverable subscription receives it again. Before, the exception was reported and otherwise ignored, and the client went on. Catch errors in your listeners. PR: [#177](https://github.com/centrifugal/centrifuge-dart/pull/177).
* **The websocket handshake is limited by `ClientConfig.timeout`** (10s by default). It's aborted on timeout, and on `disconnect()` or `close()` while in progress. Before, a server that accepted the connection but never answered the upgrade left the client connecting forever, and every attempt against it leaked its socket: two file descriptors per attempt, measured at 824 open descriptors after 400 attempts, until the process hit its limit and could no longer connect at all.
  * **With `HttpOverrides` in effect,** the handshake uses the app's `HttpClient`, which is left open, so a timed-out handshake isn't aborted.
  * PRs: [#126](https://github.com/centrifugal/centrifuge-dart/pull/126), [#139](https://github.com/centrifugal/centrifuge-dart/pull/139), [#151](https://github.com/centrifugal/centrifuge-dart/pull/151), [#158](https://github.com/centrifugal/centrifuge-dart/pull/158), [#162](https://github.com/centrifugal/centrifuge-dart/pull/162).
* **`unsubscribed` is emitted when `unsubscribe()` is called,** before the server replies, instead of after the reply. The Unsubscribe command is sent before the event, so a `subscribe()` from its listener follows it. PRs: [#128](https://github.com/centrifugal/centrifuge-dart/pull/128), [#133](https://github.com/centrifugal/centrifuge-dart/pull/133).
* **`removeSubscription()` unregisters the subscription at once.**
  * A new subscription to the same channel can be created right away.
  * `subscribe()` on the removed subscription throws `ClientClosedError`.
  * Its streams close once the unsubscribe completes, so every listener still gets the current event.
  * PRs: [#147](https://github.com/centrifugal/centrifuge-dart/pull/147), [#153](https://github.com/centrifugal/centrifuge-dart/pull/153).
* **`subscriptions()` returns an unmodifiable copy** instead of the client's live registry. Code can remove subscriptions while iterating over it. PR: [#150](https://github.com/centrifugal/centrifuge-dart/pull/150).
* **`ready()` returns a failed future instead of throwing synchronously** when the client is disconnected or closed, or the subscription is unsubscribed. `await ready()` inside `try` catches the error as before; `ready().catchError(...)` now gets it too. PR: [#163](https://github.com/centrifugal/centrifuge-dart/pull/163).
* **A repeated `connect()` or `subscribe()` doesn't fail.** A second call while connecting or subscribing still waits for the attempt in progress. Like the first call, it now completes without an error if that attempt ends in a disconnect or unsubscribe, instead of leaving an uncaught error when not awaited. PR: [#164](https://github.com/centrifugal/centrifuge-dart/pull/164).
* **A server unsubscribe push is ignored while a subscription is still subscribing,** as centrifuge-js does. The server sends it also for a channel the connection isn't subscribed to yet. PR: [#155](https://github.com/centrifugal/centrifuge-dart/pull/155).
* **Nested events are delivered immediately.** An event emitted while a listener handles another one is delivered right away, still synchronously, instead of throwing `StateError: Cannot fire new event`. PR: [#127](https://github.com/centrifugal/centrifuge-dart/pull/127).
* **Close reasons below 3000 are normalized.** A websocket close with a code below 3000, other than 1009, is reported as code 1 with reason "transport closed", as centrifuge-js does. It used to carry the socket's reason, which is empty in browsers for a dropped connection. PR: [#167](https://github.com/centrifugal/centrifuge-dart/pull/167).
* **A zero `timeout` means no timeout** also for calls waiting for the client or a subscription to become ready; they used to fail at once. PR: [#156](https://github.com/centrifugal/centrifuge-dart/pull/156).
* **A static token survives state invalidation.** After a 3014 disconnect or a 2502 unsubscribe, a connection or subscription token without `getToken` is kept, and the client reconnects or resubscribes with it. The server rejects it if it's no longer valid. PRs: [#129](https://github.com/centrifugal/centrifuge-dart/pull/129), [#152](https://github.com/centrifugal/centrifuge-dart/pull/152).

### Connection fixes

* **Superseded connect attempts:**
  * `disconnect()`, `setToken()` and `connect()` during a pending attempt no longer connect with the old token.
  * `connect()` after `disconnect()` is no longer dropped while the old attempt runs.
  * `disconnect()` closes the pending attempt's transport.
  * A transport closing while `getData` is awaited no longer loses its reconnect.
  * PR: [#126](https://github.com/centrifugal/centrifuge-dart/pull/126).
* **Listeners calling back into the client:**
  * `disconnect()` or `connect()` from `connecting`, `connected`, `disconnected`, `subscribing` and `error` listeners leaves consistent state and one connection attempt, with no duplicate events, no `ConcurrentModificationError` and no leftover ping or refresh timers.
  * A listener's reaction to a failed connect or subscribe is no longer undone by the failure handling that followed.
  * PRs: [#127](https://github.com/centrifugal/centrifuge-dart/pull/127), [#137](https://github.com/centrifugal/centrifuge-dart/pull/137).
* **`connect()` from a `disconnected` listener after `getToken` threw `UnauthorizedException`** no longer leaves the client connecting forever. PR: [#124](https://github.com/centrifugal/centrifuge-dart/pull/124).
* **Closed connections:**
  * A closed connection is processed before its pending calls fail, so a pending subscribe or refresh no longer emits an error event for a close the client recovers from on its own.
  * A listener sending a command while those calls fail no longer leaves the client connected to a closed connection.
  * PRs: [#138](https://github.com/centrifugal/centrifuge-dart/pull/138), [#140](https://github.com/centrifugal/centrifuge-dart/pull/140).
* **Calls and timeouts:**
  * A call racing `disconnect()` fails with `ClientDisconnectedError` instead of a null-check `TypeError`.
  * When a suspended process resumes, replies and pings already received are processed before call timeouts and the ping timeout. That avoids failing a call the server handled, and "no ping" reconnects of healthy connections.
  * Calls that time out waiting for `ready()` no longer leave waiters behind.
  * PRs: [#130](https://github.com/centrifugal/centrifuge-dart/pull/130), [#145](https://github.com/centrifugal/centrifuge-dart/pull/145), [#148](https://github.com/centrifugal/centrifuge-dart/pull/148).
* **Data that isn't the protocol while connecting** closes the connection and reconnects at once, instead of waiting for the connect timeout. PR: [#160](https://github.com/centrifugal/centrifuge-dart/pull/160).

### Subscription and recovery fixes

* **No deliveries after a teardown.** Publications, joins and leaves are no longer delivered, and the stored position no longer moves, after `unsubscribe()`, `disconnect()` or `removeSubscription()`. This covers:
  * the rest of a message
  * the rest of the recovered publications
  * publications of server-side subscriptions from the connect reply
  * PR: [#128](https://github.com/centrifugal/centrifuge-dart/pull/128).
* **Ghost subscriptions:**
  * A subscribe superseded by `unsubscribe()` can no longer mark the subscription subscribed, or leave a server-side subscription the client doesn't track.
  * A subscribe pending when the connection is lost, e.g. in a browser whose network dropped, no longer blocks the next connection's resubscribe.
  * When `unsubscribe()` during a subscribe in flight sends an Unsubscribe and it fails, the client reconnects, as after a failed Unsubscribe of a subscribed subscription and as in centrifuge-js. Before, the server could keep the subscription and push its publications until the connection ended. A failure arriving after that connection ended no longer reconnects the next one.
  * PRs: [#128](https://github.com/centrifugal/centrifuge-dart/pull/128), [#134](https://github.com/centrifugal/centrifuge-dart/pull/134), [#177](https://github.com/centrifugal/centrifuge-dart/pull/177).
* **Recovery without an epoch:** when a subscribe or connect reply had no epoch (a channel without a stream yet), subscriptions and server-side subscriptions recovered with an empty epoch, which skips the server's epoch check. The epoch sent with the channel's first publication is now used, as in centrifuge-js. The bundled protocol gains `Publication.epoch`. PR: [#170](https://github.com/centrifugal/centrifuge-dart/pull/170).
* **`unsubscribe()` and `subscribe()` from a publication listener** no longer recover that publication again. PR: [#142](https://github.com/centrifugal/centrifuge-dart/pull/142).
* **A subscription `getToken` that throws `TimeoutException`** is handled like other `getToken` errors instead of reconnecting the whole client. PR: [#143](https://github.com/centrifugal/centrifuge-dart/pull/143).
* **State invalidation:**
  * A `getState` subscription created before a 3014 still calls `getState` on its first subscribe.
  * Server-side subscriptions no longer request recovery from their pre-invalidation position.
  * PRs: [#121](https://github.com/centrifugal/centrifuge-dart/pull/121), [#146](https://github.com/centrifugal/centrifuge-dart/pull/146).
* **`removeSubscription()` and subscribe:**
  * Removing a subscription that was already removed no longer closes a newer subscription to the same channel.
  * A subscription being removed can no longer subscribe again on the server.
  * PRs: [#141](https://github.com/centrifugal/centrifuge-dart/pull/141), [#147](https://github.com/centrifugal/centrifuge-dart/pull/147).
* **`ready()`** no longer resolves after a `subscribed` listener tore the subscription down. PR: [#148](https://github.com/centrifugal/centrifuge-dart/pull/148).
* **Channel compaction:** a subscription moved back to subscribing by the server drops its channel compaction ID, so pushes for another channel reusing that ID aren't delivered to it. PR: [#123](https://github.com/centrifugal/centrifuge-dart/pull/123).

### Token fixes

* **Refresh chains:** a token refresh whose `getToken` resolves after a reconnect or resubscribe no longer starts a second refresh chain for the life of the connection or subscription. PR: [#129](https://github.com/centrifugal/centrifuge-dart/pull/129).
* **Empty refresh token:** an empty token returned by `getToken` during a refresh means unauthorized, as documented and as in centrifuge-js. It disconnects the client, or unsubscribes the subscription, instead of sending a refresh without a token. PR: [#122](https://github.com/centrifugal/centrifuge-dart/pull/122).
* **Static subscription token:** a subscription with a token but without `getToken` no longer fails into an endless retry loop when the server reports an expiry. PR: [#120](https://github.com/centrifugal/centrifuge-dart/pull/120).
* **Expired token and error listeners:** an expired token is dropped before the error event, so `connect()` or `subscribe()` from its listener gets a new token. PR: [#137](https://github.com/centrifugal/centrifuge-dart/pull/137).

### Other fixes

* **`toString()`:** `UnauthorizedException.toString()` includes its message, and `MessageEvent.toString()` is well-formed. PRs: [#118](https://github.com/centrifugal/centrifuge-dart/pull/118), [#119](https://github.com/centrifugal/centrifuge-dart/pull/119).

### Server versions

Two Centrifugo bugs found during this validation are fixed in Centrifugo v6.9.6 ([centrifugal/centrifuge#629](https://github.com/centrifugal/centrifuge/pull/629) and [#627](https://github.com/centrifugal/centrifuge/pull/627)):
* **Fossil delta after an empty recovery.** On older servers, a subscription with fossil delta that recovers no publications, for example one subscribing with `since` at the top of the stream, gets the next publication as a delta without base data. With this release the client then disconnects with `badProtocol`; earlier versions dropped every publication on the channel.
* **Expired subscription token accepted on refresh.** On older servers a subscription refresh with an expired token was accepted, and the subscription then never expired. v6.9.6 disconnects with 3006, and the client reconnects and gets a new token.

### Tests and CI

* **Centrifugo version:** CI runs against Centrifugo v6.9.6, with a real-server test for the fossil delta fix. PR: [#168](https://github.com/centrifugal/centrifuge-dart/pull/168).
* **Browser tests:** `test/web_endpoint_test.dart` runs in a browser: `dart test -p chrome test/web_endpoint_test.dart`, optionally with `--compiler dart2wasm`. It isn't part of CI.
* **Flaky tests and comments:** a timing-sensitive ping test was made independent of CPU load, a call timeout race test was made deterministic, outdated comments were updated, and the fake test server now documents that it keeps every command it received. PRs: [#165](https://github.com/centrifugal/centrifuge-dart/pull/165), [#169](https://github.com/centrifugal/centrifuge-dart/pull/169), [#171](https://github.com/centrifugal/centrifuge-dart/pull/171), [#177](https://github.com/centrifugal/centrifuge-dart/pull/177).

Some PRs in this release fix issues introduced by earlier PRs of the same release: [#135](https://github.com/centrifugal/centrifuge-dart/pull/135), [#136](https://github.com/centrifugal/centrifuge-dart/pull/136), [#144](https://github.com/centrifugal/centrifuge-dart/pull/144), [#149](https://github.com/centrifugal/centrifuge-dart/pull/149), [#157](https://github.com/centrifugal/centrifuge-dart/pull/157) and parts of the PRs above. They are not listed separately, since v0.20.1 was not affected.

## [0.20.1]

* Fix `Transport` resolving to the `dart:io` (`IOWebSocketChannel`) implementation instead of the browser one (`HtmlWebSocketChannel`) when compiled with `dart2wasm`. The conditional import in `transport.dart` used to check `dart.library.html`, which is not declared under the wasm compile target — Flutter Web's wasm target has no `dart:html` and relies on `dart:js_interop` instead — so the WebSocket transport silently fell back to the VM implementation and never connected in the browser. Switched the check to `dart.library.js_interop`, which is declared for both `dart2js` and `dart2wasm` web builds while remaining unavailable on native (VM) targets, so native platforms keep using `dart:io` as before.

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
