import 'dart:convert';
import 'dart:typed_data';

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
    @CoverConverter() @HiveField(1) Uint8List? cover,
    @HiveField(2) required String title,
    @HiveField(3) String? author,
    @HiveField(4) int? pages,
  }) = _Book;

  factory Book.fromJson(Json json) => _$BookFromJson(json);
}

class CoverConverter implements JsonConverter<Uint8List, String> {
  const CoverConverter();

  @override
  Uint8List fromJson(String json) => base64.decode(json);

  @override
  String toJson(Uint8List object) => base64.encode(object);
}
