sealed class RestException implements Exception {
  const RestException();
}

class BadResponseRestException extends RestException {
  const BadResponseRestException({
    required this.code,
    required this.message,
  });

  final int code;
  final String message;

  @override
  String toString() {
    return '[BadResponseRestException] Bad response: $code $message.';
  }
}

class NoResponseRestException extends RestException {
  const NoResponseRestException();

  @override
  String toString() {
    return '[NoResponseRestException] Communication with the server failed.';
  }
}
