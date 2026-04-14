class ErrorLog {
  const ErrorLog(
    this.exception, [
    this.stack,
  ]);

  final Object exception;

  final StackTrace? stack;
}
