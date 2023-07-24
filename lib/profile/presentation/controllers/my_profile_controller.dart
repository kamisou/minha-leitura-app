import 'package:reading/profile/data/dtos/profile_dto.dart';
import 'package:reading/profile/data/repositories/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_profile_controller.g.dart';

@riverpod
class MyProfileController extends _$MyProfileController {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> save(ProfileDTO data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(profileRepositoryProvider).save(data),
    );
  }
}
