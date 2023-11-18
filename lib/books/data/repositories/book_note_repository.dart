import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/books/data/cached/book_notes.dart';
import 'package:reading/books/data/dtos/new_note_dto.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:reading/books/domain/value_objects/description.dart';
import 'package:reading/books/domain/value_objects/title.dart';
import 'package:reading/profile/data/cached/profile.dart';
import 'package:reading/shared/data/cached/connection_status.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
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

class OnlineBookNoteRepository extends BookNoteRepository
    with OfflineUpdatePusher {
  OnlineBookNoteRepository(super.ref) {
    pushUpdates();
  }

  @override
  Future<void> addNote(int bookId, NewNoteDTO data) async {
    final body = {
      ...data.toJson(),
      'reading_id': bookId,
    };

    final note = await ref
        .read(restApiProvider)
        .post('app/note', body: body)
        .then((response) => BookNote.fromJson(response as Json));

    await save<BookNote>(note, note.id);

    return super.addNote(bookId, data);
  }

  @override
  Future<void> replyNote(int bookId, int noteId, NewNoteDTO data) async {
    final body = {
      ...data.toJson(),
      'reading_id': bookId,
      'note_id': noteId,
    };

    final note = await ref
        .read(restApiProvider)
        .post('app/note', body: body)
        .then((response) => BookNote.fromJson(response as Json));

    await save<BookNote>(note, note.id);

    ref.invalidate(bookNotesProvider);
  }

  @override
  Future<List<BookNote>> getBookNotes(int bookId) async {
    final notes = await ref
        .read(restApiProvider)
        .get('app/note/reading/$bookId')
        .then((response) => (response as Json)['notes'])
        .then((list) => (list as List).cast<Json>())
        .then(
          (list) => list.map(
            (json) {
              json['user'] = {
                'id': json['author_id'],
                'name': json['author'],
              };

              json['reading_id'] = bookId;
              json['replies'] =
                  (json['replies'] as List).cast<Json>().map((reply) {
                reply['user'] = {
                  'id': reply['author_id'],
                  'name': reply['author'],
                };
                reply['reading_id'] = bookId;

                return reply;
              }).toList();

              return BookNote.fromJson(json);
            },
          ).toList(),
        );

    saveAll<BookNote>(notes, (note) => note.id).ignore();

    return notes;
  }

  @override
  Future<void> updateNote(BookNote note, NewNoteDTO data) async {
    final newNote = await ref
        .read(restApiProvider)
        .put('app/note/${note.id}', body: data.toJson())
        .then((response) => BookNote.fromJson(response as Json));

    await save<BookNote>(newNote, note.id);

    return super.updateNote(note, data);
  }

  @override
  Future<void> pushUpdates() async {
    final db = ref.read(databaseProvider);
    final notes = await db.getAll<BookNote>();

    for (final note in notes) {
      if (note.id != null &&
          !note.markedForDeletion &&
          !note.markedForEditing) {
        continue;
      }

      final data = NewNoteDTO(
        description: Description(note.description),
        title: Title(note.title),
      );

      if (note.id == null) {
        if (note.noteId != null) {
          await replyNote(note.bookId!, note.noteId!, data);
        } else {
          await addNote(note.bookId!, data);
        }
      } else {
        if (note.markedForDeletion) {
          await removeNote(note);
        } else if (note.markedForEditing) {
          await updateNote(note, data);
        }
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
    final note = BookNote(
      title: data.title.value,
      description: data.description.value,
      user: ref.read(profileProvider).requireValue!.toUser(),
      bookId: bookId,
    );

    await save<BookNote>(note);

    return super.addNote(bookId, data);
  }

  @override
  Future<void> replyNote(int bookId, int noteId, NewNoteDTO data) async {
    throw const OnlineOnlyOperationException('replyNote');
  }

  @override
  Future<List<BookNote>> getBookNotes(int bookId) {
    return ref
        .read(databaseProvider)
        .getWhere<BookNote>(
          (note) => note.bookId == bookId && !note.markedForDeletion,
        )
        .then((notes) => notes..sort());
  }

  @override
  Future<void> updateNote(BookNote note, NewNoteDTO data) async {
    if (note.id == null) {
      var newNote = await ref
          .read(databaseProvider) //
          .getById<BookNote>(note.key);

      newNote = newNote!.copyWith(
        title: data.title.value,
        description: data.description.value,
      );

      await save<BookNote>(newNote, note.key);
    } else {
      var newNote = await ref
          .read(databaseProvider) //
          .getById<BookNote>(note.id);

      newNote = newNote!.copyWith(
        title: data.title.value,
        description: data.description.value,
        markedForEditing: true,
      );

      await save<BookNote>(newNote, note.id);
    }

    return super.updateNote(note, data);
  }

  @override
  Future<void> removeNote(BookNote note) async {
    if (note.id == null) {
      await ref.read(databaseProvider).removeById<BookNote>(note.key);
    } else {
      final marked = note.copyWith(markedForDeletion: true);
      await save<BookNote>(marked, note.key);
    }

    return super.removeNote(note);
  }
}

abstract class BookNoteRepository extends Repository with OfflinePersister {
  const BookNoteRepository(super.ref);

  @mustCallSuper
  @mustBeOverridden
  Future<void> addNote(int bookId, NewNoteDTO data) async {
    ref.invalidate(bookNotesProvider);
  }

  Future<void> replyNote(int bookId, int noteId, NewNoteDTO data);
  Future<List<BookNote>> getBookNotes(int bookId);

  @mustCallSuper
  @mustBeOverridden
  Future<void> updateNote(BookNote note, NewNoteDTO data) async {
    ref.invalidate(bookNotesProvider);
  }

  @mustCallSuper
  @mustBeOverridden
  Future<void> removeNote(BookNote note) async {
    ref.invalidate(bookNotesProvider);
  }
}
