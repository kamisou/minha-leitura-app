import 'package:reading/authentication/domain/domain/token.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_repository.g.dart';

@Riverpod(keepAlive: true)
String? token(TokenRef ref) {
  return ref.watch(tokenRepositoryProvider).valueOrNull;
}

@Riverpod(keepAlive: true)
class TokenRepository extends _$TokenRepository {
  @override
  Future<String?> build() {
    return ref.read(secureStorageProvider).read('current_token');
  }

  /// sets currently used access token for authentication
  Future<void> setAccessToken(String accessToken) async {
    await ref.read(secureStorageProvider).write('current_token', accessToken);
    state = AsyncData(accessToken);
  }

  /// persists token info (access token, refresh token, associated user)
  Future<void> saveTokenData(Token token) {
    return ref.read(databaseProvider).insert<Token>(token);
  }

  /// gets the specified token data
  Future<Token?> getToken(String accessToken) {
    return ref
        .read(databaseProvider)
        .getWhere<Token>((value) => value.accessToken == accessToken)
        .then((value) => value.firstOrNull);
  }

  /// deletes the currently auth token and its persisted data
  Future<void> deleteToken() async {
    final secureStorage = ref.read(secureStorageProvider);

    final currentToken = await secureStorage.read('current_token');

    await Future.wait([
      secureStorage.delete('current_token'),
      ref
          .read(databaseProvider) //
          .removeWhere<Token>(
            (token) => token.accessToken == currentToken,
            (token) => token.key,
          ),
    ]);
  }
}
