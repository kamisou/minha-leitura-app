import 'package:reading/ranking/domain/models/ranking.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
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
    final ranking = RankingClass(spots: spots);

    save<RankingClass>(ranking, 1).ignore();

    return ranking;
  }

  @override
  Future<Ranking?> getSchoolRanking(int schoolId) async {
    final spots = await _getSpots('app/ranking/school/$schoolId');
    final ranking = RankingSchool(spots: spots);

    save<RankingSchool>(ranking, 1).ignore();

    return ranking;
  }

  @override
  Future<Ranking?> getCityRanking(int schoolId) async {
    final spots = await _getSpots('app/ranking/city/$schoolId');
    final ranking = RankingCity(spots: spots);

    save<RankingCity>(ranking, 1).ignore();

    return ranking;
  }

  @override
  Future<Ranking?> getStateRanking(int schoolId) async {
    final spots = await _getSpots('app/ranking/state/$schoolId');
    final ranking = RankingState(spots: spots);

    save<RankingState>(ranking, 1).ignore();

    return ranking;
  }

  @override
  Future<Ranking?> getCountryRanking(int schoolId) async {
    final spots = await _getSpots('app/ranking/country/$schoolId');
    final ranking = RankingCountry(spots: spots);

    save<RankingCountry>(ranking, 1).ignore();

    return ranking;
  }

  @override
  Future<Ranking?> getGlobalRanking() async {
    final spots = await _getSpots('app/ranking/all');
    final ranking = RankingGlobal(spots: spots);

    save<RankingGlobal>(ranking, 1).ignore();

    return ranking;
  }

  Future<List<RankingSpot>> _getSpots(String endpoint, [int? id]) {
    return ref
        .read(restApiProvider)
        .get('$endpoint${id == null ? '' : '/$id'}')
        .then((response) => (response as List).cast<Json>())
        .then((list) => list.map(RankingSpot.fromJson).toList());
  }
}

class OfflineRankingRepository extends RankingRepository {
  const OfflineRankingRepository(super.ref);

  @override
  Future<Ranking?> getCityRanking(int schoolId) {
    return ref
        .read(databaseProvider)
        .getAll<RankingCity>()
        .then((value) => value.first);
  }

  @override
  Future<Ranking?> getClassRanking(int classId) {
    return ref
        .read(databaseProvider)
        .getAll<RankingClass>()
        .then((value) => value.first);
  }

  @override
  Future<Ranking?> getCountryRanking(int schoolId) {
    return ref
        .read(databaseProvider)
        .getAll<RankingCountry>()
        .then((value) => value.first);
  }

  @override
  Future<Ranking?> getSchoolRanking(int schoolId) {
    return ref
        .read(databaseProvider)
        .getAll<RankingSchool>()
        .then((value) => value.first);
  }

  @override
  Future<Ranking?> getStateRanking(int schoolId) {
    return ref
        .read(databaseProvider)
        .getAll<RankingState>()
        .then((value) => value.first);
  }

  @override
  Future<Ranking?> getGlobalRanking() {
    return ref
        .read(databaseProvider)
        .getAll<RankingGlobal>()
        .then((value) => value.first);
  }
}

abstract class RankingRepository extends Repository with OfflinePersister {
  const RankingRepository(super.ref);

  Future<Ranking?> getClassRanking(int classId);
  Future<Ranking?> getSchoolRanking(int schoolId);
  Future<Ranking?> getCityRanking(int schoolId);
  Future<Ranking?> getStateRanking(int schoolId);
  Future<Ranking?> getCountryRanking(int schoolId);
  Future<Ranking?> getGlobalRanking();
}
