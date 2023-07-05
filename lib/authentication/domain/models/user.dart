import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/common/infrastructure/rest_api.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String name,
    String? avatar,
  }) = _User;

  factory User.fromJson(Json json) => _$UserFromJson(json);
}
