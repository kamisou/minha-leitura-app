import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
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

@freezed
@HiveType(typeId: 7)
class BookReading with _$BookReading {
  const factory BookReading({
    @HiveField(0) required int id,
    @HiveField(1) required int pages,
    @HiveField(2) required int target,
    @HiveField(3) required DateTime date,
    @HiveField(4) required int bookId,
  }) = _BookReading;

  const factory BookReading.offline({
    @HiveField(0) int? id,
    @HiveField(1) required int pages,
    @HiveField(2) required int target,
    @HiveField(3) DateTime? date,
    @HiveField(4) required int bookId,
  }) = OfflineBookReading;

  const BookReading._();

  factory BookReading.fromJson(Json json) => _$BookReadingFromJson(json);

  BookReadingScore get score {
    final value = pages / target;

    if (value >= 1.0) {
      return BookReadingScore.good;
    }

    if (value >= 0.75) {
      return BookReadingScore.regular;
    }

    return BookReadingScore.bad;
  }
}
