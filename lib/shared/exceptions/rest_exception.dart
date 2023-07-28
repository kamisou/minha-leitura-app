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
}

class NoResponseRestException extends RestException {
  const NoResponseRestException();
}
