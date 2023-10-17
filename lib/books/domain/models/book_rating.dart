import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/profile/domain/models/user.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'book_rating.freezed.dart';
part 'book_rating.g.dart';

@Freezed(fallbackUnion: 'default')
@HiveType(typeId: 9)
class BookRating with _$BookRating {
  const factory BookRating({
    @HiveField(0) required int id,
    @HiveField(1) required double rating,
    @HiveField(2) required String comment,
    @HiveField(3) @JsonKey(name: 'user') required User author,
    @HiveField(4) required DateTime createdAt,
    @HiveField(5) required int bookId,
  }) = _BookRating;

  const factory BookRating.offline({
    @HiveField(0) int? id,
    @HiveField(1) required double rating,
    @HiveField(2) required String comment,
    @HiveField(3) @JsonKey(name: 'user') required User author,
    @HiveField(4) DateTime? createdAt,
    @HiveField(5) required int bookId,
  }) = OfflineBookRating;

  factory BookRating.fromJson(Json json) => _$BookRatingFromJson(json);
}
