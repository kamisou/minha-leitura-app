import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
@HiveType(typeId: 5)
class Book with _$Book {
  const factory Book({
    @HiveField(0) required int id,
    @HiveField(1) String? coverArt,
    @HiveField(2) required String title,
    @HiveField(3) required String author,
    @HiveField(4) required int pageCount,
    @HiveField(5) required int pagesRead,
  }) = _Book;

  factory Book.fromJson(Json json) => _$BookFromJson(json);
}
