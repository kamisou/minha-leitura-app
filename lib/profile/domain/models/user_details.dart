import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/profile/domain/models/user.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'user_details.freezed.dart';
part 'user_details.g.dart';

@freezed
@HiveType(typeId: 2)
class UserDetails extends HiveObject with _$UserDetails {
  const factory UserDetails({
    @HiveField(0) required String name,
    @HiveField(1) required String email,
    @HiveField(2) required String phone,
    @HiveField(3) String? avatar,
  }) = _UserDetails;

  UserDetails._();

  factory UserDetails.fromJson(Json json) => _$UserDetailsFromJson(json);

  String initials([int initialsCount = 2]) =>
      name.split(' ').take(initialsCount).map((e) => e[0]).join();

  User toUser() => User(name: name, avatar: avatar);
}
