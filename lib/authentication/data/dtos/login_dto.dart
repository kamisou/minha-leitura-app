import 'package:reading/authentication/domain/value_objects/password.dart';
import 'package:reading/shared/infrastructure/datasources/rest_api.dart';
import 'package:reading/profile/domain/value_objects/email.dart';

class LoginDTO {
  const LoginDTO({
    this.email = const Email(),
    this.password = const Password(),
  });

  final Email email;
  final Password password;

  LoginDTO copyWith({
    Email? email,
    Password? password,
  }) =>
      LoginDTO(
        email: email ?? this.email,
        password: password ?? this.password,
      );

  Json toJson() => {
        'email': email,
        'password': password,
      };
}
