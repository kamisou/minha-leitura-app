import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/authentication/domain/value_objects/email.dart';
import 'package:reading/authentication/domain/value_objects/name.dart';
import 'package:reading/authentication/domain/value_objects/password.dart';
import 'package:reading/common/infrastructure/rest_api.dart';

part 'signup_dto.freezed.dart';
part 'signup_dto.g.dart';

@freezed
class SignupDTO with _$SignupDTO {
  const factory SignupDTO({
    @Default(Name()) //
    @JsonKey(toJson: Name.toJson)
    Name name,
    @Default(Email()) //
    @JsonKey(toJson: Email.toJson)
    Email email,
    @Default(Password()) //
    @JsonKey(toJson: Password.toJson)
    Password password,
    @Default(PasswordConfirm()) //
    @JsonKey(toJson: PasswordConfirm.toJson)
    PasswordConfirm passwordConfirm,
  }) = _SignupDTO;

  factory SignupDTO.fromJson(Json json) => _$SignupDTOFromJson(json);
}
