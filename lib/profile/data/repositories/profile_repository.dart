import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
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
Future<UserProfile> profile(ProfileRef ref) async {
  return ref.read(profileRepositoryProvider).getMyProfile();
}

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return FakeProfileRepository(ref);

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

    await save(profile);

    return profile;
  }

  @override
  Future<void> saveProfile(ProfileChangeDTO data) async {
    final profile = await ref
        .read(restApiProvider) //
        .post('user/my/profile', body: data.toJson())
        .then((response) => UserProfile.fromJson(response as Json));

    ref.read(databaseProvider).update(profile, profile.id).ignore();

    return super.saveProfile(data);
  }

  @override
  Future<void> saveAvatar(File avatar) async {
    final profile = await ref
        .read(restApiProvider)
        .upload('user/my/avatar', {'avatar': avatar}) //
        .then((response) => UserProfile.fromJson(response as Json));

    ref.read(databaseProvider).update(profile, profile.id).ignore();

    return super.saveAvatar(avatar);
  }

  @override
  Future<void> savePassword(PasswordChangeDTO data) {
    return ref
        .read(restApiProvider) //
        .post('user/my/password', body: data.toJson());
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
}

class FakeProfileRepository extends ProfileRepository {
  const FakeProfileRepository(super.ref);

  @override
  Future<UserProfile> getMyProfile() async {
    return const UserProfile(
      id: 1,
      name: 'João Marcos',
      email: 'kamisou@outlook.com',
      phone: '(42) 9 9860-0427',
    );
  }

  @override
  Future<void> savePassword(PasswordChangeDTO data) async {
    return;
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
}
