sealed class RepositoryException implements Exception {
  const RepositoryException();
}

final class OnlineOnlyOperationException extends RepositoryException {
  const OnlineOnlyOperationException(this.operation);

  final String operation;

  @override
  String toString() {
    return '[OnlineOnlyOperationException] The $operation operation requires '
        'an internet connection.';
  }
}

final class UnauthorizedException extends RepositoryException {
  const UnauthorizedException();

  @override
  String toString() {
    return '[UnauthorizedException] User tried getting its credentials without '
        'an active session.';
  }
}
