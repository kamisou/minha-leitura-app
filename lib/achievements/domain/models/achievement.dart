import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/shared/infrastructure/datasources/rest_api.dart';

part 'achievement.freezed.dart';
part 'achievement.g.dart';

@freezed
@HiveType(typeId: 8)
class Achievements extends HiveObject with _$Achievements {
  const factory Achievements({
    @HiveField(0) required List<Achievement> single,
    @HiveField(1) required List<Milestone> milestones,
  }) = _Achievements;

  factory Achievements.fromJson(Json json) => _$AchievementsFromJson(json);
}

@freezed
@HiveType(typeId: 9)
class Achievement extends HiveObject with _$Achievement {
  const factory Achievement({
    @HiveField(0) required String title,
    @HiveField(1) required String category,
    @HiveField(2) required bool achieved,
  }) = _Achievement;

  factory Achievement.fromJson(Json json) => _$AchievementFromJson(json);
}

@freezed
@HiveType(typeId: 10)
class Milestone extends HiveObject with _$Milestone {
  const factory Milestone({
    @HiveField(0) required String title,
    @HiveField(1) required List<int> milestones,
    @HiveField(2) int? achieved,
  }) = _Milestone;

  factory Milestone.fromJson(Json json) => _$MilestoneFromJson(json);
}
