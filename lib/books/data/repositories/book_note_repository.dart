import 'package:reading/books/data/dtos/new_note_dto.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:reading/books/domain/value_objects/description.dart';
import 'package:reading/books/domain/value_objects/title.dart';
import 'package:reading/profile/data/repositories/profile_repository.dart';
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
    final notes = await ref
        .read(databaseProvider) //
        .getAll<OfflineBookNote>();

    for (final note in notes) {
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
  Future<void> addNote(int bookId, NewNoteDTO data) async {
    final note = await ref
        .read(restApiProvider)
        .post('books/$bookId/notes', body: data.toJson())
        .then((response) => BookNote.fromJson(response as Json));

    ref.read(databaseProvider).update(note, note.id).ignore();
  }

  @override
  Future<List<BookNote>> getBookNotes(int bookId) async {
    final notes = await ref
        .read(restApiProvider)
        .get('books/$bookId/notes')
        .then((response) => (response as List<Json>).map(BookNote.fromJson))
        .then((bookNotes) => bookNotes.toList());

    ref.read(databaseProvider).updateAll(notes, (note) => note.id).ignore();

    return notes;
  }
}

class OfflineBookNoteRepository extends BookNoteRepository {
  const OfflineBookNoteRepository(super.db);

  @override
  Future<void> addNote(int bookId, NewNoteDTO data) {
    final bookNote = OfflineBookNote(
      title: data.title.value,
      description: data.description.value,
      author: ref.read(profileProvider).toUser(),
      bookId: bookId,
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
  Future<void> addNote(int bookId, NewNoteDTO data);
}
