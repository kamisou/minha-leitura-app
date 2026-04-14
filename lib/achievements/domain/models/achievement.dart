import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'achievement.freezed.dart';
part 'achievement.g.dart';

@freezed
@HiveType(typeId: 14)
class AchievementCategory with _$AchievementCategory {
  const factory AchievementCategory({
    @HiveField(0) @JsonKey(name: 'category_id') required int id,
    @HiveField(1) @JsonKey(name: 'category_name') required String name,
    @HiveField(2) required List<Achievement> achievements,
  }) = _AchievementCategory;

  factory AchievementCategory.fromJson(Json json) =>
      _$AchievementCategoryFromJson(json);
}

@freezed
@HiveType(typeId: 15)
class Achievement with _$Achievement {
  const factory Achievement({
    @HiveField(0) @JsonKey(name: 'achievement_id') required int id,
    @HiveField(1) @JsonKey(name: 'achivement_title') required String title,
    @HiveField(2) @JsonKey(name: 'has_achievement') required bool completed,
  }) = _Achievement;

  factory Achievement.fromJson(Json json) => _$AchievementFromJson(json);
}
