import 'package:reading/books/data/cached/books.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_details.g.dart';

@riverpod
BookDetails bookDetails(BookDetailsRef ref, int id) {
  return ref
      .watch(myBooksProvider)
      .requireValue
      .data
      .firstWhere((book) => book.id == id);
}
