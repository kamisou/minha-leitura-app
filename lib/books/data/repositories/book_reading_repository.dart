import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/books/domain/models/book_reading.dart';
import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/shared/infrastructure/datasources/connectivity.dart';
import 'package:reading/shared/infrastructure/datasources/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_reading_repository.g.dart';

@riverpod
BookReadingRepository bookReadingRepository(BookReadingRepositoryRef ref) {
  return ref.watch(isConnectedProvider)
      ? OnlineBookReadingRepository(ref)
      : OfflineBookReadingRepository(ref);
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

class OfflineBookReadingRepository extends BookReadingRepository {
  const OfflineBookReadingRepository(super.ref);

  @override
  Future<void> addReading(int bookId, Pages pages) {
    // TODO(kamisou): métodos para update offline
    throw UnimplementedError();
  }

  @override
  Future<List<BookReading>> getBookReadings(int bookId) {
    // TODO(kamisou): buscar leituras relacionadas com bookId
    throw UnimplementedError();
  }
}
