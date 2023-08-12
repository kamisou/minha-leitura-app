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
    @HiveField(1) String? cover,
    @HiveField(2) required String title,
    // TODO: author e pages não deve ser nulável
    @HiveField(3) String? author,
    @HiveField(4) int? pages,
  }) = _Book;

  factory Book.fromJson(Json json) => _$BookFromJson(json);
}
