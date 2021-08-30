abstract class IWebSocket implements Stream<Object?>, Sink<Object?> {
  Duration? get pingInterval;

  set pingInterval(Duration? duration);

  @override
  Future<void> close();

  String? get closeReason;
}
