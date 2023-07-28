import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'intro_repository.g.dart';

@riverpod
IntroRepository introRepository(IntroRepositoryRef ref) {
  return IntroRepository(ref);
}

@Riverpod(keepAlive: true)
Future<bool> introSeen(IntroSeenRef ref) {
  return ref.read(introRepositoryProvider).getIntroSeen();
}

class IntroRepository extends Repository {
  const IntroRepository(super.ref);

  Future<void> setIntroSeen() async {
    await ref.read(secureStorageProvider).write('intro_seen', 'true');
    ref.invalidate(introSeenProvider);
  }

  Future<bool> getIntroSeen() {
    return ref
        .read(secureStorageProvider)
        .read('intro_seen')
        .then((value) => value == 'true');
  }
}
