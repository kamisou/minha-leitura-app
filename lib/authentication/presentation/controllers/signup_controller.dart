import 'package:reading/authentication/data/dtos/signup_dto.dart';
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
    // TODO(kamisou): signup com repositório de auth
    state = await AsyncValue.guard(() async {});
  }
}
