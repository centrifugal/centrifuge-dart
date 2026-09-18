import 'dart:async';

import 'package:centrifuge/src/event_controller.dart';
import 'package:test/test.dart';

void main() {
  group('EventController', () {
    test('an event added right after resume() is delivered after the events buffered while paused',
        () async {
      final controller = EventController<int>();
      final events = <int>[];
      final subscription = controller.stream.listen(events.add);
      addTearDown(subscription.cancel);

      subscription.pause();
      controller.add(1);
      controller.add(2);
      subscription.resume();
      controller.add(3);
      await Future<void>.delayed(Duration.zero);

      expect(events, [1, 2, 3]);
    });

    test('an event added when the resume signal completes is delivered after the buffered events',
        () async {
      final controller = EventController<int>();
      final events = <int>[];
      final subscription = controller.stream.listen(events.add);
      addTearDown(subscription.cancel);
      final resumeSignal = Completer<void>();

      subscription.pause(resumeSignal.future);
      controller.add(1);
      // Runs after the subscription resumed, before the buffered event is
      // delivered.
      resumeSignal.future.then((_) => controller.add(2));
      resumeSignal.complete();
      await Future<void>.delayed(Duration.zero);

      expect(events, [1, 2]);
    });

    test('stream is the same stream on every call', () {
      final controller = EventController<int>();

      expect(controller.stream, same(controller.stream));
    });

    test('code awaiting stream.first resumes inside the event', () async {
      final controller = EventController<int>();
      final log = <String>[];
      unawaited(() async {
        await controller.stream.first;
        log.add('resumed');
      }());

      controller.add(1);
      log.add('after add');
      await Future<void>.delayed(Duration.zero);

      expect(log, ['resumed', 'after add']);
    });
  });
}
