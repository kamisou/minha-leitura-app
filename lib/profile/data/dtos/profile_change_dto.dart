import 'package:reading/authentication/domain/value_objects/password.dart';
import 'package:reading/profile/domain/value_objects/email.dart';
import 'package:reading/profile/domain/value_objects/name.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

class ProfileChangeDTO {
  const ProfileChangeDTO({
    this.name,
    this.email,
    this.password,
  });

  final Name? name;

  final Email? email;

  final Password? password;

  ProfileChangeDTO copyWith({
    Name? name,
    Email? email,
    Password? password,
  }) =>
      ProfileChangeDTO(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  Json toJson() => {
        'name': name?.value,
        'email': email?.value,
        'password': password?.value,
      };
}
