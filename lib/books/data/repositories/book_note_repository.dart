import 'package:flutter/foundation.dart';
import 'package:reading/books/data/dtos/new_note_dto.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:reading/books/domain/value_objects/description.dart';
import 'package:reading/books/domain/value_objects/title.dart';
import 'package:reading/profile/data/repositories/profile_repository.dart';
import 'package:reading/profile/domain/models/user.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/shared/infrastructure/database.dart';
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
    with OfflineUpdatePusher {
  const OnlineBookNoteRepository(super.ref);

  @override
  Future<void> addNote(int bookId, NewNoteDTO data) async {
    final note = await ref
        .read(restApiProvider)
        .post('books/$bookId/notes', body: data.toJson())
        .then((response) => BookNote.fromJson(response as Json));

    await save(note);

    return super.addNote(bookId, data);
  }

  @override
  Future<List<BookNote>> getBookNotes(int bookId) async {
    final notes = await ref
        .read(restApiProvider)
        .get('books/$bookId/notes')
        .then((response) => (response as List<Json>).map(BookNote.fromJson))
        .then((notes) => notes.toList());

    return saveAll(notes, (note) => note.id!);
  }

  @override
  Future<void> updateNote(int bookId, int noteId, NewNoteDTO data) async {
    final note = await ref
        .read(restApiProvider)
        .put('books/$bookId/notes', body: data.toJson())
        .then((response) => BookNote.fromJson(response as Json));

    await save(note, note.id);

    return super.updateNote(bookId, noteId, data);
  }

  @override
  Future<void> pushUpdates() async {
    final notes = await ref
        .read(databaseProvider) //
        .getAll<OfflineBookNote>();

    for (final note in notes) {
      final data = NewNoteDTO(
        description: Description(note.description),
        title: Title(note.title),
      );

      if (note.id == null) {
        await addNote(note.parentId, data);
      } else {
        await updateNote(note.parentId, note.id!, data);
      }
    }
  }
}

class OfflineBookNoteRepository extends BookNoteRepository {
  const OfflineBookNoteRepository(super.db);

  @override
  Future<void> addNote(int bookId, NewNoteDTO data) async {
    final note = OfflineBookNote(
      title: data.title.value,
      description: data.description.value,
      author: ref.read(profileProvider).toUser(),
      createdAt: DateTime.now(),
      parentId: bookId,
    );

    await save(note);

    return super.addNote(bookId, data);
  }

  @override
  Future<List<BookNote>> getBookNotes(int bookId) async {
    final db = ref.read(databaseProvider);

    return Future.wait([
      db.getWhere<BookNote>((note) => note.parentId == bookId),
      db.getWhere<OfflineBookNote>((note) => note.parentId == bookId),
    ]) //
        .then((notes) => [...notes.first, ...notes.last]);
  }

  @override
  Future<void> updateNote(int bookId, int noteId, NewNoteDTO data) async {
    final db = ref.read(databaseProvider);

    var note = await db
        .getById<BookNote>(noteId)
        .catchError((error) => db.getById<OfflineBookNote>(noteId));

    note = note.copyWith(
      title: data.title.value,
      description: data.description.value,
    );

    await save(note as OfflineBookNote, note.id);

    return super.updateNote(bookId, noteId, data);
  }
}

class FakeBookNoteRepository extends BookNoteRepository {
  const FakeBookNoteRepository(super.ref);

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
            parentId: 1,
          ),
        ],
        parentId: bookId,
      ),
      BookNote(
        id: 3,
        title: 'Dica de rotina matinal ',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi'
            ' egestas porttitor nunc...',
        author: const User(id: 2, name: 'Guilherme'),
        createdAt: DateTime(2022, 09, 27, 16, 0, 10),
        parentId: bookId,
      ),
    ];
  }
}

abstract class BookNoteRepository extends Repository with OfflinePersister {
  const BookNoteRepository(super.ref);

  @mustCallSuper
  Future<void> addNote(int bookId, NewNoteDTO data) async {
    ref.invalidate(bookNotesProvider);
  }

  Future<List<BookNote>> getBookNotes(int bookId);

  @mustCallSuper
  Future<void> updateNote(int bookId, int noteId, NewNoteDTO data) async {
    ref.invalidate(bookNotesProvider);
  }
}
