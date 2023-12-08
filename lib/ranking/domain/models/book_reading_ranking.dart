import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/ranking/domain/models/ranking.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'book_reading_ranking.freezed.dart';
part 'book_reading_ranking.g.dart';

@freezed
@HiveType(typeId: 22)
class BookReadingRanking with _$BookReadingRanking {
  const factory BookReadingRanking({
    @HiveField(0) int? id,
    @HiveField(1) required RankingType type,
    @HiveField(2) required List<BookReadingRankingSpot> spots,
  }) = _BookReadingRanking;
}

@freezed
@HiveType(typeId: 23)
class BookReadingRankingSpot with _$BookReadingRankingSpot {
  const factory BookReadingRankingSpot({
    @HiveField(0) required int rank,
    @HiveField(1) required int position,
    @HiveField(2) required String title,
    @HiveField(3) required int readings,
  }) = _BookReadingRankingSpot;

  factory BookReadingRankingSpot.fromJson(Json json) =>
      _$BookReadingRankingSpotFromJson(json);
}
