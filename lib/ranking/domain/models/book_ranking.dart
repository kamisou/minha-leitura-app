import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/shared/domain/rating_converter.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'book_ranking.freezed.dart';
part 'book_ranking.g.dart';

@freezed
@HiveType(typeId: 19)
class BookRanking with _$BookRanking {
  const factory BookRanking({
    @HiveField(0) required List<BookRankingSpot> spots,
  }) = _BookRanking;

  const factory BookRanking.$class({
    @HiveField(0) required List<BookRankingSpot> spots,
  }) = BookRankingClass;

  const factory BookRanking.school({
    @HiveField(0) required List<BookRankingSpot> spots,
  }) = BookRankingSchool;

  const factory BookRanking.city({
    @HiveField(0) required List<BookRankingSpot> spots,
  }) = BookRankingCity;

  const factory BookRanking.state({
    @HiveField(0) required List<BookRankingSpot> spots,
  }) = BookRankingState;

  const factory BookRanking.country({
    @HiveField(0) required List<BookRankingSpot> spots,
  }) = BookRankingCountry;

  const factory BookRanking.global({
    @HiveField(0) required List<BookRankingSpot> spots,
  }) = BookRankingGlobal;
}

@freezed
@HiveType(typeId: 20)
class BookRankingSpot with _$BookRankingSpot {
  const factory BookRankingSpot({
    @HiveField(0) required int position,
    @HiveField(1) required String title,
    @HiveField(2) required String author,
    @HiveField(3) @RatingConverter() required double ratingAvg,
  }) = _BookRankingSpot;

  factory BookRankingSpot.fromJson(Json json) =>
      _$BookRankingSpotFromJson(json);
}
