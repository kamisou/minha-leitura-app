import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'ranking.freezed.dart';
part 'ranking.g.dart';

@freezed
@HiveType(typeId: 16)
class Ranking with _$Ranking {
  const factory Ranking({
    @HiveField(0) required List<RankingSpot> spots,
  }) = _Ranking;

  const factory Ranking.$class({
    @HiveField(0) required List<RankingSpot> spots,
  }) = RankingClass;

  const factory Ranking.school({
    @HiveField(0) required List<RankingSpot> spots,
  }) = RankingSchool;

  const factory Ranking.city({
    @HiveField(0) required List<RankingSpot> spots,
  }) = RankingCity;

  const factory Ranking.state({
    @HiveField(0) required List<RankingSpot> spots,
  }) = RankingState;

  const factory Ranking.country({
    @HiveField(0) required List<RankingSpot> spots,
  }) = RankingCountry;

  const factory Ranking.global({
    @HiveField(0) required List<RankingSpot> spots,
  }) = RankingGlobal;
}

@freezed
@HiveType(typeId: 17)
class RankingSpot with _$RankingSpot {
  const factory RankingSpot({
    @HiveField(0) required int rank,
    @HiveField(1) @JsonKey(name: 'user_name') required String user,
    @HiveField(2) @JsonKey(name: 'total_pages_readed') required int pages,
  }) = _RankingSpot;

  factory RankingSpot.fromJson(Json json) => _$RankingSpotFromJson(json);
}
