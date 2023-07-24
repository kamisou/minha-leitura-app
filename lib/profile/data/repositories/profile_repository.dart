import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/common/infrastructure/rest_api.dart';
import 'package:reading/profile/data/dtos/profile_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository.g.dart';

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepository(ref);
}

class ProfileRepository {
  const ProfileRepository(this.ref);

  final Ref ref;

  Future<void> save(ProfileDTO data) {
    return ref.read(restApiProvider).post('/user/profile', body: data.toJson());
  }
}
