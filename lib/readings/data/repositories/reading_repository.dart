import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/books/data/repositories/book_repository.dart';
import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/common/infrastructure/rest_api.dart';
import 'package:reading/readings/domain/models/reading.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reading_repository.g.dart';

@riverpod
ReadingRepository readingRepository(ReadingRepositoryRef ref) {
  return ReadingRepository(ref);
}

@riverpod
Future<List<Reading>> bookReadings(BookReadingsRef ref, int bookId) {
  return ref.watch(readingRepositoryProvider).getBookReadings(bookId);
}

class ReadingRepository {
  const ReadingRepository(this.ref);

  final Ref ref;

  Future<List<Reading>> getBookReadings(int bookId) async {
    // final dynamic response =
    //     await ref.read(restApiProvider).get('/book/$bookId/readings');
    // return (response as List).cast<Json>().map(BookNote.fromJson).toList();

    return [
      Reading(
        pages: 22,
        date: DateTime.parse('2021-02-10T18:24:00.000Z'),
      ),
      Reading(
        pages: 9,
        date: DateTime.parse('2021-02-09T19:11:00.000Z'),
      ),
      Reading(
        pages: 4,
        date: DateTime.parse('2021-02-08T20:27:00.000Z'),
      ),
    ];
  }

  Future<void> addReading(int bookId, Pages pages) async {
    await ref
        .read(restApiProvider)
        .post('/book/$bookId/readings', body: {'pages': pages.value});

    ref.invalidate(bookDetailsProvider(bookId));
  }
}
