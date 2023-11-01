import 'package:reading/books/data/repositories/book_note_repository.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_notes.g.dart';

@riverpod
Future<List<BookNote>> bookNotes(BookNotesRef ref, int bookId) {
  return ref.read(bookNoteRepositoryProvider).getBookNotes(bookId);
}
