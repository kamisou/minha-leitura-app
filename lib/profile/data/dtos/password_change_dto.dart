import 'package:reading/authentication/domain/value_objects/password.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

class PasswordChangeDTO {
  const PasswordChangeDTO({
    this.oldPassword = const Password(),
    this.newPassword = const Password(),
    this.passwordConfirm = const PasswordConfirm(),
  });

  final Password oldPassword;

  final Password newPassword;

  final PasswordConfirm passwordConfirm;

  PasswordChangeDTO copyWith({
    Password? oldPassword,
    Password? newPassword,
    PasswordConfirm? passwordConfirm,
  }) =>
      PasswordChangeDTO(
        oldPassword: oldPassword ?? this.oldPassword,
        newPassword: newPassword ?? this.newPassword,
        passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      );

  Json toJson() => {
        'current_password': oldPassword.value,
        'password': newPassword.value,
        'password_confirmation': passwordConfirm.value,
      };
}
