import 'package:reading/authentication/data/dto/login_dto.dart';
import 'package:reading/common/infrastructure/rest_api.dart';
import 'package:reading/common/infrastructure/secure_storage.dart';
import 'package:reading/profile/domain/models/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
class AuthRepository extends _$AuthRepository {
  static const String _tokenKey = 'access_token';

  @override
  Future<User?> build() async {
    await _authorize();
    return _getUser();
  }

  Future<void> _authorize() async {
    final accessToken = await ref.read(secureStorageProvider).read(_tokenKey);

    if (accessToken == null) {
      return;
    }

    ref.read(restApiProvider).authorize('Bearer', accessToken);
  }

  Future<User> _getUser() async {
    final dynamic response = await ref.read(restApiProvider).get('/user');
    return User.fromJson(response as Json);
  }

  Future<void> login(LoginDTO data) async {
    final response = await ref
        .read(restApiProvider)
        .post('/user/login', body: data.toJson()) as Map<String, dynamic>;

    final accessToken = response['access_token'] as String;

    await ref.read(secureStorageProvider).write(_tokenKey, accessToken);

    state = AsyncData(await _getUser());
  }
}
