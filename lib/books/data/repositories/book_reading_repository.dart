import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/books/data/dtos/new_reading_dto.dart';
import 'package:reading/books/data/repositories/book_repository.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/books/domain/models/book_reading.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
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

@riverpod
Future<List<BookReading>> bookReadings(BookReadingsRef ref, int bookId) {
  return ref.read(bookReadingRepositoryProvider).getBookReadings(bookId);
}

@riverpod
BookDetails bookDetails(BookDetailsRef ref, int id) {
  return ref
      .watch(myBooksProvider)
      .requireValue
      .data
      .firstWhere((book) => book.id == id);
}

class OnlineBookReadingRepository extends BookReadingRepository {
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
}

class OfflineBookReadingRepository extends BookReadingRepository {
  const OfflineBookReadingRepository(super.ref);

  @override
  Future<void> updateReading(int bookId, NewReadingDTO data) async {
    throw OnlineOnlyOperationException();
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

  @mustBeOverridden
  Future<void> updateReading(int bookId, NewReadingDTO data) async {
    ref.invalidate(myBooksProvider);
  }

  Future<List<BookReading>> getBookReadings(int bookId);
}
