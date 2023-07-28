import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
@HiveType(typeId: 2)
class User with _$User {
  const factory User({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
    @HiveField(2) String? avatar,
  }) = _User;

  const User._();

  factory User.fromJson(Json json) => _$UserFromJson(json);

  String initials([int initialsCount = 2]) =>
      name.split(' ').take(initialsCount).map((e) => e[0]).join();
}
