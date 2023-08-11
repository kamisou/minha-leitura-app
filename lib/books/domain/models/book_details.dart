import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'book_details.freezed.dart';
part 'book_details.g.dart';

@HiveType(typeId: 13)
enum BookStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  reading,
  @HiveField(2)
  finished,
}

@freezed
@HiveType(typeId: 6)
class BookDetails with _$BookDetails {
  const factory BookDetails({
    @HiveField(0) required int id,
    @HiveField(1) required DateTime startedAt,
    @HiveField(2) DateTime? finishedAt,
    @HiveField(3) required BookStatus status,
    @HiveField(4) required double percentageRead,
    @HiveField(5) required int actualPage,
    @HiveField(6) required Book book,
  }) = _BookDetails;

  factory BookDetails.fromJson(Json json) => _$BookDetailsFromJson(json);
}
