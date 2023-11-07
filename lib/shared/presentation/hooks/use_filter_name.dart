import 'package:reading/ranking/data/dtos/ranking_filter_dto.dart';

String useFilterName(RankingFilterDTO filter) {
  return switch (filter.type) {
    RankingType.$class => filter.$class!.name,
    RankingType.school => filter.$class!.schoolName,
    RankingType.city => 'Cidade - ${filter.$class!.schoolName}',
    RankingType.state => 'Estado - ${filter.$class!.schoolName}',
    RankingType.country => 'País - ${filter.$class!.schoolName}',
    RankingType.global => 'Global',
  };
}
