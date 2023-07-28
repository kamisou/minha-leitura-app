import 'package:reading/profile/domain/value_objects/email.dart';
import 'package:reading/profile/domain/value_objects/name.dart';
import 'package:reading/profile/domain/value_objects/phone.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

class ProfileChangeDTO {
  const ProfileChangeDTO({
    this.name,
    this.email,
    this.phone,
  });

  final Name? name;

  final Email? email;

  final Phone? phone;

  ProfileChangeDTO copyWith({
    Name? name,
    Email? email,
    Phone? phone,
  }) =>
      ProfileChangeDTO(
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
