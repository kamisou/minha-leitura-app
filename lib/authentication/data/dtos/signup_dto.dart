import 'package:reading/profile/domain/value_objects/email.dart';
import 'package:reading/profile/domain/value_objects/name.dart';
import 'package:reading/authentication/domain/value_objects/password.dart';
import 'package:reading/common/infrastructure/rest_api.dart';

class SignupDTO {
  const SignupDTO({
    this.name = const Name(),
    this.email = const Email(),
    this.password = const Password(),
    this.passwordConfirm = const PasswordConfirm(),
  });

  final Name name;

  final Email email;

  final Password password;

  final PasswordConfirm passwordConfirm;

  SignupDTO copyWith({
    Name? name,
    Email? email,
    Password? password,
    PasswordConfirm? passwordConfirm,
  }) =>
      SignupDTO(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      );

  Json toJson() => {
        'name': name,
        'email': email,
        'password': password,
      };
}
