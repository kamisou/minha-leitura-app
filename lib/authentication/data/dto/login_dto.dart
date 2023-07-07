import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/common/infrastructure/rest_api.dart';
import 'package:reading/profile/domain/value_objects/email.dart';
import 'package:reading/profile/domain/value_objects/password.dart';

part 'login_dto.freezed.dart';
part 'login_dto.g.dart';

@freezed
class LoginDTO with _$LoginDTO {
  const factory LoginDTO({
    @Default(Email()) //
    @JsonKey(toJson: Email.toJson)
    Email email,
    @Default(Password()) //
    @JsonKey(toJson: Password.toJson)
    Password password,
  }) = _LoginDTO;

  factory LoginDTO.fromJson(Json json) => _$LoginDTOFromJson(json);
}
