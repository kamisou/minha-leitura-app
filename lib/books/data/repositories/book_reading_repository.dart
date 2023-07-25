import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/books/domain/models/book_reading.dart';
import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/common/infrastructure/datasources/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_reading_repository.g.dart';

@riverpod
BookReadingRepository bookReadingRepository(BookReadingRepositoryRef ref) {
  return OnlineBookReadingRepository(ref);
}

@riverpod
Future<List<BookReading>> bookReadings(BookReadingsRef ref, int bookId) {
  return ref.read(bookReadingRepositoryProvider).getBookReadings(bookId);
}

abstract class BookReadingRepository {
  const BookReadingRepository(this.ref);

  final Ref ref;

  Future<List<BookReading>> getBookReadings(int bookId);

  Future<void> addReading(int bookId, Pages pages);
}

class OnlineBookReadingRepository extends BookReadingRepository {
  const OnlineBookReadingRepository(super.ref);

  @override
  Future<void> addReading(int bookId, Pages pages) {
    return ref
        .read(restApiProvider)
        .post('books/$bookId/readings', body: {'pages': pages.value});
  }

  @override
  Future<List<BookReading>> getBookReadings(int bookId) {
    return ref
        .read(restApiProvider)
        .get('books/$bookId/readings')
        .then((response) => (response as List<Json>).map(BookReading.fromJson))
        .then((bookReadings) => bookReadings.toList());
  }
}
