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
Future<Ranking> generalRanking(GeneralRankingRef ref) {
  return ref.read(rankingRepositoryProvider).getGeneralRanking();
}

class OnlineRankingRepository extends RankingRepository {
  const OnlineRankingRepository(super.ref);

  @override
  Future<Ranking> getGeneralRanking() async {
    final ranking = await ref
        .read(restApiProvider)
        .get('app/reading')
        .then((response) => Ranking.fromJson(response as Json));

    save<Ranking>(ranking, ranking.id).ignore();

    return ranking;
  }
}

class OfflineRankingRepository extends RankingRepository {
  const OfflineRankingRepository(super.ref);

  @override
  Future<Ranking> getGeneralRanking() {
    throw UnimplementedError();
  }
}

abstract class RankingRepository extends Repository with OfflinePersister {
  const RankingRepository(super.ref);

  Future<Ranking> getGeneralRanking();
}
