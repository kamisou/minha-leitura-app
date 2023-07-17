import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/common/infrastructure/rest_api.dart';

part 'achievement.freezed.dart';
part 'achievement.g.dart';

@freezed
class Achievements with _$Achievements {
  const factory Achievements({
    required List<Achievement> single,
    required List<Milestone> milestones,
  }) = _Achievements;

  factory Achievements.fromJson(Json json) => _$AchievementsFromJson(json);
}

@freezed
class Achievement with _$Achievement {
  const factory Achievement({
    required String title,
    required String category,
    required bool achieved,
  }) = _Achievement;

  factory Achievement.fromJson(Json json) => _$AchievementFromJson(json);
}

@freezed
class Milestone with _$Milestone {
  const factory Milestone({
    required String title,
    required List<int> milestones,
    int? achieved,
  }) = _Milestone;

  factory Milestone.fromJson(Json json) => _$MilestoneFromJson(json);
}
