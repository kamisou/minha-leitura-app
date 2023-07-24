import 'package:reading/common/infrastructure/rest_api.dart';
import 'package:reading/profile/domain/value_objects/email.dart';
import 'package:reading/profile/domain/value_objects/name.dart';
import 'package:reading/profile/domain/value_objects/phone.dart';

class ProfileDTO {
  const ProfileDTO({
    this.name,
    this.email,
    this.phone,
  });

  final Name? name;

  final Email? email;

  final Phone? phone;

  ProfileDTO copyWith({
    Name? name,
    Email? email,
    Phone? phone,
  }) =>
      ProfileDTO(
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
      );

  Json toJson() => {
        'name': name?.value,
        'email': email?.value,
        'phone': phone?.value,
      };
}
