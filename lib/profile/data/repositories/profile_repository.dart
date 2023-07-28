import 'dart:io';

import 'package:reading/profile/data/dtos/password_change_dto.dart';
import 'package:reading/profile/data/dtos/profile_change_dto.dart';
import 'package:reading/profile/domain/models/user_profile.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository.g.dart';

@riverpod
UserProfile profile(ProfileRef ref) {
  return const UserProfile(
    id: 1,
    name: 'João Marcos Kaminoski de Souza',
    email: 'kamisou@outlook.com',
    phone: '(42) 9 9860-0427',
  );
}

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return OnlineProfileRepository(ref);
}

class OnlineProfileRepository extends ProfileRepository {
  const OnlineProfileRepository(super.ref);

  @override
  Future<void> save(ProfileChangeDTO data) async {
    final profile = await ref
        .read(restApiProvider) //
        .post('user/my/profile', body: data.toJson())
        .then((response) => UserProfile.fromJson(response as Json));

    ref.read(databaseProvider).update(profile, profile.id).ignore();
    ref.invalidate(profileProvider);
  }

  @override
  Future<void> saveAvatar(File avatar) async {
    final profile = await ref
        .read(restApiProvider) //
        .upload('user/my/avatar', field: 'avatar', file: avatar)
        .then((response) => UserProfile.fromJson(response as Json));

    ref.read(databaseProvider).update(profile, profile.id).ignore();
    ref.invalidate(profileProvider);
  }

  @override
  Future<void> savePassword(PasswordChangeDTO data) {
    return ref
        .read(restApiProvider) //
        .post('user/my/password', body: data.toJson());
  }
}

abstract class ProfileRepository extends Repository {
  const ProfileRepository(super.ref);

  Future<void> save(ProfileChangeDTO data);
  Future<void> saveAvatar(File avatar);
  Future<void> savePassword(PasswordChangeDTO data);
}
