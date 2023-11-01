import 'package:reading/profile/data/repositories/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_profile_controller.g.dart';

@riverpod
class DeleteProfileController extends _$DeleteProfileController {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> deleteProfile() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(profileRepositoryProvider).deleteProfile(),
    );
  }
}
