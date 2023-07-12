import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/common/infrastructure/rest_api.dart';
import 'package:reading/profile/domain/models/user.dart';

part 'book_note.freezed.dart';
part 'book_note.g.dart';

@freezed
class BookNote with _$BookNote {
  const factory BookNote({
    required String title,
    required String description,
    required User author,
    required DateTime createdAt,
    @Default([]) List<BookNote> responses,
  }) = _BookNote;

  factory BookNote.fromJson(Json json) => _$BookNoteFromJson(json);
}
