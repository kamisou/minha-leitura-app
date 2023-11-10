import 'package:reading/ranking/data/dtos/ranking_filter_dto.dart';
import 'package:reading/ranking/data/repositories/book_ranking_repository.dart';
import 'package:reading/ranking/domain/models/book_ranking.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_ranking.g.dart';

@riverpod
Future<BookRanking?> bookRanking(BookRankingRef ref, RankingFilterDTO filter) {
  final repo = ref.read(bookRankingRepositoryProvider);
  return switch (filter.type) {
    RankingType.$class => repo.getClassBookRanking(filter.$class!.id),
    RankingType.school => repo.getSchoolBookRanking(filter.$class!.school.id),
    RankingType.city => repo.getCityBookRanking(filter.$class!.school.id),
    RankingType.state => repo.getStateBookRanking(filter.$class!.school.id),
    RankingType.country => repo.getCountryBookRanking(filter.$class!.school.id),
    RankingType.global => repo.getGlobalBookRanking(),
  };
}
