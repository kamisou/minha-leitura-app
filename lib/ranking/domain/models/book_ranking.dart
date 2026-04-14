import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/ranking/domain/models/ranking.dart';
import 'package:reading/shared/domain/rating_converter.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'book_ranking.freezed.dart';
part 'book_ranking.g.dart';

@freezed
@HiveType(typeId: 19)
class BookRanking with _$BookRanking {
  const factory BookRanking({
    @HiveField(0) int? id,
    @HiveField(1) required RankingType type,
    @HiveField(2) required List<BookRankingSpot> spots,
  }) = _BookRanking;
}

@freezed
@HiveType(typeId: 20)
class BookRankingSpot with _$BookRankingSpot {
  const factory BookRankingSpot({
    @HiveField(0) required int rank,
    @HiveField(1) required int position,
    @HiveField(2) required String title,
    @HiveField(3) required String author,
    @HiveField(4) @RatingConverter() required double ratingAvg,
  }) = _BookRankingSpot;

  factory BookRankingSpot.fromJson(Json json) =>
      _$BookRankingSpotFromJson(json);
}
