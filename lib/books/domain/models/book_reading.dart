import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'book_reading.freezed.dart';
part 'book_reading.g.dart';

@Freezed(fallbackUnion: 'default')
@HiveType(typeId: 7)
class BookReading with _$BookReading, HiveObjectMixin {
  @With<HiveObjectMixin>()
  factory BookReading({
    @HiveField(0) int? id,
    @HiveField(1) required int page,
    @HiveField(3) @JsonKey(name: 'reading_id') required int bookId,
  }) = _BookReading;

  factory BookReading.fromJson(Json json) => _$BookReadingFromJson(json);
}
