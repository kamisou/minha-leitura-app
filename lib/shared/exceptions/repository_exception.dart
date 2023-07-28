sealed class RepositoryException implements Exception {}

final class OnlineOnlyOperationException extends RepositoryException {}

final class UnauthorizedException extends RepositoryException {}
