import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/common/infrastructure/rest_api.dart';

part 'user_details.freezed.dart';
part 'user_details.g.dart';

@freezed
class UserDetails with _$UserDetails {
  const factory UserDetails({
    required String name,
    required String email,
    required String phone,
    String? avatar,
  }) = _UserDetails;

  const UserDetails._();

  factory UserDetails.fromJson(Json json) => _$UserDetailsFromJson(json);

  String initials([int initialsCount = 2]) =>
      name.split(' ').take(initialsCount).map((e) => e[0]).join();
}
