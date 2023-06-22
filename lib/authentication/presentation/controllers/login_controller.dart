import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dto/login_dto.dart';
import '../../data/repositories/auth_repository.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> login(LoginDTO data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider.notifier).login(data),
    );
  }
}
