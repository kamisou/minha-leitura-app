import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/infrastructure/rest_api.dart';
import '../../../shared/infrastructure/secure_storage.dart';
import '../../domain/models/user.dart';
import '../dto/login_dto.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
class AuthRepository extends _$AuthRepository {
  static const String _tokenKey = 'access_token';

  @override
  Future<User?> build() async {
    final accessToken = await ref.read(secureStorageProvider).read(_tokenKey);

    if (accessToken == null) {
      return null;
    }

    _authorize(accessToken);

    return _getUser();
  }

  Future<void> login(LoginDTO data) async {
    state = await AsyncValue.guard(() async {
      final dynamic response = await ref
          .read(restApiProvider)
          .post('/user/login', body: data.toJson());
      final accessToken = response['access_token'] as String;

      ref.read(secureStorageProvider).write(_tokenKey, accessToken);

      return _getUser();
    });
  }

  void _authorize(String accessToken) {
    ref.read(restApiProvider).authorize(accessToken);
  }

  Future<User> _getUser() async {
    final dynamic response = await ref.read(restApiProvider).get('/user');
    return User.fromJson(response as Json);
  }
}
