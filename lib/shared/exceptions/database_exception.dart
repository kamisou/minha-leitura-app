sealed class DatabaseException implements Exception {
  const DatabaseException();
}

final class NoRowFoundException extends DatabaseException {
  const NoRowFoundException();
}
