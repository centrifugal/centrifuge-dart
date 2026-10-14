import 'dart:async';
import 'dart:collection';

// What a subscription of a stream controller returns from cancel() when there
// is nothing to wait for. Stream.first, firstWhere and similar complete right
// away, inside the event, only when cancel() returns this very future, so code
// awaiting them can still listen to the events that follow in the same reply.
final Future<void> _nothingToCancel = StreamController<void>.broadcast().stream.listen(null).cancel();

/// A synchronous broadcast event controller that allows nested events.
///
/// Like `StreamController.broadcast(sync: true)`, events are delivered
/// synchronously to every listener, in the zone the listener was registered
/// in, and an exception thrown by a listener is reported to that zone. Then the
/// listeners after it don't get the event, and [onListenerError] is called: the
/// client stops (see ClientImpl.handlerFailed). Unlike it, an event added while an event is being
/// delivered (e.g. a `connecting` listener calls `disconnect()` and then
/// `connect()`) is delivered right away, like a nested call, instead of throwing
/// StateError. Events therefore reach listeners in the order the state changed,
/// and the state a listener reads matches its event.
class EventController<T> {
  EventController({this.onListenerError});

  /// Called with the exception a listener threw, after it was reported.
  final void Function(Object error)? onListenerError;

  final _subscriptions = <_EventSubscription<T>>[];
  bool _closed = false;

  /// The same stream on every call, so it compares equal like the stream of a
  /// stream controller: e.g. a Flutter StreamBuilder given it again on rebuild
  /// keeps its subscription.
  late final Stream<T> stream = _EventStream<T>(this);

  bool get isClosed => _closed;

  /// Delivers [event] to the listeners. Returns false when one threw: the
  /// listeners after it don't get the event.
  bool add(T event) {
    if (_closed) {
      throw StateError('Cannot add new events after calling close');
    }
    // A copy: listeners may listen or cancel while the event is delivered.
    for (final subscription in List.of(_subscriptions)) {
      if (!subscription._add(event)) return false;
    }
    return true;
  }

  void _listenerFailed(Object error) {
    onListenerError?.call(error);
  }

  Future<void> close() {
    if (!_closed) {
      _closed = true;
      final subscriptions = List.of(_subscriptions);
      _subscriptions.clear();
      for (final subscription in subscriptions) {
        subscription._close();
      }
    }
    return Future.value();
  }
}

class _EventStream<T> extends Stream<T> {
  _EventStream(this._controller);

  final EventController<T> _controller;

  @override
  bool get isBroadcast => true;

  @override
  StreamSubscription<T> listen(void Function(T event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    final subscription = _EventSubscription<T>(_controller, onData, onDone);
    if (_controller._closed) {
      scheduleMicrotask(subscription._close);
    } else {
      _controller._subscriptions.add(subscription);
    }
    return subscription;
  }
}

class _EventSubscription<T> implements StreamSubscription<T> {
  _EventSubscription(this._controller, void Function(T event)? onData, void Function()? onDone)
      : _zone = Zone.current {
    this.onData(onData);
    this.onDone(onDone);
  }

  final EventController<T> _controller;
  final Zone _zone;
  void Function(T event)? _onData;
  void Function()? _onDone;
  final _pending = Queue<T>();
  int _pauseCount = 0;
  bool _doneReceived = false;
  // Cancelled, or done delivered.
  bool _finished = false;

  @override
  void onData(void Function(T data)? handleData) {
    _onData = handleData == null ? null : _zone.registerUnaryCallback<void, T>(handleData);
  }

  @override
  void onError(Function? handleError) {
    // No error events are added.
  }

  @override
  void onDone(void Function()? handleDone) {
    _onDone = handleDone == null ? null : _zone.registerCallback<void>(handleDone);
  }

  /// Returns false when the listener threw.
  bool _add(T event) {
    if (_finished) return true;
    // After resume(), events that arrived while paused are delivered first.
    if (_pauseCount > 0 || _pending.isNotEmpty) {
      _pending.add(event);
      return true;
    }
    return _deliver(event);
  }

  bool _deliver(T event) {
    final handler = _onData;
    if (handler == null) return true;
    try {
      _zone.runUnary(handler, event);
      return true;
    } catch (error, stackTrace) {
      // Reported to the listener's zone, as runUnaryGuarded does: an uncaught
      // error there. Then the owner stops.
      _zone.handleUncaughtError(error, stackTrace);
      _controller._listenerFailed(error);
      return false;
    }
  }

  void _close() {
    if (_finished) return;
    _doneReceived = true;
    if (_pauseCount == 0 && _pending.isEmpty) {
      _finish();
    }
  }

  void _finish() {
    _finished = true;
    final handler = _onDone;
    if (handler != null) {
      _zone.runGuarded(handler);
    }
  }

  @override
  void pause([Future<void>? resumeSignal]) {
    if (_finished) return;
    _pauseCount++;
    resumeSignal?.then((_) => resume(), onError: (_) => resume());
  }

  @override
  void resume() {
    if (_finished || _pauseCount == 0) return;
    _pauseCount--;
    if (_pauseCount == 0) {
      // As with a stream controller, events that arrived while paused are
      // delivered asynchronously.
      scheduleMicrotask(_flush);
    }
  }

  void _flush() {
    while (!_finished && _pauseCount == 0 && _pending.isNotEmpty) {
      _deliver(_pending.removeFirst());
    }
    if (!_finished && _doneReceived && _pauseCount == 0 && _pending.isEmpty) {
      _finish();
    }
  }

  @override
  bool get isPaused => _pauseCount > 0;

  @override
  Future<void> cancel() {
    if (!_finished) {
      _finished = true;
      _pending.clear();
      _controller._subscriptions.remove(this);
    }
    return _nothingToCancel;
  }

  @override
  Future<E> asFuture<E>([E? futureValue]) {
    final completer = Completer<E>();
    onDone(() => completer.complete(futureValue as E));
    return completer.future;
  }
}
