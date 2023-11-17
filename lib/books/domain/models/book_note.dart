import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/profile/domain/models/user.dart';
import 'package:reading/shared/domain/has_creation_date.dart';
import 'package:reading/shared/domain/local_datetime_converter.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'book_note.freezed.dart';
part 'book_note.g.dart';

@Freezed(fallbackUnion: 'default')
@HiveType(typeId: 12)
class BookNote with _$BookNote, HiveObjectMixin, HasCreationDate {
  @With<HiveObjectMixin>()
  factory BookNote({
    @HiveField(0) int? id,
    @HiveField(1) required String title,
    @HiveField(2) required String description,
    @HiveField(3) required User user,
    @HiveField(4) @LocalDateTimeConverter() DateTime? createdAt,
    @HiveField(5) @Default([]) List<BookNote> replies,
    @HiveField(6) @JsonKey(name: 'reading_id') int? bookId,
    @HiveField(7) int? noteId,
  }) = _BookNote;

  @With<HiveObjectMixin>()
  BookNote._();

  factory BookNote.fromJson(Json json) => _$BookNoteFromJson(json);
}
