import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/shared/domain/local_datetime_converter.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'book_reading.freezed.dart';
part 'book_reading.g.dart';

@HiveType(typeId: 8)
enum BookReadingScore {
  @HiveField(0)
  bad,
  @HiveField(1)
  regular,
  @HiveField(2)
  good,
}

@Freezed(fallbackUnion: 'default')
@HiveType(typeId: 7)
class BookReading with _$BookReading {
  const factory BookReading({
    @HiveField(0) required int id,
    @HiveField(1) required int page,
    @HiveField(2) @LocalDateTimeConverter() required DateTime createdAt,
    @HiveField(3) @JsonKey(name: 'reading_id') required int bookId,
  }) = _BookReading;

  const factory BookReading.offline({
    @HiveField(0) int? id,
    @HiveField(1) required int page,
    @HiveField(2) @LocalDateTimeConverter() required DateTime createdAt,
    @HiveField(3) @JsonKey(name: 'reading_id') required int bookId,
  }) = OfflineBookReading;

  factory BookReading.fromJson(Json json) => _$BookReadingFromJson(json);
}
