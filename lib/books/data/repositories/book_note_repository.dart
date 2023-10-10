// ignore_for_file: avoid_dynamic_calls

import 'package:freezed_annotation/freezed_annotation.dart';
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
    with OfflineUpdatePusher {
  const OnlineBookNoteRepository(super.ref);

  @override
  Future<void> addNote(int bookId, NewNoteDTO data) async {
    final note = await ref.read(restApiProvider).post(
      'app/note',
      body: {
        ...data.toJson(),
        'reading_id': bookId,
      },
    ).then((response) {
      response['author'] = response['user']['name'];
      response['parent_id'] = response['reading_id'];
      return BookNote.fromJson(response as Json);
    });

    await save<BookNote>(note, note.id);

    return super.addNote(bookId, data);
  }

  @override
  Future<List<BookNote>> getBookNotes(int bookId) async {
    final notes = await ref
        .read(restApiProvider)
        .get('app/note/reading/$bookId')
        .then((response) => (response as Json)['notes'])
        .then(
          (list) => (list as List)
              .cast<Json>()
              .map((note) => BookNote.fromJson({...note, 'parent_id': bookId})),
        )
        .then((notes) => notes.toList());

    saveAll<BookNote>(notes, (note) => note.id!).ignore();

    return notes;
  }

  @override
  Future<void> updateNote(BookNote note, NewNoteDTO data) async {
    final newNote = await ref
        .read(restApiProvider)
        .put('app/note/${note.id}', body: data.toJson())
        .then((response) {
      response['author'] = response['user']['name'];
      response['parent_id'] = response['reading_id'];
      return BookNote.fromJson(response as Json);
    });

    await save<BookNote>(newNote, note.id);

    return super.updateNote(note, data);
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
        await updateNote(note, data);
      }
    }
  }

  @override
  Future<void> removeNote(BookNote note) async {
    await ref.read(restApiProvider).delete('app/note/${note.id}');

    ref.read(databaseProvider).removeById<BookNote>(note.id).ignore();

    return super.removeNote(note);
  }
}

class OfflineBookNoteRepository extends BookNoteRepository {
  const OfflineBookNoteRepository(super.db);

  @override
  Future<void> addNote(int bookId, NewNoteDTO data) async {
    final note = OfflineBookNote(
      title: data.title.value,
      description: data.description.value,
      author: ref.read(profileProvider).requireValue!.name,
      parentId: bookId,
    );

    await save<OfflineBookNote>(note);

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
  Future<void> updateNote(BookNote note, NewNoteDTO data) async {
    final db = ref.read(databaseProvider);

    var newNote = await (note.id == null
        ? db.getById<OfflineBookNote>(note.key)
        : db.getById<BookNote>(note.id));

    newNote = newNote.copyWith(
      title: data.title.value,
      description: data.description.value,
    );

    await save<OfflineBookNote>(note as OfflineBookNote, note.id);

    return super.updateNote(note, data);
  }

  @override
  Future<void> removeNote(BookNote note) {
    return ref.read(databaseProvider).removeById<OfflineBookNote>(note.id);
  }
}

abstract class BookNoteRepository extends Repository with OfflinePersister {
  const BookNoteRepository(super.ref);

  @mustCallSuper
  @mustBeOverridden
  Future<void> addNote(int bookId, NewNoteDTO data) async {
    ref.invalidate(bookNotesProvider);
  }

  Future<List<BookNote>> getBookNotes(int bookId);

  @mustCallSuper
  @mustBeOverridden
  Future<void> updateNote(BookNote note, NewNoteDTO data) async {
    ref.invalidate(bookNotesProvider);
  }

  @mustBeOverridden
  Future<void> removeNote(BookNote note) async {
    ref.invalidate(bookNotesProvider);
  }
}
