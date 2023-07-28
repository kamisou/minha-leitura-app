import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'book_reading.freezed.dart';
part 'book_reading.g.dart';

@freezed
@HiveType(typeId: 6)
class BookReading extends HiveObject with _$BookReading {
  const factory BookReading({
    @HiveField(0) required int pages,
    @HiveField(1) required DateTime date,
    @HiveField(2) required int bookId,
  }) = _BookReading;

  factory BookReading.fromJson(Json json) => _$BookReadingFromJson(json);
}

@HiveType(typeId: 106)
class OfflineBookReading extends HiveObject {
  OfflineBookReading({
    required this.pages,
    required this.bookId,
  });

  @HiveField(0)
  final int bookId;

  @HiveField(1)
  final int pages;
}
