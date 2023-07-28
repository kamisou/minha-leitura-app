import 'dart:io';

import 'package:reading/authentication/data/repositories/auth_repository.dart';
import 'package:reading/profile/data/dtos/password_change_dto.dart';
import 'package:reading/profile/data/dtos/profile_change_dto.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository.g.dart';

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return OnlineProfileRepository(ref);
}

class OnlineProfileRepository extends ProfileRepository {
  const OnlineProfileRepository(super.ref);

  @override
  Future<void> save(ProfileChangeDTO data) async {
    await ref
        .read(restApiProvider) //
        .post('/user/profile', body: data.toJson());
    ref.invalidate(myUserProvider);
  }

  @override
  Future<void> saveAvatar(File avatar) async {
    await ref
        .read(restApiProvider) //
        .upload('/user/avatar', field: 'avatar', file: avatar);
    ref.invalidate(myUserProvider);
  }

  @override
  Future<void> savePassword(PasswordChangeDTO data) async {
    await ref
        .read(restApiProvider) //
        .post('/user/password', body: data.toJson());
    ref.invalidate(myUserProvider);
  }
}

abstract class ProfileRepository extends Repository {
  const ProfileRepository(super.ref);

  Future<void> save(ProfileChangeDTO data);
  Future<void> saveAvatar(File avatar);
  Future<void> savePassword(PasswordChangeDTO data);
}
