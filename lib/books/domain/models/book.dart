import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/shared/domain/book_cover_converter.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
@HiveType(typeId: 5)
class Book with _$Book {
  const factory Book({
    @HiveField(0) required int id,
    @HiveField(1) @BookCoverConverter() Uint8List? cover,
    @HiveField(2) required String title,
    @HiveField(3) required String author,
    @HiveField(4) required int pages,
  }) = _Book;

  factory Book.fromJson(Json json) => _$BookFromJson(json);
}
