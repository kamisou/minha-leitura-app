import 'package:reading/authentication/domain/value_objects/password.dart';
import 'package:reading/profile/domain/value_objects/email.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

class PasswordChangeDTO {
  const PasswordChangeDTO({
    this.email = const Email(),
    this.oldPassword = const Password(),
    this.newPassword = const Password(),
    this.passwordConfirm = const PasswordConfirm(),
  });

  final Email email;

  final Password oldPassword;

  final Password newPassword;

  final PasswordConfirm passwordConfirm;

  PasswordChangeDTO copyWith({
    Email? email,
    Password? oldPassword,
    Password? newPassword,
    PasswordConfirm? passwordConfirm,
  }) =>
      PasswordChangeDTO(
        email: email ?? this.email,
        oldPassword: oldPassword ?? this.oldPassword,
        newPassword: newPassword ?? this.newPassword,
        passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      );

  Json toJson() => {
        'email': email.value,
        'password': oldPassword.value,
        'new_password': newPassword.value,
      };
}
