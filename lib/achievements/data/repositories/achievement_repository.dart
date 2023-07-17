import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/achievements/domain/models/achievement.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'achievement_repository.g.dart';

@riverpod
AchievementRepository achievementRepository(AchievementRepositoryRef ref) {
  return AchievementRepository(ref);
}

@riverpod
Future<Achievements> myAchievements(MyAchievementsRef ref) {
  return ref.watch(achievementRepositoryProvider).getMyAchievements();
}

class AchievementRepository {
  const AchievementRepository(this.ref);

  final Ref ref;

  Future<Achievements> getMyAchievements() async {
    // final dynamic response =
    //     await ref.read(restApiProvider).get('/user/achievements');
    // return (response as List).cast<Json>().map(Achievement.fromJson).toList()

    return const Achievements(
      single: [
        Achievement(
          category: 'Iniciando',
          title: 'Primeira leitura iniciada',
          achieved: true,
        ),
        Achievement(
          category: 'Iniciando',
          title: 'Primeira leitura concluída',
          achieved: false,
        ),
      ],
      milestones: [
        Milestone(
          title: 'Livros concluídos',
          milestones: [5, 10, 20, 40, 50, 100, 150, 200, 250, 300],
        ),
        Milestone(
          title: 'Assiduidade de leitura',
          milestones: [5, 10, 30, 50],
        ),
        Milestone(
          title: 'Páginas lidas',
          milestones: [100, 250, 500, 1000, 2000, 5000],
        ),
      ],
    );
  }
}
