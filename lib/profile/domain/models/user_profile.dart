import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/profile/domain/models/user.dart';
import 'package:reading/shared/domain/has_name.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
@HiveType(typeId: 3)
class UserProfile with _$UserProfile, HasName {
  const factory UserProfile({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
    @HiveField(2) required String email,
    @HiveField(3) required String phone,
    @HiveField(4) String? avatar,
  }) = _UserProfile;

  const UserProfile._();

  factory UserProfile.fromJson(Json json) => _$UserProfileFromJson(json);

  User toUser() => User(id: id, name: name, avatar: avatar);
}
