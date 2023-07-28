import 'package:reading/authentication/data/repositories/auth_repository.dart';
import 'package:reading/books/data/dtos/new_note_dto.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:reading/books/domain/value_objects/description.dart';
import 'package:reading/books/domain/value_objects/title.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_note_repository.g.dart';

@riverpod
BookNoteRepository bookNoteRepository(BookNoteRepositoryRef ref) {
  return ref.read(isConnectedProvider)
      ? OnlineBookNoteRepository(ref)
      : OfflineBookNoteRepository(ref);
}

@riverpod
Future<List<BookNote>> bookNotes(BookNotesRef ref, int bookId) {
  return ref.read(bookNoteRepositoryProvider).getBookNotes(bookId);
}

class OnlineBookNoteRepository extends BookNoteRepository
    with OfflineAwareOnlineRepository {
  const OnlineBookNoteRepository(super.ref);

  @override
  Future<void> commitOfflineUpdates() async {
    final bookNotes = await ref
        .read(databaseProvider) //
        .getAll<OfflineBookNote>();

    for (final note in bookNotes) {
      await addNote(
        note.bookId!,
        NewNoteDTO(
          title: Title(note.title),
          description: Description(note.description),
        ),
      );
    }
  }

  @override
  Future<void> addNote(int bookId, NewNoteDTO note) {
    return ref
        .read(restApiProvider)
        .post('books/$bookId/notes', body: note.toJson());
  }

  @override
  Future<List<BookNote>> getBookNotes(int bookId) {
    return ref
        .read(restApiProvider)
        .get('books/$bookId/notes')
        .then((response) => (response as List<Json>).map(BookNote.fromJson))
        .then((bookNotes) => bookNotes.toList());
  }
}

class OfflineBookNoteRepository extends BookNoteRepository {
  const OfflineBookNoteRepository(super.db);

  @override
  Future<void> addNote(int bookId, NewNoteDTO note) {
    final bookNote = OfflineBookNote(
      title: note.title.value,
      description: note.description.value,
      author: ref.read(userProvider)!.toUser(),
    );

    return ref.read(databaseProvider).insert(bookNote);
  }

  @override
  Future<List<BookNote>> getBookNotes(int bookId) {
    return ref
        .read(databaseProvider)
        .getWhere((value) => value.bookId == bookId);
  }
}

abstract class BookNoteRepository extends Repository {
  const BookNoteRepository(super.ref);

  Future<List<BookNote>> getBookNotes(int bookId);
  Future<void> addNote(int bookId, NewNoteDTO note);
}
