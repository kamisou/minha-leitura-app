import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';

@freezed
class Book with _$Book {
  const factory Book({
    required int id,
    required String coverArt,
    required String title,
    required int pageCount,
    required int pagesRead,
  }) = _Book;
}
