import 'package:reading/books/data/dtos/new_note_dto.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:reading/profile/domain/models/user.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_note_repository.g.dart';

@riverpod
BookNoteRepository bookNoteRepository(BookNoteRepositoryRef ref) {
  return FakeBookNoteRepository(ref);

  return ref.read(isConnectedProvider)
      ? OnlineBookNoteRepository(ref)
      : OfflineBookNoteRepository(ref);
}

@riverpod
Future<List<BookNote>> bookNotes(BookNotesRef ref, int bookId) {
  return ref.read(bookNoteRepositoryProvider).getBookNotes(bookId);
}

class OnlineBookNoteRepository extends BookNoteRepository
    with OfflineUpdatePusher, OfflinePersister {
  const OnlineBookNoteRepository(super.ref);

  @override
  Future<void> addNote(int bookId, NewNoteDTO data) async {
    final note = await ref
        .read(restApiProvider)
        .post('books/$bookId/notes', body: data.toJson())
        .then((response) => BookNote.fromJson(response as Json));

    save(note, note.id);
  }

  @override
  Future<List<BookNote>> getBookNotes(int bookId) async {
    final notes = await ref
        .read(restApiProvider)
        .get('books/$bookId/notes')
        .then((response) => (response as List<Json>).map(BookNote.fromJson))
        .then((bookNotes) => bookNotes.toList());

    return saveAll(notes, (note) => note.id);
  }

  @override
  Future<void> updateNote(int bookId, int noteId, NewNoteDTO data) async {
    final note = await ref
        .read(restApiProvider)
        .put('books/$bookId/notes', body: data.toJson())
        .then((response) => BookNote.fromJson(response as Json));

    save(note, note.id);
  }

  @override
  Future<void> pushUpdates() {
    // TODO: implement pushUpdates
    throw UnimplementedError();
  }
}

class OfflineBookNoteRepository extends BookNoteRepository {
  const OfflineBookNoteRepository(super.db);

  @override
  Future<void> addNote(int bookId, NewNoteDTO data) {
    // TODO: implement addNote
    throw UnimplementedError();
  }

  @override
  Future<List<BookNote>> getBookNotes(int bookId) {
    // TODO: implement getBookNotes
    throw UnimplementedError();
  }

  @override
  Future<void> updateNote(int bookId, int noteId, NewNoteDTO data) {
    // TODO: implement updateNote
    throw UnimplementedError();
  }
}

class FakeBookNoteRepository extends BookNoteRepository {
  const FakeBookNoteRepository(super.ref);

  @override
  Future<void> addNote(int bookId, NewNoteDTO data) async {
    return;
  }

  @override
  Future<List<BookNote>> getBookNotes(int bookId) async {
    return [
      BookNote(
        id: 1,
        title: 'Reflexão',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi'
            ' egestas porttitor nunc...',
        author: const User(id: 1, name: 'Guilherme'),
        createdAt: DateTime(2022, 09, 26, 15, 26, 30),
        responses: [
          BookNote(
            id: 2,
            title: 'Título XPTO',
            description:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi'
                ' egestas porttitor nunc...',
            author: const User(id: 1, name: 'Fulano de Tal'),
            createdAt: DateTime(2022, 09, 26, 15, 28, 30),
            noteId: 1,
          ),
        ],
        bookId: bookId,
      ),
      BookNote(
        id: 3,
        title: 'Dica de rotina matinal ',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi'
            ' egestas porttitor nunc...',
        author: const User(id: 2, name: 'Guilherme'),
        createdAt: DateTime(2022, 09, 27, 16, 0, 10),
        bookId: bookId,
      ),
    ];
  }

  @override
  Future<void> updateNote(int bookId, int noteId, NewNoteDTO data) async {
    return;
  }
}

abstract class BookNoteRepository extends Repository {
  const BookNoteRepository(super.ref);

  Future<void> addNote(int bookId, NewNoteDTO data);
  Future<List<BookNote>> getBookNotes(int bookId);
  Future<void> updateNote(int bookId, int noteId, NewNoteDTO data);
}
