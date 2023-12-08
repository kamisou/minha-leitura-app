import 'package:reading/ranking/data/dtos/ranking_filter_dto.dart';
import 'package:reading/ranking/data/repositories/book_ranking_repository.dart';
import 'package:reading/ranking/domain/models/book_reading_ranking.dart';
import 'package:reading/ranking/domain/models/ranking.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_reading_ranking.g.dart';

@riverpod
Future<BookReadingRanking?> bookReadingRanking(
  BookReadingRankingRef ref,
  RankingFilterDTO filter,
) {
  final repo = ref.read(bookRankingRepositoryProvider);
  return switch (filter.type) {
    RankingType.$class => repo.getClassBookReadingRanking(filter.$class!.id),
    RankingType.school =>
      repo.getSchoolBookReadingRanking(filter.$class!.school.id),
    RankingType.city =>
      repo.getCityBookReadingRanking(filter.$class!.school.id),
    RankingType.state =>
      repo.getStateBookReadingRanking(filter.$class!.school.id),
    RankingType.country =>
      repo.getCountryBookReadingRanking(filter.$class!.school.id),
    RankingType.global => repo.getGlobalBookReadingRanking(),
  };
}
