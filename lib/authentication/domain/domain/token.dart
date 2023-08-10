import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'token.freezed.dart';
part 'token.g.dart';

@freezed
@HiveType(typeId: 1)
class Token with _$Token, HiveObjectMixin {
  @With<HiveObjectMixin>()
  factory Token({
    @HiveField(0) required String accessToken,
    @HiveField(1) required int userId,
  }) = _Token;
}
