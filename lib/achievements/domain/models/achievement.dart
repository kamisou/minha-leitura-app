import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/common/infrastructure/rest_api.dart';

part 'achievement.freezed.dart';
part 'achievement.g.dart';

@freezed
class Achievement with _$Achievement {
  const factory Achievement({
    required String title,
    required int achieved,
    required List<int> milestones,
  }) = _Achivement;

  factory Achievement.fromJson(Json json) => _$AchievementFromJson(json);
}
