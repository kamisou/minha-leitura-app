import 'package:reading/ranking/domain/models/book_ranking.dart';
import 'package:reading/ranking/domain/models/book_reading_ranking.dart';
import 'package:reading/ranking/domain/models/ranking.dart';
import 'package:reading/shared/data/cached/connection_status.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_ranking_repository.g.dart';

@riverpod
BookRankingRepository bookRankingRepository(BookRankingRepositoryRef ref) {
  return ref.read(isConnectedProvider)
      ? OnlineBookRankingRepository(ref)
      : OfflineBookRankingRepository(ref);
}

class OnlineBookRankingRepository extends BookRankingRepository {
  const OnlineBookRankingRepository(super.ref);

  @override
  Future<BookRanking?> getClassBookRanking(int classId) async {
    final spots = await _getSpots('app/book_ranking/classroom/$classId');
    final ranking = BookRanking(
      id: classId,
      type: RankingType.$class,
      spots: spots,
    );

    save<BookRanking>(ranking, '${RankingType.$class.name}$classId').ignore();

    return ranking;
  }

  @override
  Future<BookRanking?> getSchoolBookRanking(int schoolId) async {
    final spots = await _getSpots('app/book_ranking/school/$schoolId');
    final ranking = BookRanking(
      id: schoolId,
      type: RankingType.school,
      spots: spots,
    );

    save<BookRanking>(ranking, '${RankingType.school.name}$schoolId').ignore();

    return ranking;
  }

  @override
  Future<BookRanking?> getCityBookRanking(int schoolId) async {
    final spots = await _getSpots('app/book_ranking/city/$schoolId');
    final ranking = BookRanking(
      id: schoolId,
      type: RankingType.city,
      spots: spots,
    );

    save<BookRanking>(ranking, '${RankingType.city.name}$schoolId').ignore();

    return ranking;
  }

  @override
  Future<BookRanking?> getStateBookRanking(int schoolId) async {
    final spots = await _getSpots('app/book_ranking/state/$schoolId');
    final ranking = BookRanking(
      id: schoolId,
      type: RankingType.state,
      spots: spots,
    );

    save<BookRanking>(ranking, '${RankingType.state.name}$schoolId').ignore();

    return ranking;
  }

  @override
  Future<BookRanking?> getCountryBookRanking(int schoolId) async {
    final spots = await _getSpots('app/book_ranking/country/$schoolId');
    final ranking = BookRanking(
      id: schoolId,
      type: RankingType.country,
      spots: spots,
    );

    save<BookRanking>(ranking, '${RankingType.country.name}$schoolId').ignore();

    return ranking;
  }

  @override
  Future<BookRanking?> getGlobalBookRanking() async {
    final spots = await _getSpots('app/book_ranking/all');
    final ranking = BookRanking(type: RankingType.global, spots: spots);

    save<BookRanking>(ranking, RankingType.global.name).ignore();

    return ranking;
  }

  @override
  Future<BookReadingRanking?> getCityBookReadingRanking(int schoolId) async {
    final spots =
        await _getReadingSpots('app/book_readed_ranking/city/$schoolId');
    final ranking = BookReadingRanking(
      id: schoolId,
      type: RankingType.city,
      spots: spots,
    );

    save<BookReadingRanking>(ranking, '${RankingType.city.name}$schoolId')
        .ignore();

    return ranking;
  }

  @override
  Future<BookReadingRanking?> getClassBookReadingRanking(int classId) async {
    final spots =
        await _getReadingSpots('app/book_readed_ranking/classroom/$classId');
    final ranking = BookReadingRanking(
      id: classId,
      type: RankingType.$class,
      spots: spots,
    );

    save<BookReadingRanking>(ranking, '${RankingType.$class.name}$classId')
        .ignore();

    return ranking;
  }

  @override
  Future<BookReadingRanking?> getCountryBookReadingRanking(int schoolId) async {
    final spots =
        await _getReadingSpots('app/book_readed_ranking/country/$schoolId');
    final ranking = BookReadingRanking(
      id: schoolId,
      type: RankingType.country,
      spots: spots,
    );

    save<BookReadingRanking>(ranking, '${RankingType.country.name}$schoolId')
        .ignore();

    return ranking;
  }

  @override
  Future<BookReadingRanking?> getGlobalBookReadingRanking() async {
    final spots = await _getReadingSpots('app/book_readed_ranking/all');
    final ranking = BookReadingRanking(
      type: RankingType.global,
      spots: spots,
    );

    save<BookReadingRanking>(ranking, RankingType.global.name).ignore();

    return ranking;
  }

  @override
  Future<BookReadingRanking?> getSchoolBookReadingRanking(int schoolId) async {
    final spots =
        await _getReadingSpots('app/book_readed_ranking/school/$schoolId');
    final ranking = BookReadingRanking(
      id: schoolId,
      type: RankingType.school,
      spots: spots,
    );

    save<BookReadingRanking>(ranking, '${RankingType.school.name}$schoolId')
        .ignore();

    return ranking;
  }

  @override
  Future<BookReadingRanking?> getStateBookReadingRanking(int schoolId) async {
    final spots =
        await _getReadingSpots('app/book_readed_ranking/state/$schoolId');
    final ranking = BookReadingRanking(
      id: schoolId,
      type: RankingType.state,
      spots: spots,
    );

    save<BookReadingRanking>(ranking, '${RankingType.state.name}$schoolId')
        .ignore();

    return ranking;
  }

  Future<List<BookRankingSpot>> _getSpots(
    String endpoint, [
    int? id,
  ]) {
    return ref
        .read(restApiProvider)
        .get('$endpoint${id == null ? '' : '/$id'}')
        .then((response) => (response as List).cast<Json>())
        .then((list) => _rankify(list).map(BookRankingSpot.fromJson).toList());
  }

  Future<List<BookReadingRankingSpot>> _getReadingSpots(
    String endpoint, [
    int? id,
  ]) {
    return ref
        .read(restApiProvider)
        .get('$endpoint${id == null ? '' : '/$id'}')
        .then((response) => (response as List).cast<Json>())
        .then(
          (list) => _rankifyReading(list)
              .map(BookReadingRankingSpot.fromJson)
              .toList(),
        );
  }
}

class OfflineBookRankingRepository extends BookRankingRepository {
  const OfflineBookRankingRepository(super.ref);

  @override
  Future<BookRanking?> getCityBookRanking(int schoolId) {
    return _getRanking(RankingType.city, schoolId);
  }

  @override
  Future<BookRanking?> getClassBookRanking(int classId) {
    return _getRanking(RankingType.$class, classId);
  }

  @override
  Future<BookRanking?> getCountryBookRanking(int schoolId) {
    return _getRanking(RankingType.country, schoolId);
  }

  @override
  Future<BookRanking?> getSchoolBookRanking(int schoolId) {
    return _getRanking(RankingType.school, schoolId);
  }

  @override
  Future<BookRanking?> getStateBookRanking(int schoolId) {
    return _getRanking(RankingType.state, schoolId);
  }

  @override
  Future<BookRanking?> getGlobalBookRanking() {
    return _getRanking(RankingType.global);
  }

  @override
  Future<BookReadingRanking?> getCityBookReadingRanking(int schoolId) {
    return _getReadingRanking(RankingType.city, schoolId);
  }

  @override
  Future<BookReadingRanking?> getClassBookReadingRanking(int classId) {
    return _getReadingRanking(RankingType.$class, classId);
  }

  @override
  Future<BookReadingRanking?> getCountryBookReadingRanking(int schoolId) {
    return _getReadingRanking(RankingType.country, schoolId);
  }

  @override
  Future<BookReadingRanking?> getGlobalBookReadingRanking() {
    return _getReadingRanking(RankingType.global);
  }

  @override
  Future<BookReadingRanking?> getSchoolBookReadingRanking(int schoolId) {
    return _getReadingRanking(RankingType.school, schoolId);
  }

  @override
  Future<BookReadingRanking?> getStateBookReadingRanking(int schoolId) {
    return _getReadingRanking(RankingType.state, schoolId);
  }

  Future<BookRanking?> _getRanking(RankingType type, [int? id]) {
    return ref
        .read(databaseProvider)
        .getById<BookRanking>('${type.name}${id ?? ''}');
  }

  Future<BookReadingRanking?> _getReadingRanking(RankingType type, [int? id]) {
    return ref
        .read(databaseProvider)
        .getById<BookReadingRanking>('${type.name}${id ?? ''}');
  }
}

abstract class BookRankingRepository extends Repository with OfflinePersister {
  const BookRankingRepository(super.ref);

  List<Json> _rankify(List<Json> spots) {
    var rank = 1;
    var max = double.tryParse(
          (spots.firstOrNull?['rating_avg'] as String?) ?? '',
        ) ??
        0.0;

    for (final spot in spots) {
      if (double.parse(spot['rating_avg'] as String) < max) {
        max = double.parse(spot['rating_avg'] as String);
        rank = rank + 1;
      }
      spot['rank'] = rank;
    }

    return spots;
  }

  List<Json> _rankifyReading(List<Json> spots) {
    var rank = 1;
    var max = spots.firstOrNull?['total'] as int;

    for (final spot in spots) {
      if (spot['total'] as int < max) {
        max = spot['total'] as int;
        rank = rank + 1;
      }
      spot['rank'] = rank;
    }

    return spots;
  }

  Future<BookRanking?> getClassBookRanking(int classId);
  Future<BookRanking?> getSchoolBookRanking(int schoolId);
  Future<BookRanking?> getCityBookRanking(int schoolId);
  Future<BookRanking?> getStateBookRanking(int schoolId);
  Future<BookRanking?> getCountryBookRanking(int schoolId);
  Future<BookRanking?> getGlobalBookRanking();
  Future<BookReadingRanking?> getClassBookReadingRanking(int classId);
  Future<BookReadingRanking?> getSchoolBookReadingRanking(int schoolId);
  Future<BookReadingRanking?> getCityBookReadingRanking(int schoolId);
  Future<BookReadingRanking?> getStateBookReadingRanking(int schoolId);
  Future<BookReadingRanking?> getCountryBookReadingRanking(int schoolId);
  Future<BookReadingRanking?> getGlobalBookReadingRanking();
}
