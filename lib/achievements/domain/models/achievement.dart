import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'achievement.freezed.dart';
part 'achievement.g.dart';

@freezed
@HiveType(typeId: 14)
class AchievementCategory with _$AchievementCategory {
  const factory AchievementCategory({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
    @HiveField(2) required List<Achievement> achievements,
  }) = _AchievementCategory;

  factory AchievementCategory.fromJson(Json json) =>
      _$AchievementCategoryFromJson(json);
}

@freezed
@HiveType(typeId: 15)
class Achievement with _$Achievement {
  const factory Achievement({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
    @HiveField(2) required int max,
    @HiveField(3) required int achieved,
  }) = _Achievement;

  factory Achievement.fromJson(Json json) => _$AchievementFromJson(json);

  const Achievement._();

  bool get isAccomplished => achieved >= max;
}
