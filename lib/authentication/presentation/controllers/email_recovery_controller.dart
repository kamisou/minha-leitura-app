import 'package:reading/authentication/data/repositories/login_repository.dart';
import 'package:reading/profile/domain/value_objects/email.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'email_recovery_controller.g.dart';

@riverpod
class EmailRecoveryController extends _$EmailRecoveryController {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> recover(Email email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(loginRepositoryProvider).recover(email),
    );
  }
}
