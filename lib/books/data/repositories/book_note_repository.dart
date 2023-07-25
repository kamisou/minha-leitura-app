import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/books/data/dtos/new_note_dto.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:reading/common/infrastructure/datasources/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_note_repository.g.dart';

@riverpod
BookNoteRepository bookNoteRepository(BookNoteRepositoryRef ref) {
  return OnlineBookNoteRepository(ref);
}

@riverpod
Future<List<BookNote>> bookNotes(BookNotesRef ref, int bookId) {
  return ref.read(bookNoteRepositoryProvider).getBookNotes(bookId);
}

abstract class BookNoteRepository {
  const BookNoteRepository(this.ref);

  final Ref ref;

  Future<List<BookNote>> getBookNotes(int bookId);

  Future<void> addNote(int bookId, NewNoteDTO note);
}

class OnlineBookNoteRepository extends BookNoteRepository {
  const OnlineBookNoteRepository(super.ref);

  @override
  Future<void> addNote(int bookId, NewNoteDTO note) {
    return ref
        .read(restApiProvider)
        .post('/books/$bookId/notes', body: note.toJson());
  }

  @override
  Future<List<BookNote>> getBookNotes(int bookId) {
    return ref
        .read(restApiProvider)
        .get('/books/$bookId/notes')
        .then((response) => (response as List<Json>).map(BookNote.fromJson))
        .then((bookNotes) => bookNotes.toList());
  }
}
