import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'ranking.freezed.dart';
part 'ranking.g.dart';

@HiveType(typeId: 21)
enum RankingType {
  @HiveField(0)
  $class,
  @HiveField(1)
  school,
  @HiveField(2)
  city,
  @HiveField(3)
  state,
  @HiveField(4)
  country,
  @HiveField(5)
  global,
}

@freezed
@HiveType(typeId: 16)
class Ranking with _$Ranking {
  const factory Ranking({
    @HiveField(0) int? id,
    @HiveField(1) required RankingType type,
    @HiveField(2) required List<RankingSpot> spots,
  }) = _Ranking;
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
