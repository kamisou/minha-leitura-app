import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'ranking.freezed.dart';
part 'ranking.g.dart';

@freezed
@HiveType(typeId: 16)
class Ranking with _$Ranking {
  const factory Ranking({
    @HiveField(0) required int id,
    @HiveField(1) required List<RankingSpot> spots,
  }) = _Ranking;

  const factory Ranking.$class({
    @HiveField(0) @Default(1) int id,
    @HiveField(1) required List<RankingSpot> spots,
  }) = _RankingClass;

  const factory Ranking.school({
    @HiveField(0) @Default(2) int id,
    @HiveField(1) required List<RankingSpot> spots,
  }) = _RankingSchool;

  const factory Ranking.city({
    @HiveField(0) @Default(3) int id,
    @HiveField(1) required List<RankingSpot> spots,
  }) = _RankingCity;

  const factory Ranking.state({
    @HiveField(0) @Default(4) int id,
    @HiveField(1) required List<RankingSpot> spots,
  }) = _RankingState;

  const factory Ranking.country({
    @HiveField(0) @Default(5) int id,
    @HiveField(1) required List<RankingSpot> spots,
  }) = _RankingCountry;

  const factory Ranking.global({
    @HiveField(0) @Default(6) int id,
    @HiveField(1) required List<RankingSpot> spots,
  }) = _RankingGlobal;
}

@freezed
@HiveType(typeId: 17)
class RankingSpot with _$RankingSpot {
  const factory RankingSpot({
    @HiveField(0) required int position,
    @HiveField(1) @JsonKey(name: 'user_name') required String user,
    @HiveField(2) @JsonKey(name: 'total_pages_readed') required int pages,
  }) = _RankingSpot;

  factory RankingSpot.fromJson(Json json) => _$RankingSpotFromJson(json);
}
