import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dto/login_dto.dart';
import '../../data/repositories/auth_repository.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  Future<LoginDTO> build() async {
    return const LoginDTO();
  }

  Future<void> login() async {
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider.notifier).login(state.value!);
      return const LoginDTO();
    });
  }
}
