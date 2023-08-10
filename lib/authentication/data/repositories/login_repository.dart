import 'package:reading/authentication/data/dtos/login_dto.dart';
import 'package:reading/authentication/data/dtos/token_dto.dart';
import 'package:reading/authentication/data/repositories/token_repository.dart';
import 'package:reading/authentication/domain/domain/token.dart';
import 'package:reading/profile/data/repositories/profile_repository.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_repository.g.dart';

@riverpod
LoginRepository loginRepository(LoginRepositoryRef ref) {
  return LoginRepository(ref);
}

class LoginRepository extends Repository {
  const LoginRepository(super.ref);

  Future<void> login(LoginDTO data) async {
    final tokenRepo = ref.read(tokenRepositoryProvider.notifier);

    final tokenData = await ref
        .read(restApiProvider)
        .post('auth/login', body: data.toJson())
        .then((response) => TokenDTO.fromJson((response as List)[0] as Json));

    await tokenRepo.setAccessToken(tokenData.accessToken);

    final profile = await ref.refresh(profileProvider.future);
    final token = Token(accessToken: tokenData.accessToken, userId: profile.id);

    return tokenRepo.saveTokenData(token);
  }

  Future<void> logout() async {
    await ref.read(tokenRepositoryProvider.notifier).deleteToken();
    ref.invalidate(profileProvider);
  }
}
