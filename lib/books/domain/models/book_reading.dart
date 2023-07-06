import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/common/infrastructure/rest_api.dart';

part 'book_reading.freezed.dart';
part 'book_reading.g.dart';

@freezed
class BookReading with _$BookReading {
  const factory BookReading({
    required int pages,
    required DateTime date,
  }) = _BookReading;

  factory BookReading.fromJson(Json json) => _$BookReadingFromJson(json);
}
