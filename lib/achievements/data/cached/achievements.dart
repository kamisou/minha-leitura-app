import 'package:reading/achievements/data/repositories/achievement_repository.dart';
import 'package:reading/achievements/domain/models/achievement.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'achievements.g.dart';

@riverpod
Future<List<AchievementCategory>> achievements(AchievementsRef ref) {
  return ref.read(achievementRepositoryProvider).getMyAchivements();
}
