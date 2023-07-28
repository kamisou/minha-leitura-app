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
  return ref.read(isConnectedProvider)
      ? OnlineBookReadingRepository(ref)
      : OfflineBookReadingRepository(ref);
}

@riverpod
Future<List<BookReading>> bookReadings(BookReadingsRef ref, int bookId) {
  return ref.read(bookReadingRepositoryProvider).getBookReadings(bookId);
}

class OnlineBookReadingRepository extends BookReadingRepository
    with OfflineAwareOnlineRepository {
  const OnlineBookReadingRepository(super.ref);

  @override
  Future<void> commitOfflineUpdates() async {
    final offlineBookReadings = await ref
        .read(databaseProvider) //
        .getAll<OfflineBookReading>();

    for (final reading in offlineBookReadings) {
      await addReading(reading.bookId, Pages(reading.pages));
    }
  }

  @override
  Future<void> addReading(int bookId, Pages pages) {
    return ref
        .read(restApiProvider)
        .post('books/$bookId/readings', body: {'pages': pages.value});
  }

  @override
  Future<List<BookReading>> getBookReadings(int bookId) async {
    return ref
        .read(restApiProvider)
        .get('books/$bookId/readings')
        .then((response) => (response as List<Json>).map(BookReading.fromJson))
        .then((bookReadings) => bookReadings.toList());
  }
}

class OfflineBookReadingRepository extends BookReadingRepository {
  const OfflineBookReadingRepository(super.ref);

  @override
  Future<void> addReading(int bookId, Pages pages) {
    final bookReading = OfflineBookReading(bookId: bookId, pages: pages.value!);
    return ref.read(databaseProvider).insert(bookReading);
  }

  @override
  Future<List<BookReading>> getBookReadings(int bookId) {
    return ref
        .read(databaseProvider)
        .getWhere((value) => value.bookId == bookId);
  }
}

abstract class BookReadingRepository extends Repository {
  const BookReadingRepository(super.ref);

  Future<List<BookReading>> getBookReadings(int bookId);
  Future<void> addReading(int bookId, Pages pages);
}
