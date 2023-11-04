import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:reading/debugging/domain/models/error_log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'debugger.g.dart';

@Riverpod(keepAlive: true)
class Debugger extends _$Debugger {
  @override
  List<ErrorLog> build() {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      scheduleMicrotask(
        () => logException(details.exception, details.stack),
      );
    };

    PlatformDispatcher.instance.onError = (exception, stackTrace) {
      logException(exception, stackTrace);
      return false;
    };

    return [];
  }

  void logException(Object exception, StackTrace? stack) {
    state = [ErrorLog(exception, stack), ...state];
  }

  void clear() {
    state = [];
  }

  static bool get isDebugMode =>
      kDebugMode || const bool.fromEnvironment('DEBUG_MODE');
}
