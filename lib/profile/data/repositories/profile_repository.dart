import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/authentication/data/repositories/token_repository.dart';
import 'package:reading/profile/data/cached/profile.dart';
import 'package:reading/profile/data/dtos/password_change_dto.dart';
import 'package:reading/profile/data/dtos/profile_change_dto.dart';
import 'package:reading/profile/domain/models/user_profile.dart';
import 'package:reading/shared/data/cached/connection_status.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository.g.dart';

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

    await ref.read(databaseProvider).update<UserProfile>(profile, profile.id);

    return profile;
  }

  @override
  Future<void> saveProfile(ProfileChangeDTO data) async {
    final profile = await ref
        .read(restApiProvider) //
        .put('app/student', body: data.toJson())
        .then((response) => UserProfile.fromJson(response as Json));

    ref
        .read(databaseProvider)
        .update<UserProfile>(profile, profile.id)
        .ignore();

    return super.saveProfile(data);
  }

  @override
  Future<void> savePassword(PasswordChangeDTO data) {
    return ref
        .read(restApiProvider) //
        .put('app/student/change-password', body: data.toJson());
  }

  @override
  Future<void> deleteProfile() async {
    await ref.read(restApiProvider).delete('app/student');
    await ref.read(tokenRepositoryProvider.notifier).deleteToken();
    await ref.read(databaseProvider).wipe();
    ref.invalidate(profileProvider);
  }
}

class OfflineProfileRepository extends ProfileRepository {
  const OfflineProfileRepository(super.ref);

  @override
  Future<UserProfile> getMyProfile() async {
    final accessToken = ref.read(tokenRepositoryProvider).requireValue;

    if (accessToken == null) {
      throw const UnauthorizedException();
    }

    final token = await ref
        .read(tokenRepositoryProvider.notifier) //
        .getToken(accessToken);

    if (token == null) {
      throw const UnauthorizedException();
    }

    final users = await ref
        .read(databaseProvider)
        .getWhere<UserProfile>((user) => user.id == token.userId);

    if (users.isEmpty) {
      throw const UnauthorizedException();
    }

    return users.first;
  }

  @override
  Future<void> savePassword(PasswordChangeDTO data) {
    throw const OnlineOnlyOperationException('savePassword');
  }

  @override
  Future<void> saveProfile(ProfileChangeDTO data) {
    throw const OnlineOnlyOperationException('saveProfile');
  }

  @override
  Future<void> deleteProfile() {
    throw const OnlineOnlyOperationException('deleteProfile');
  }
}

abstract class ProfileRepository extends Repository with OfflinePersister {
  const ProfileRepository(super.ref);

  Future<UserProfile> getMyProfile();

  @mustBeOverridden
  Future<void> saveProfile(ProfileChangeDTO data) async {
    ref.invalidate(profileProvider);
  }

  Future<void> savePassword(PasswordChangeDTO data);

  Future<void> deleteProfile();
}
