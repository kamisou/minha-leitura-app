import 'package:reading/ranking/data/dtos/ranking_filter_dto.dart';
import 'package:reading/ranking/data/repositories/ranking_repository.dart';
import 'package:reading/ranking/domain/models/ranking.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ranking.g.dart';

@riverpod
Future<Ranking?> ranking(RankingRef ref, RankingFilterDTO filter) {
  final repo = ref.read(rankingRepositoryProvider);
  return switch (filter.type) {
    RankingType.$class => repo.getClassRanking(filter.$class!.id),
    RankingType.school => repo.getSchoolRanking(filter.$class!.school.id),
    RankingType.city => repo.getCityRanking(filter.$class!.school.id),
    RankingType.state => repo.getStateRanking(filter.$class!.school.id),
    RankingType.country => repo.getCountryRanking(filter.$class!.school.id),
    RankingType.global => repo.getGlobalRanking(),
  };
}
