import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/common/infrastructure/rest_api.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
class Book with _$Book {
  const factory Book({
    required int id,
    required String coverArt,
    required String title,
    required String author,
    required int pageCount,
    required int pagesRead,
  }) = _Book;

  factory Book.fromJson(Json json) => _$BookFromJson(json);
}
