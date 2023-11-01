import 'package:reading/authentication/data/repositories/token_repository.dart';
import 'package:reading/profile/data/repositories/profile_repository.dart';
import 'package:reading/profile/domain/models/user_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile.g.dart';

@Riverpod(keepAlive: true)
Future<UserProfile?> profile(ProfileRef ref) async {
  if (ref.read(tokenRepositoryProvider).valueOrNull == null) {
    return null;
  }

  return ref.read(profileRepositoryProvider).getMyProfile();
}
