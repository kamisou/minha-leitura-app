import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'error_logger.g.dart';

@Riverpod(keepAlive: true)
ErrorLogger errorLogger(ErrorLoggerRef ref) {
  return ErrorLoggerImpl();
}

class ErrorLoggerImpl extends ErrorLogger {
  ErrorLoggerImpl() {
    FlutterError.onError = (details) {
      logError(details.exception, details.stack);
      FlutterError.presentError(details);
    };

    PlatformDispatcher.instance.onError = (exception, stackTrace) {
      logError(exception, stackTrace);
      return false;
    };
  }

  @override
  void logError(Object exception, StackTrace? stack) {
    _errors.insert(0, ErrorLog(exception, stack));
  }

  @override
  void clearErrors() {
    _errors.clear();
  }
}

abstract class ErrorLogger {
  final List<ErrorLog> _errors = [];
  List<ErrorLog> get errors => _errors;

  void logError(Object exception, StackTrace? stack);
  void clearErrors();
}

class ErrorLog {
  const ErrorLog(
    this.exception, [
    this.stack,
  ]);

  final Object exception;

  final StackTrace? stack;
}
