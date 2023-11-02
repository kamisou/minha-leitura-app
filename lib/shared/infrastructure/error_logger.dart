import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'error_logger.g.dart';

@Riverpod(keepAlive: true)
class ErrorLogger extends _$ErrorLogger with ErrorLoggerMixin {
  @override
  List<ErrorLog> build() {
    FlutterError.onError = (details) {
      log(details.exception, details.stack);
      FlutterError.presentError(details);
    };

    PlatformDispatcher.instance.onError = (exception, stackTrace) {
      log(exception, stackTrace);
      return false;
    };

    return [];
  }

  @override
  void log(Object exception, StackTrace? stack) {
    state = [ErrorLog(exception, stack), ...state];
  }

  @override
  void clear() {
    state = [];
  }
}

mixin ErrorLoggerMixin {
  void log(Object exception, StackTrace? stack);
  void clear();
}

class ErrorLog {
  const ErrorLog(
    this.exception, [
    this.stack,
  ]);

  final Object exception;

  final StackTrace? stack;
}
