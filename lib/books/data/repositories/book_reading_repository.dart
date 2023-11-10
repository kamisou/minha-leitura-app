import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/books/data/cached/books.dart';
import 'package:reading/books/data/dtos/new_reading_dto.dart';
import 'package:reading/books/domain/models/book_reading.dart';
import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/shared/data/cached/connection_status.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_reading_repository.g.dart';

@riverpod
BookReadingRepository bookReadingRepository(BookReadingRepositoryRef ref) {
  return ref.read(isConnectedProvider)
      ? OnlineBookReadingRepository(ref)
      : OfflineBookReadingRepository(ref);
}

class OnlineBookReadingRepository extends BookReadingRepository
    with OfflineUpdatePusher {
  const OnlineBookReadingRepository(super.ref);

  @override
  Future<void> updateReading(int bookId, NewReadingDTO data) async {
    final reading = await ref
        .read(restApiProvider)
        .put('app/reading/$bookId', body: data.toJson())
        .then((response) => BookReading.fromJson(response as Json));

    await save<BookReading>(reading, reading.id);

    return super.updateReading(bookId, data);
  }

  @override
  Future<List<BookReading>> getBookReadings(int bookId) async {
    final readings = await ref
        .read(restApiProvider)
        .get('books/$bookId/readings')
        .then((response) => (response as List<Json>).map(BookReading.fromJson))
        .then((bookReadings) => bookReadings.toList());

    saveAll<BookReading>(readings, (value) => value.id).ignore();

    return readings;
  }

  @override
  Future<void> pushUpdates() async {
    final readings = await ref
        .read(databaseProvider) //
        .getAll<OfflineBookReading>();

    for (final reading in readings) {
      final data = NewReadingDTO(
        page: Pages(reading.page),
      );

      await updateReading(reading.bookId, data);
    }
  }
}

class OfflineBookReadingRepository extends BookReadingRepository {
  const OfflineBookReadingRepository(super.ref);

  @override
  Future<void> updateReading(int bookId, NewReadingDTO data) async {
    final reading = OfflineBookReading(
      page: data.page.value!,
      createdAt: DateTime.now().toUtc(),
      bookId: bookId,
    );

    await save<OfflineBookReading>(reading);

    return super.updateReading(bookId, data);
  }

  @override
  Future<List<BookReading>> getBookReadings(int bookId) {
    final db = ref.read(databaseProvider);

    return Future.wait([
      db.getWhere<BookReading>((reading) => reading.bookId == bookId),
      db.getWhere<OfflineBookReading>((reading) => reading.bookId == bookId),
    ]) //
        .then((readings) => [...readings.first, ...readings.last]);
  }
}

abstract class BookReadingRepository extends Repository with OfflinePersister {
  const BookReadingRepository(super.ref);

  @mustCallSuper
  @mustBeOverridden
  Future<void> updateReading(int bookId, NewReadingDTO data) async {
    return ref.read(myBooksProvider.notifier).refresh();
  }

  Future<List<BookReading>> getBookReadings(int bookId);
}
