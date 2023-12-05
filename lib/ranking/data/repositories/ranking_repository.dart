import 'package:reading/ranking/domain/models/ranking.dart';
import 'package:reading/shared/data/cached/connection_status.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ranking_repository.g.dart';

@riverpod
RankingRepository rankingRepository(RankingRepositoryRef ref) {
  return ref.read(isConnectedProvider)
      ? OnlineRankingRepository(ref)
      : OfflineRankingRepository(ref);
}

class OnlineRankingRepository extends RankingRepository {
  const OnlineRankingRepository(super.ref);

  @override
  Future<Ranking?> getClassRanking(int classId) async {
    final spots = await _getSpots('app/ranking/classroom/$classId');
    final ranking = Ranking(
      id: classId,
      type: RankingType.$class,
      spots: spots,
    );

    save<Ranking>(ranking, '${RankingType.$class.name}$classId').ignore();

    return ranking;
  }

  @override
  Future<Ranking?> getSchoolRanking(int schoolId) async {
    final spots = await _getSpots('app/ranking/school/$schoolId');
    final ranking = Ranking(
      id: schoolId,
      type: RankingType.school,
      spots: spots,
    );

    save<Ranking>(ranking, '${RankingType.school.name}$schoolId').ignore();

    return ranking;
  }

  @override
  Future<Ranking?> getCityRanking(int schoolId) async {
    final spots = await _getSpots('app/ranking/city/$schoolId');
    final ranking = Ranking(id: schoolId, type: RankingType.city, spots: spots);

    save<Ranking>(ranking, '${RankingType.city.name}$schoolId').ignore();

    return ranking;
  }

  @override
  Future<Ranking?> getStateRanking(int schoolId) async {
    final spots = await _getSpots('app/ranking/state/$schoolId');
    final ranking = Ranking(
      id: schoolId,
      type: RankingType.state,
      spots: spots,
    );

    save<Ranking>(ranking, '${RankingType.state.name}$schoolId').ignore();

    return ranking;
  }

  @override
  Future<Ranking?> getCountryRanking(int schoolId) async {
    final spots = await _getSpots('app/ranking/country/$schoolId');
    final ranking = Ranking(
      id: schoolId,
      type: RankingType.country,
      spots: spots,
    );

    save<Ranking>(ranking, '${RankingType.country.name}$schoolId').ignore();

    return ranking;
  }

  @override
  Future<Ranking?> getGlobalRanking() async {
    final spots = await _getSpots('app/ranking/all');
    final ranking = Ranking(spots: spots, type: RankingType.global);

    save<Ranking>(ranking, RankingType.global.name).ignore();

    return ranking;
  }

  Future<List<RankingSpot>> _getSpots(String endpoint, [int? id]) {
    return ref
        .read(restApiProvider)
        .get('$endpoint${id == null ? '' : '/$id'}')
        .then((response) => (response as List).cast<Json>())
        .then((list) => _rankify(list).map(RankingSpot.fromJson).toList());
  }
}

class OfflineRankingRepository extends RankingRepository {
  const OfflineRankingRepository(super.ref);

  @override
  Future<Ranking?> getCityRanking(int schoolId) {
    return _getRanking(RankingType.city, schoolId);
  }

  @override
  Future<Ranking?> getClassRanking(int classId) {
    return _getRanking(RankingType.$class, classId);
  }

  @override
  Future<Ranking?> getCountryRanking(int schoolId) {
    return _getRanking(RankingType.country, schoolId);
  }

  @override
  Future<Ranking?> getSchoolRanking(int schoolId) {
    return _getRanking(RankingType.school, schoolId);
  }

  @override
  Future<Ranking?> getStateRanking(int schoolId) {
    return _getRanking(RankingType.state, schoolId);
  }

  @override
  Future<Ranking?> getGlobalRanking() {
    return _getRanking(RankingType.global);
  }

  Future<Ranking?> _getRanking(RankingType type, [int? id]) {
    return ref
        .read(databaseProvider)
        .getById<Ranking>('${type.name}${id ?? ''}');
  }
}

abstract class RankingRepository extends Repository with OfflinePersister {
  const RankingRepository(super.ref);

  List<Json> _rankify(List<Json> spots) {
    var rank = 1;
    var max = (spots.firstOrNull?['total_pages_readed'] as int?) ?? 0;

    for (final spot in spots) {
      if ((spot['total_pages_readed'] as int) < max) {
        max = spot['total_pages_readed'] as int;
        rank = rank + 1;
      }
      spot['rank'] = rank;
    }

    return spots;
  }

  Future<Ranking?> getClassRanking(int classId);
  Future<Ranking?> getSchoolRanking(int schoolId);
  Future<Ranking?> getCityRanking(int schoolId);
  Future<Ranking?> getStateRanking(int schoolId);
  Future<Ranking?> getCountryRanking(int schoolId);
  Future<Ranking?> getGlobalRanking();
}
