import 'dart:io';

import 'package:reading/profile/data/dtos/password_change_dto.dart';
import 'package:reading/profile/data/dtos/profile_change_dto.dart';
import 'package:reading/profile/data/repositories/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> save(ProfileChangeDTO data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(profileRepositoryProvider).saveProfile(data),
    );
  }

  Future<void> saveAvatar(File avatar) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(profileRepositoryProvider).saveAvatar(avatar),
    );
  }

  Future<void> savePassword(PasswordChangeDTO data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(profileRepositoryProvider).savePassword(data),
    );
  }
}
