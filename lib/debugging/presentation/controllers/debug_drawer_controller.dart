import 'package:flutter/foundation.dart';
import 'package:reading/debugging/domain/models/error_log.dart';
import 'package:reading/shared/infrastructure/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'debug_drawer_controller.g.dart';

@Riverpod(keepAlive: true)
DebugDrawerState debugDrawerState(DebugDrawerStateRef ref) {
  return ref.watch(debugDrawerControllerProvider).requireValue;
}

@Riverpod(keepAlive: true)
class DebugDrawerController extends _$DebugDrawerController {
  @override
  Future<DebugDrawerState> build() async {
    FlutterError.onError = (details) {
      logException(details.exception, details.stack);
      FlutterError.presentError(details);
    };

    PlatformDispatcher.instance.onError = (exception, stackTrace) {
      logException(exception, stackTrace);
      return false;
    };

    final restApiServer = await ref
        .read(secureStorageProvider)
        .read('rest_api_server')
        .then((value) => value ?? 'http://marlin.websix.com.br:5000/api/');

    return DebugDrawerState(
      errorLogs: [],
      restApiServer: restApiServer,
    );
  }

  void logException(Object exception, StackTrace? stack) {
    final currentState = state.requireValue;

    state = AsyncData(
      currentState.copyWith(
        errorLogs: [ErrorLog(exception, stack), ...currentState.errorLogs],
      ),
    );
  }

  void clear() {
    state = AsyncData(
      state.requireValue.copyWith(errorLogs: []),
    );
  }

  Future<void> saveRestApiUrl(String value) {
    state = AsyncData(
      state.requireValue.copyWith(restApiServer: value),
    );

    return ref.read(secureStorageProvider).write('rest_api_server', value);
  }
}

class DebugDrawerState {
  const DebugDrawerState({
    required this.errorLogs,
    required this.restApiServer,
  });

  final List<ErrorLog> errorLogs;

  final String restApiServer;

  bool get isDebugMode =>
      kDebugMode || const bool.fromEnvironment('DEBUG_MODE');

  DebugDrawerState copyWith({
    List<ErrorLog>? errorLogs,
    String? restApiServer,
  }) =>
      DebugDrawerState(
        errorLogs: errorLogs ?? this.errorLogs,
        restApiServer: restApiServer ?? this.restApiServer,
      );
}
