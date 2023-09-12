import 'package:reading/achievements/domain/models/achievement.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'achievement_repository.g.dart';

@riverpod
AchievementRepository achievementRepository(AchievementRepositoryRef ref) {
  return FakeAchievementRepository(ref);

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

class FakeAchievementRepository extends AchievementRepository {
  const FakeAchievementRepository(super.ref);

  @override
  Future<List<AchievementCategory>> getMyAchivements() async {
    return const [
      AchievementCategory(
        id: 1,
        name: 'Iniciando',
        achievements: [
          Achievement(
            id: 1,
            name: 'Primeira leitura iniciada',
            max: 1,
            achieved: 1,
          ),
          Achievement(
            id: 1,
            name: 'Primeira leitura iniciada',
            max: 1,
            achieved: 0,
          ),
        ],
      ),
      AchievementCategory(
        id: 2,
        name: 'Livros concluídos',
        achievements: [
          Achievement(
            id: 1,
            name: '5 leituras concluídas',
            max: 5,
            achieved: 3,
          ),
          Achievement(
            id: 2,
            name: '10 leituras concluídas',
            max: 10,
            achieved: 3,
          ),
          Achievement(
            id: 3,
            name: '15 leituras concluídas',
            max: 15,
            achieved: 3,
          ),
        ],
      ),
    ];
  }
}

abstract class AchievementRepository extends Repository with OfflinePersister {
  const AchievementRepository(super.ref);

  Future<List<AchievementCategory>> getMyAchivements();
}