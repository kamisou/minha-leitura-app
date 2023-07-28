import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/profile/domain/models/user.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

part 'book_note.freezed.dart';
part 'book_note.g.dart';

@freezed
@HiveType(typeId: 9)
class BookNote with _$BookNote {
  @Assert('bookId != null || noteId != null', 'BookNote needs a parent id!')
  const factory BookNote({
    @HiveField(0) required int id,
    @HiveField(1) required String title,
    @HiveField(2) required String description,
    @HiveField(3) required User author,
    @HiveField(4) required DateTime createdAt,
    @HiveField(5) @Default([]) List<BookNote> responses,
    @HiveField(6) int? bookId,
    @HiveField(7) int? noteId,
  }) = _BookNote;

  factory BookNote.fromJson(Json json) => _$BookNoteFromJson(json);

  const BookNote._();

  int get parentId => bookId ?? noteId!;
}

@HiveType(typeId: 109)
class OfflineBookNote {
  OfflineBookNote({
    required this.title,
    required this.description,
    required this.author,
    this.bookId,
    this.noteId,
  }) : assert(bookId != null || noteId != null, 'BookNote needs a parent id!');

  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final User author;

  @HiveField(3)
  final int? bookId;

  @HiveField(4)
  final int? noteId;

  @HiveField(5)
  int get parentId => bookId ?? noteId!;
}
