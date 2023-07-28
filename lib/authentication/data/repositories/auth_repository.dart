import 'package:reading/authentication/data/dtos/login_dto.dart';
import 'package:reading/authentication/data/dtos/signup_dto.dart';
import 'package:reading/profile/domain/models/user_details.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:reading/shared/infrastructure/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return ref.read(isConnectedProvider)
      ? OnlineAuthRepository(ref)
      : OfflineAuthRepository(ref);
}

@riverpod
Future<UserDetails> myUser(MyUserRef ref) {
  return ref.watch(authRepositoryProvider).getMyUser();
}

@riverpod
UserDetails? user(UserRef ref) {
  return ref.watch(myUserProvider).value;
}

class OnlineAuthRepository extends AuthRepository {
  const OnlineAuthRepository(super.ref);

  @override
  Future<void> tryAuthWithToken() async {
    final token = await ref.read(secureStorageProvider).read('access_token');

    if (token == null) {
      throw UnauthorizatedException();
    }

    ref.read(restApiProvider).authorize('Bearer', token);
    ref.invalidate(userProvider);
  }

  @override
  Future<void> signup(SignupDTO data) {
    return _authenticate('user/signup', data.toJson());
  }

  @override
  Future<void> login(LoginDTO data) {
    return _authenticate('user/login', data.toJson());
  }

  Future<void> _authenticate(String endpoint, Json body) {
    final restApi = ref.read(restApiProvider);
    final secureStorage = ref.read(secureStorageProvider);

    return restApi
        .post(endpoint, body: body)
        .then((response) => (response as Json)['access_token'] as String)
        .then((token) => secureStorage.write('access_token', token))
        .then((_) => tryAuthWithToken());
  }

  @override
  Future<UserDetails> getMyUser() async {
    final api = ref.read(restApiProvider);

    if (!api.isAuthorized) {
      await tryAuthWithToken();
    }

    return api
        .get('user/my')
        .then((response) => UserDetails.fromJson(response as Json));
  }
}

class OfflineAuthRepository extends AuthRepository {
  const OfflineAuthRepository(super.ref);

  @override
  Future<UserDetails> getMyUser() {
    // TODO: implement getMyUser
    throw UnimplementedError();
  }

  @override
  Future<void> login(LoginDTO data) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> signup(SignupDTO data) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<void> tryAuthWithToken() {
    // TODO: implement tryAuthWithToken
    throw UnimplementedError();
  }
}

abstract class AuthRepository extends Repository {
  const AuthRepository(super.ref);

  Future<void> tryAuthWithToken();
  Future<void> signup(SignupDTO data);
  Future<void> login(LoginDTO data);
  Future<UserDetails> getMyUser();
}
