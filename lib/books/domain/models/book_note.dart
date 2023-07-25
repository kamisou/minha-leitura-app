import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/shared/infrastructure/datasources/rest_api.dart';
import 'package:reading/profile/domain/models/user.dart';

part 'book_note.freezed.dart';
part 'book_note.g.dart';

@freezed
@HiveType(typeId: 7)
class BookNote extends HiveObject with _$BookNote {
  const factory BookNote({
    @HiveField(0) required String title,
    @HiveField(1) required String description,
    @HiveField(2) required User author,
    @HiveField(3) required DateTime createdAt,
    @HiveField(4) @Default([]) List<BookNote> responses,
  }) = _BookNote;

  factory BookNote.fromJson(Json json) => _$BookNoteFromJson(json);
}
