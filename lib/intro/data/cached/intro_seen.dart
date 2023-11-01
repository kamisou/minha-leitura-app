import 'package:reading/intro/data/repositories/intro_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'intro_seen.g.dart';

@Riverpod(keepAlive: true)
bool introSeen(IntroSeenRef ref) {
  return ref.watch(introRepositoryProvider).valueOrNull ?? false;
}
