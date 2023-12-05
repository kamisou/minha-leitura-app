import 'package:reading/profile/data/cached/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authenticated.g.dart';

@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  return ref.watch(profileProvider).asData?.value != null;
}
