import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'achievement.freezed.dart';
part 'achievement.g.dart';

@freezed
@HiveType(typeId: 9)
class Achievements with _$Achievements {
  const factory Achievements({
    @HiveField(0) required int id,
    @HiveField(1) required Map<String, Unlockable> unlockables,
    @HiveField(2) required Map<String, Milestone> milestones,
  }) = _Achievements;

  factory Achievements.fromJson(Json json) => _$AchievementsFromJson(json);
}

@freezed
@HiveType(typeId: 10)
class Unlockable with _$Unlockable {
  const factory Unlockable({
    @HiveField(0) required int id,
    @HiveField(1) required String title,
    @HiveField(3) required bool achieved,
  }) = _Unlockable;

  factory Unlockable.fromJson(Json json) => _$UnlockableFromJson(json);
}

@freezed
@HiveType(typeId: 11)
class Milestone with _$Milestone {
  const factory Milestone({
    @HiveField(0) required int id,
    @HiveField(1) required String title,
    @HiveField(2) required List<int> milestones,
    @HiveField(3) int? achieved,
  }) = _Milestone;

  factory Milestone.fromJson(Json json) => _$MilestoneFromJson(json);
}
