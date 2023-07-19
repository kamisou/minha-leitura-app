import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/common/infrastructure/rest_api.dart';
import 'package:reading/profile/domain/models/user.dart';

part 'note.freezed.dart';
part 'note.g.dart';

@freezed
class Note with _$Note {
  const factory Note({
    required String title,
    required String description,
    required User author,
    required DateTime createdAt,
    @Default([]) List<Note> responses,
  }) = _Note;

  factory Note.fromJson(Json json) => _$NoteFromJson(json);
}
