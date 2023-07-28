import 'package:reading/authentication/data/dtos/signup_dto.dart';
import 'package:reading/authentication/data/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup_controller.g.dart';

@riverpod
class SignupController extends _$SignupController {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> signup(SignupDTO data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signup(data),
    );
  }
}
