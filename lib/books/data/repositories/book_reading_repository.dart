import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/books/domain/models/book_reading.dart';
import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/shared/application/repository_service.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_reading_repository.g.dart';

@riverpod
Future<List<BookReading>> bookReadings(BookReadingsRef ref, int bookId) {
  return ref
      .read(repositoryServiceProvider)<BookReadingRepository>()
      .getBookReadings(bookId);
}

class OnlineBookReadingRepository extends OnlineRepository
    with OfflineAwareOnlineRepository
    implements BookReadingRepository {
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

class OfflineBookReadingRepository extends OfflineRepository
    implements BookReadingRepository {
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

abstract class BookReadingRepository {
  const BookReadingRepository(this.ref);

  final Ref ref;

  Future<List<BookReading>> getBookReadings(int bookId);
  Future<void> addReading(int bookId, Pages pages);
}
