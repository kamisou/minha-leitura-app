import 'package:reading/classes/data/repositories/class_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'join_class_controller.g.dart';

@riverpod
class JoinClassController extends _$JoinClassController {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> joinClass(String code) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(classRepositoryProvider).joinClass(code),
    );
  }
}
