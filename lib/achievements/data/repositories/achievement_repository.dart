import 'package:reading/achievements/domain/models/achievement.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'achievement_repository.g.dart';

@riverpod
AchievementRepository achievementRepository(AchievementRepositoryRef ref) {
  return ref.read(isConnectedProvider)
      ? OnlineAchievementRepository(ref)
      : OfflineAchievementsRepository(ref);
}

@riverpod
Future<Achievements> myAchievements(MyAchievementsRef ref) {
  return ref.watch(achievementRepositoryProvider).getMyAchievements();
}

class OnlineAchievementRepository extends AchievementRepository {
  const OnlineAchievementRepository(super.ref);

  @override
  Future<Achievements> getMyAchievements() async {
    final achievements = await ref
        .read(restApiProvider) //
        .get('achievements/my')
        .then((response) => Achievements.fromJson(response as Json));

    ref.read(databaseProvider).update(achievements, achievements.id).ignore();

    return achievements;
  }
}

class OfflineAchievementsRepository extends AchievementRepository {
  const OfflineAchievementsRepository(super.ref);

  @override
  Future<Achievements> getMyAchievements() {
    return ref
        .read(databaseProvider)
        .getAll<Achievements>()
        .then((achievements) => achievements.first);
  }
}

abstract class AchievementRepository extends Repository {
  const AchievementRepository(super.ref);

  Future<Achievements> getMyAchievements();
}
