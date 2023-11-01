import 'package:reading/books/data/cached/books.dart';
import 'package:reading/books/data/repositories/book_reading_repository.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/books/domain/models/book_reading.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_readings.g.dart';

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
