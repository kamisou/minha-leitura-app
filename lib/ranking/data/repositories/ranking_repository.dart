import 'package:reading/ranking/data/dtos/ranking_filter_dto.dart';
import 'package:reading/ranking/domain/models/ranking.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ranking_repository.g.dart';

@riverpod
RankingRepository rankingRepository(RankingRepositoryRef ref) {
  return ref.read(isConnectedProvider)
      ? OnlineRankingRepository(ref)
      : OfflineRankingRepository(ref);
}

@riverpod
Future<Ranking>? ranking(RankingRef ref, RankingFilterDTO filter) {
  final repo = ref.read(rankingRepositoryProvider);
  return switch (filter.type) {
    RankingType.$class => repo.getClassRanking(filter.data),
    RankingType.school => repo.getSchoolRanking(filter.data),
    RankingType.city => repo.getCityRanking(filter.data),
    RankingType.state => repo.getStateRanking(filter.data),
    RankingType.country => repo.getCountryRanking(filter.data),
    RankingType.global => repo.getGlobalRanking(),
  };
}

class OnlineRankingRepository extends RankingRepository {
  const OnlineRankingRepository(super.ref);

  @override
  Future<Ranking> getClassRanking(int classId) async {
    final spots = await _getSpots('app/reading/classroom/$classId');
    final ranking = Ranking.$class(spots: spots);

    save<Ranking>(ranking, ranking.id).ignore();

    return ranking;
  }

  @override
  Future<Ranking> getSchoolRanking(int schoolId) async {
    final spots = await _getSpots('app/reading/school/$schoolId');
    final ranking = Ranking.school(spots: spots);

    save<Ranking>(ranking, ranking.id).ignore();

    return ranking;
  }

  @override
  Future<Ranking> getCityRanking(int schoolId) async {
    final spots = await _getSpots('app/reading/city/$schoolId');
    final ranking = Ranking.city(spots: spots);

    save<Ranking>(ranking, ranking.id).ignore();

    return ranking;
  }

  @override
  Future<Ranking> getStateRanking(int schoolId) async {
    final spots = await _getSpots('app/reading/state/$schoolId');
    final ranking = Ranking.state(spots: spots);

    save<Ranking>(ranking, ranking.id).ignore();

    return ranking;
  }

  @override
  Future<Ranking> getCountryRanking(int schoolId) async {
    final spots = await _getSpots('app/reading/country/$schoolId');
    final ranking = Ranking.country(spots: spots);

    save<Ranking>(ranking, ranking.id).ignore();

    return ranking;
  }

  @override
  Future<Ranking> getGlobalRanking() async {
    final spots = await _getSpots('app/reading/all');
    final ranking = Ranking.global(spots: spots);

    save<Ranking>(ranking, ranking.id).ignore();

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
  Future<Ranking> getCityRanking(int schoolId) {
    // TODO: implement getCityRanking
    throw UnimplementedError();
  }

  @override
  Future<Ranking> getClassRanking(int classId) {
    // TODO: implement getClassRanking
    throw UnimplementedError();
  }

  @override
  Future<Ranking> getCountryRanking(int schoolId) {
    // TODO: implement getCountryRanking
    throw UnimplementedError();
  }

  @override
  Future<Ranking> getSchoolRanking(int schoolId) {
    // TODO: implement getSchoolRanking
    throw UnimplementedError();
  }

  @override
  Future<Ranking> getStateRanking(int schoolId) {
    // TODO: implement getStateRanking
    throw UnimplementedError();
  }

  @override
  Future<Ranking> getGlobalRanking() {
    // TODO: implement getStateRanking
    throw UnimplementedError();
  }
}

abstract class RankingRepository extends Repository with OfflinePersister {
  const RankingRepository(super.ref);

  Future<Ranking> getClassRanking(int classId);
  Future<Ranking> getSchoolRanking(int schoolId);
  Future<Ranking> getCityRanking(int schoolId);
  Future<Ranking> getStateRanking(int schoolId);
  Future<Ranking> getCountryRanking(int schoolId);
  Future<Ranking> getGlobalRanking();
}
