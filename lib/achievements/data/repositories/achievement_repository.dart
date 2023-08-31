import 'package:reading/achievements/domain/models/achievement.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'achievement_repository.g.dart';

@riverpod
AchievementRepository achievementRepository(AchievementRepositoryRef ref) {
  return ref.watch(isConnectedProvider)
      ? OnlineAchievementRepository(ref)
      : OfflineAchievementRepository(ref);
}

class OnlineAchievementRepository extends AchievementRepository {
  const OnlineAchievementRepository(super.ref);

  @override
  Future<Map<String, List<Achivement>>> getMyAchivements() {
    final achievements = ref
        .read(restApiProvider)
        .get('app/achievements')
        .then((response) => response as Map<String, List<Json>>)
        .then(
          (response) => response.map(
            (k, v) => MapEntry(k, v.map(Achivement.fromJson).toList()),
          ),
        );

    return achievements;
  }
}

class OfflineAchievementRepository extends AchievementRepository {
  const OfflineAchievementRepository(super.ref);

  @override
  Future<Map<String, List<Achivement>>> getMyAchivements() {
    // TODO: implement getMyAchivements
    throw UnimplementedError();
  }
}

abstract class AchievementRepository extends Repository with OfflinePersister {
  const AchievementRepository(super.ref);

  Future<Map<String, List<Achivement>>> getMyAchivements();
}
