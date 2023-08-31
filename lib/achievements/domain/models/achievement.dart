import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'achievement.freezed.dart';
part 'achievement.g.dart';

@freezed
class Achivement with _$Achivement {
  const factory Achivement({
    required int id,
  }) = _Achievement;

  factory Achivement.fromJson(Json json) => _$AchivementFromJson(json);
}
