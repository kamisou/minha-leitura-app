import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/common/infrastructure/secure_storage.dart';
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

class IntroRepository {
  const IntroRepository(this.ref);

  static const String _introSeenKey = 'intro_seen';

  final Ref ref;

  Future<void> setIntroSeen() async {
    await ref.read(secureStorageProvider).write(_introSeenKey, 'true');
    ref.invalidate(introSeenProvider);
  }

  Future<bool> getIntroSeen() {
    return ref
        .read(secureStorageProvider)
        .read(_introSeenKey)
        .then((value) => value == 'true');
  }
}
