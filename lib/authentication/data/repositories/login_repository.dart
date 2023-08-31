import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/authentication/data/dtos/login_dto.dart';
import 'package:reading/authentication/data/dtos/signup_dto.dart';
import 'package:reading/authentication/data/dtos/token_dto.dart';
import 'package:reading/authentication/data/repositories/token_repository.dart';
import 'package:reading/authentication/domain/domain/token.dart';
import 'package:reading/profile/data/repositories/profile_repository.dart';
import 'package:reading/profile/domain/value_objects/email.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_repository.g.dart';

@riverpod
LoginRepository loginRepository(LoginRepositoryRef ref) {
  return ref.read(isConnectedProvider)
      ? OnlineLoginRepository(ref)
      : OfflineLoginRepository(ref);
}

class OnlineLoginRepository extends LoginRepository {
  const OnlineLoginRepository(super.ref);

  @override
  Future<void> login(LoginDTO data) async {
    final tokenRepo = ref.read(tokenRepositoryProvider.notifier);

    final tokenData = await ref
        .read(restApiProvider)
        .post('auth/login', body: data.toJson())
        .then((response) => TokenDTO.fromJson((response as List)[0] as Json));

    await tokenRepo.setAccessToken(tokenData.accessToken);

    final profile = await ref.refresh(profileProvider.future);
    final token =
        Token(accessToken: tokenData.accessToken, userId: profile!.id);

    return tokenRepo.saveTokenData(token);
  }

  @override
  Future<void> signup(SignupDTO data) async {
    final tokenRepo = ref.read(tokenRepositoryProvider.notifier);

    final tokenData = await ref
        .read(restApiProvider)
        .post('auth/register', body: data.toJson())
        .then((response) => TokenDTO.fromJson(response as Json));

    await tokenRepo.setAccessToken(tokenData.accessToken);

    final profile = await ref.refresh(profileProvider.future);
    final token =
        Token(accessToken: tokenData.accessToken, userId: profile!.id);

    return tokenRepo.saveTokenData(token);
  }

  @override
  Future<void> recover(Email email) {
    return ref
        .read(restApiProvider)
        .post('auth/reset-password', body: {'email': email.value});
  }

  @override
  Future<void> logout() async {
    await ref.read(restApiProvider).post('auth/logout');
    return super.logout();
  }
}

class OfflineLoginRepository extends LoginRepository {
  const OfflineLoginRepository(super.ref);

  @override
  Future<void> login(LoginDTO data) {
    throw OnlineOnlyOperationException();
  }

  @override
  Future<void> signup(SignupDTO data) {
    throw OnlineOnlyOperationException();
  }

  @override
  Future<void> recover(Email email) {
    throw OnlineOnlyOperationException();
  }
}

abstract class LoginRepository extends Repository {
  const LoginRepository(super.ref);

  Future<void> login(LoginDTO data);
  Future<void> signup(SignupDTO data);
  Future<void> recover(Email email);

  @mustCallSuper
  Future<void> logout() async {
    await ref.read(tokenRepositoryProvider.notifier).deleteToken();
    await ref.read(databaseProvider).wipe();
    ref.invalidate(profileProvider);
  }
}
