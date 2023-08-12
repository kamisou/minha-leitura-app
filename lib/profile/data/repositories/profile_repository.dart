import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/authentication/data/repositories/login_repository.dart';
import 'package:reading/authentication/data/repositories/token_repository.dart';
import 'package:reading/authentication/domain/domain/token.dart';
import 'package:reading/profile/data/dtos/password_change_dto.dart';
import 'package:reading/profile/data/dtos/profile_change_dto.dart';
import 'package:reading/profile/domain/models/user_profile.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository.g.dart';

@Riverpod(keepAlive: true)
Future<UserProfile?> profile(ProfileRef ref) async {
  if (ref.read(tokenRepositoryProvider).valueOrNull == null) {
    return null;
  }
  return ref.read(profileRepositoryProvider).getMyProfile();
}

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ref.read(isConnectedProvider)
      ? OnlineProfileRepository(ref)
      : OfflineProfileRepository(ref);
}

class OnlineProfileRepository extends ProfileRepository {
  const OnlineProfileRepository(super.ref);

  @override
  Future<UserProfile> getMyProfile() async {
    final profile = await ref
        .read(restApiProvider)
        .get('app/student')
        .then((response) => UserProfile.fromJson(response as Json));

    await ref
        .read(encryptedDatabaseProvider)
        .update<UserProfile>(profile, profile.id);

    return profile;
  }

  @override
  Future<void> saveProfile(ProfileChangeDTO data) async {
    final profile = await ref
        .read(restApiProvider) //
        .post('user/my/profile', body: data.toJson())
        .then((response) => UserProfile.fromJson(response as Json));

    ref
        .read(encryptedDatabaseProvider)
        .update<UserProfile>(profile, profile.id)
        .ignore();

    return super.saveProfile(data);
  }

  @override
  Future<void> saveAvatar(File avatar) async {
    final profile = await ref
        .read(restApiProvider)
        .upload('user/my/avatar', {'avatar': avatar}) //
        .then((response) => UserProfile.fromJson(response as Json));

    ref
        .read(encryptedDatabaseProvider)
        .update<UserProfile>(profile, profile.id)
        .ignore();

    return super.saveAvatar(avatar);
  }

  @override
  Future<void> savePassword(PasswordChangeDTO data) {
    return ref
        .read(restApiProvider) //
        .post('user/my/password', body: data.toJson());
  }

  @override
  Future<void> deleteProfile() async {
    await ref.read(restApiProvider).delete('app/student');
    return ref.read(loginRepositoryProvider).logout();
  }
}

class OfflineProfileRepository extends ProfileRepository {
  const OfflineProfileRepository(super.ref);

  @override
  Future<UserProfile> getMyProfile() async {
    final accessToken = ref.read(tokenRepositoryProvider).requireValue;

    final tokens = await ref
        .read(encryptedDatabaseProvider)
        .getWhere<Token>((token) => token.accessToken == accessToken);

    if (tokens.isEmpty) {
      throw UnauthorizedException();
    }

    final users = await ref
        .read(encryptedDatabaseProvider)
        .getWhere<UserProfile>((user) => user.id == tokens.first.userId);

    if (users.isEmpty) {
      throw UnauthorizedException();
    }

    return users.first;
  }

  @override
  Future<void> saveAvatar(File avatar) {
    throw OnlineOnlyOperationException();
  }

  @override
  Future<void> savePassword(PasswordChangeDTO data) {
    throw OnlineOnlyOperationException();
  }

  @override
  Future<void> saveProfile(ProfileChangeDTO data) {
    throw OnlineOnlyOperationException();
  }

  @override
  Future<void> deleteProfile() {
    throw OnlineOnlyOperationException();
  }
}

abstract class ProfileRepository extends Repository with OfflinePersister {
  const ProfileRepository(super.ref);

  Future<UserProfile> getMyProfile();

  @mustBeOverridden
  Future<void> saveProfile(ProfileChangeDTO data) async {
    ref.invalidate(profileProvider);
  }

  @mustBeOverridden
  Future<void> saveAvatar(File avatar) async {
    ref.invalidate(profileProvider);
  }

  Future<void> savePassword(PasswordChangeDTO data);

  Future<void> deleteProfile();
}
