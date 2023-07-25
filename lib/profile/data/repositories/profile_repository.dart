import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/profile/data/dtos/password_change_dto.dart';
import 'package:reading/profile/data/dtos/profile_change_dto.dart';
import 'package:reading/shared/infrastructure/datasources/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository.g.dart';

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepository(ref);
}

class ProfileRepository {
  const ProfileRepository(this.ref);

  final Ref ref;

  Future<void> save(ProfileChangeDTO data) {
    return ref.read(restApiProvider).post('/user/profile', body: data.toJson());
  }

  Future<String> saveAvatar(File avatar) async {
    final response = ref
        .read(restApiProvider)
        .upload('/user/avatar', field: 'avatar', file: avatar) as Json;

    return response['avatar_url'] as String;
  }

  Future<void> savePassword(PasswordChangeDTO data) {
    return ref
        .read(restApiProvider)
        .post('/user/password', body: data.toJson());
  }
}
