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

@Freezed(fallbackUnion: 'default')
@HiveType(typeId: 7)
class BookReading with _$BookReading {
  const factory BookReading({
    @HiveField(0) required int id,
    // TODO: "page" deve ser "pages". no momento representa a página em que parou
    @HiveField(1) required int page,
    @HiveField(2) required DateTime createdAt,
    // TODO: "reading" representa aqui uma leitura ativa do livro. tratado como "book details" em outras partes do app
    @JsonKey(name: 'reading_id') @HiveField(3) required int bookId,
  }) = _BookReading;

  const factory BookReading.offline({
    @HiveField(0) int? id,
    @HiveField(1) required int page,
    @HiveField(2) required DateTime createdAt,
    @JsonKey(name: 'reading_id') @HiveField(3) required int bookId,
  }) = OfflineBookReading;

  factory BookReading.fromJson(Json json) => _$BookReadingFromJson(json);
}
