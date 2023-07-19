import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/domain/models/book.dart';

double useBookReadPercentage(Book book) {
  return useMemoized(
    () => book.pagesRead / book.pageCount * 100.0,
    [book.pageCount, book.pagesRead],
  );
}
