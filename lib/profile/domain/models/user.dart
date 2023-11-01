import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/shared/domain/has_name.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
@HiveType(typeId: 2)
class User with _$User implements HasName {
  const factory User({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
  }) = _User;

  factory User.fromJson(Json json) => _$UserFromJson(json);
}
