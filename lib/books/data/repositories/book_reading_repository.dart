import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/books/data/dtos/new_reading_dto.dart';
import 'package:reading/books/domain/models/book_reading.dart';
import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_reading_repository.g.dart';

@riverpod
BookReadingRepository bookReadingRepository(BookReadingRepositoryRef ref) {
  return FakeBookReadingRepository(ref);

  return ref.read(isConnectedProvider)
      ? OnlineBookReadingRepository(ref)
      : OfflineBookReadingRepository(ref);
}

@riverpod
Future<List<BookReading>> bookReadings(BookReadingsRef ref, int bookId) {
  return ref.read(bookReadingRepositoryProvider).getBookReadings(bookId);
}

class OnlineBookReadingRepository extends BookReadingRepository
    with OfflineUpdatePusher {
  const OnlineBookReadingRepository(super.ref);
  @override
  Future<void> addReading(int bookId, NewReadingDTO data) async {
    final reading = await ref
        .read(restApiProvider)
        .post('books/$bookId/readings', body: data.toJson())
        .then((response) => BookReading.fromJson(response as Json));

    await save<BookReading>(reading, reading.id);

    return super.addReading(bookId, data);
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
        pages: Pages(reading.pages),
        target: Pages(reading.target),
      );

      await addReading(reading.bookId, data);
    }
  }
}

class OfflineBookReadingRepository extends BookReadingRepository {
  const OfflineBookReadingRepository(super.ref);

  @override
  Future<void> addReading(int bookId, NewReadingDTO data) async {
    final reading = OfflineBookReading(
      pages: data.pages.value!,
      target: data.target.value!,
      bookId: bookId,
    );

    await save<OfflineBookReading>(reading);

    return super.addReading(bookId, data);
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

class FakeBookReadingRepository extends BookReadingRepository {
  const FakeBookReadingRepository(super.ref);

  @override
  Future<List<BookReading>> getBookReadings(int bookId) async {
    return [
      BookReading(
        id: 1,
        pages: 22,
        target: 10,
        date: DateTime(2021, 2, 10, 18, 24),
        bookId: bookId,
      ),
      BookReading(
        id: 2,
        pages: 9,
        target: 10,
        date: DateTime(2021, 2, 9, 19, 11),
        bookId: bookId,
      ),
      BookReading(
        id: 3,
        pages: 4,
        target: 10,
        date: DateTime(2021, 2, 8, 20, 27),
        bookId: bookId,
      ),
      BookReading(
        id: 1,
        pages: 14,
        target: 10,
        date: DateTime(2021, 2, 7, 18, 24),
        bookId: bookId,
      ),
    ];
  }
}

abstract class BookReadingRepository extends Repository with OfflinePersister {
  const BookReadingRepository(super.ref);

  @mustCallSuper
  @mustBeOverridden
  Future<void> addReading(int bookId, NewReadingDTO data) async {
    ref.invalidate(bookReadingsProvider);
  }

  Future<List<BookReading>> getBookReadings(int bookId);
}
