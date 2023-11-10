import 'package:reading/profile/data/dtos/password_change_dto.dart';
import 'package:reading/profile/data/repositories/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_password_controller.g.dart';

@riverpod
class ProfilePasswordController extends _$ProfilePasswordController {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> savePassword(PasswordChangeDTO data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(profileRepositoryProvider).savePassword(data),
    );
  }
}
