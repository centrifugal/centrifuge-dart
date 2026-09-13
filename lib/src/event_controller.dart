import 'dart:async';
import 'dart:collection';

/// A synchronous broadcast event controller that allows re-entrant events.
///
/// Events are delivered synchronously, like `StreamController.broadcast(sync: true)`.
/// That controller throws StateError when an event is added while it is still
/// delivering one, e.g. when a `connecting` listener calls `disconnect()` and
/// then `connect()`. Here such an event is queued instead, and delivered as
/// soon as the current event has reached all listeners.
class EventController<T> {
  final _controller = StreamController<T>.broadcast(sync: true);
  final _pending = Queue<T>();
  bool _firing = false;

  Stream<T> get stream => _controller.stream;

  void add(T event) {
    if (_firing) {
      _pending.add(event);
      return;
    }
    _firing = true;
    try {
      _controller.add(event);
      while (_pending.isNotEmpty && !_controller.isClosed) {
        _controller.add(_pending.removeFirst());
      }
      _pending.clear();
    } finally {
      _firing = false;
    }
  }

  Future<void> close() => _controller.close();
}
