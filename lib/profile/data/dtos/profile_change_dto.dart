import 'package:flutter/material.dart';
import 'package:reading/authentication/domain/value_objects/password.dart';
import 'package:reading/profile/domain/value_objects/email.dart';
import 'package:reading/profile/domain/value_objects/name.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

@immutable
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

  bool validate() =>
      (Password.validate(password?.value) == null) &&
      (Name.validate(name?.value) == null) &&
      (Email.validate(email?.value) == null);

  Json toJson() => {
        'name': name?.value,
        'email': email?.value,
        'password': password?.value,
      };

  @override
  bool operator ==(Object? other) {
    if (other is! ProfileChangeDTO) {
      return false;
    }

    return other.email == email &&
        other.name == name &&
        other.password == password;
  }

  @override
  int get hashCode => Object.hashAll([email, name, password]);
}
