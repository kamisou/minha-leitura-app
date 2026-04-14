import 'package:reading/shared/infrastructure/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'intro_repository.g.dart';

@Riverpod(keepAlive: true)
class IntroRepository extends _$IntroRepository {
  @override
  Future<bool> build() async {
    return _getIntroSeen();
  }

  Future<bool> _getIntroSeen() {
    return ref
        .read(secureStorageProvider)
        .read('intro_seen')
        .then((value) => value == 'true');
  }

  Future<void> setIntroSeen() async {
    await ref.read(secureStorageProvider).write('intro_seen', 'true');
    state = const AsyncData(true);
  }
}
