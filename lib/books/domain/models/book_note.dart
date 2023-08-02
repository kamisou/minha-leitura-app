import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/profile/domain/models/user.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'book_note.freezed.dart';
part 'book_note.g.dart';

@freezed
@HiveType(typeId: 12)
class BookNote with _$BookNote {
  const factory BookNote({
    @HiveField(0) required int id,
    @HiveField(1) required String title,
    @HiveField(2) required String description,
    @HiveField(3) required User author,
    @HiveField(4) required DateTime createdAt,
    @HiveField(5) @Default([]) List<BookNote> responses,
    @HiveField(6) required int parentId,
  }) = _BookNote;

  const factory BookNote.offline({
    @HiveField(0) int? id,
    @HiveField(1) required String title,
    @HiveField(2) required String description,
    @HiveField(3) required User author,
    @HiveField(4) DateTime? createdAt,
    @HiveField(5) @Default([]) List<BookNote> responses,
    @HiveField(6) required int parentId,
  }) = OfflineBookNote;

  factory BookNote.fromJson(Json json) => _$BookNoteFromJson(json);
}
