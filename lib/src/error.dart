class Error {
  final int code;
  final String? message;

  /// Custom error code.
  Error.custom(this.code, [this.message]);

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
