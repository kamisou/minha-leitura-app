import 'package:reading/achievements/domain/models/achievement.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'achievement_repository.g.dart';

@riverpod
AchievementRepository achievementRepository(AchievementRepositoryRef ref) {
  return ref.watch(isConnectedProvider)
      ? OnlineAchievementRepository(ref)
      : OfflineAchievementRepository(ref);
}

@riverpod
Future<List<AchievementCategory>> achievements(AchievementsRef ref) {
  return ref.read(achievementRepositoryProvider).getMyAchivements();
}

class OnlineAchievementRepository extends AchievementRepository {
  const OnlineAchievementRepository(super.ref);

  @override
  Future<List<AchievementCategory>> getMyAchivements() async {
    final achievements = await ref
        .read(restApiProvider)
        .get('app/achievements')
        .then((response) => (response as List).cast<Json>())
        .then((list) => list.map(AchievementCategory.fromJson).toList());

    await saveAll<AchievementCategory>(
      achievements,
      (achievement) => achievement.id,
    );

    return achievements;
  }
}

class OfflineAchievementRepository extends AchievementRepository {
  const OfflineAchievementRepository(super.ref);

  @override
  Future<List<AchievementCategory>> getMyAchivements() {
    return ref.read(databaseProvider).getAll<AchievementCategory>();
  }
}

abstract class AchievementRepository extends Repository with OfflinePersister {
  const AchievementRepository(super.ref);

  Future<List<AchievementCategory>> getMyAchivements();
}
