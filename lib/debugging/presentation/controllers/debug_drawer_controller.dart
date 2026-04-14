import 'package:reading/shared/infrastructure/debugger.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'debug_drawer_controller.g.dart';

@riverpod
class DebugDrawerController extends _$DebugDrawerController {
  @override
  Future<void> build() async {
    return;
  }

  void clearLogs() {
    ref.read(debuggerProvider.notifier).clear();
  }

  Future<void> setRestApiUrl(String value) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(restApiServerProvider.notifier).set(value),
    );
  }
}
