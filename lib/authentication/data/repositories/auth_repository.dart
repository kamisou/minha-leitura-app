import 'package:reading/authentication/data/dtos/login_dto.dart';
import 'package:reading/authentication/data/dtos/signup_dto.dart';
import 'package:reading/profile/domain/models/user_details.dart';
import 'package:reading/shared/infrastructure/datasources/rest_api.dart';
import 'package:reading/shared/infrastructure/datasources/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

/// note: only safe to consume after successful login
@riverpod
UserDetails? user(UserRef ref) {
  return ref.watch(authRepositoryProvider).value;
}

@Riverpod(keepAlive: true)
class AuthRepository extends _$AuthRepository {
  @override
  Future<UserDetails> build() async {
    await _authorize();
    return _getUser();
  }

  Future<void> _authorize() async {
    final accessToken = await ref
        .read(secureStorageProvider) //
        .read('access_token');

    if (accessToken == null) {
      return;
    }

    ref.read(restApiProvider).authorize('Bearer', accessToken);
  }

  Future<UserDetails> _getUser() async {
    // final dynamic response = await ref.read(restApiProvider).get('/user');
    // return UserDetails.fromJson(response as Json);

    return const UserDetails(
      name: 'João Marcos Kaminoski de Souza',
      email: 'kamisou@outlook.com',
      phone: '(42) 9 9860-0427',
    );
  }

  Future<void> login(LoginDTO data) async {
    // final response = await ref
    //     .read(restApiProvider)
    //     .post('/user/login', body: data.toJson()) as Map<String, dynamic>;

    // final accessToken = response['access_token'] as String;

    // await ref.read(secureStorageProvider).write('access_token', accessToken);

    state = AsyncData(await _getUser());
  }

  Future<void> signup(SignupDTO data) async {
    state = AsyncData(await _getUser());
  }
}
