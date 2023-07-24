import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/common/infrastructure/rest_api.dart';

part 'book_reading.freezed.dart';
part 'book_reading.g.dart';

@freezed
@HiveType(typeId: 6)
class BookReading extends HiveObject with _$BookReading {
  const factory BookReading({
    @HiveField(0) required int pages,
    @HiveField(1) required DateTime date,
  }) = _BookReading;

  factory BookReading.fromJson(Json json) => _$BookReadingFromJson(json);
}
