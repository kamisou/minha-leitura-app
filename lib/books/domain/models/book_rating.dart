import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/profile/domain/models/user.dart';
import 'package:reading/shared/domain/local_datetime_converter.dart';
import 'package:reading/shared/domain/rating_converter.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'book_rating.freezed.dart';
part 'book_rating.g.dart';

@Freezed(fallbackUnion: 'default')
@HiveType(typeId: 9)
class BookRating
    with _$BookRating, HiveObjectMixin
    implements Comparable<BookRating> {
  @With<HiveObjectMixin>()
  factory BookRating({
    @HiveField(0) int? id,
    @HiveField(1) @RatingConverter() required double rating,
    @HiveField(2) required String comment,
    @HiveField(3) @JsonKey(name: 'user') required User author,
    @HiveField(4) @LocalDateTimeConverter() DateTime? createdAt,
    @HiveField(5) required int bookId,
    @HiveField(6) @Default(false) bool markedForDeletion,
    @HiveField(7) @Default(false) bool markedForEditing,
  }) = _BookRating;

  @With<HiveObjectMixin>()
  BookRating._();

  factory BookRating.fromJson(Json json) => _$BookRatingFromJson(json);

  @override
  int compareTo(BookRating other) {
    if (createdAt == null) {
      return -1;
    }

    return other.createdAt?.compareTo(createdAt!) ?? 1;
  }
}
