class Error {
  final int code;
  final String message;
  final bool temporary;

  Error.custom(this.code, this.message, this.temporary);

  @override
  String toString() {
    return 'Error{code: $code, message: $message}';
  }
}

class ClientDisconnectedError {
  @override
  String toString() {
    return 'Client disconnected';
  }
}

class SubscriptionUnsubscribedError {
  @override
  String toString() {
    return 'Subscription unsubscribed';
  }
}

class TransportError {
  final dynamic error;

  TransportError(this.error);

  @override
  String toString() {
    return 'Transport error: $error';
  }
}

class ConnectError {
  final dynamic error;

  ConnectError(this.error);

  @override
  String toString() {
    return 'Connect error: $error';
  }
}

class RefreshError {
  final dynamic error;

  RefreshError(this.error);

  @override
  String toString() {
    return 'Refresh error: $error';
  }
}

class SubscriptionSubscribeError {
  final dynamic error;

  SubscriptionSubscribeError(this.error);

  @override
  String toString() {
    return 'Subscription subscribe error: $error';
  }
}

class SubscriptionRefreshError {
  final dynamic error;

  SubscriptionRefreshError(this.error);

  @override
  String toString() {
    return 'Subscription refresh error: $error';
  }
}
