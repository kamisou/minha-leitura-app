import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/profile/domain/models/user.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'ranking.freezed.dart';
part 'ranking.g.dart';

@freezed
@HiveType(typeId: 16)
class Ranking with _$Ranking {
  const factory Ranking({
    @HiveField(0) required int id,
    @HiveField(1) required String title,
    @HiveField(2) required List<RankingSpot> spots,
  }) = _Ranking;

  factory Ranking.fromJson(Json json) => _$RankingFromJson(json);
}

@freezed
@HiveType(typeId: 17)
class RankingSpot with _$RankingSpot {
  const factory RankingSpot({
    @HiveField(0) required int position,
    @HiveField(1) required User user,
    @HiveField(2) required int pages,
  }) = _RankingSpot;

  factory RankingSpot.fromJson(Json json) => _$RankingSpotFromJson(json);
}
