import 'package:reading/books/data/dtos/new_note_dto.dart';
import 'package:reading/books/data/repositories/book_note_repository.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_note_controller.g.dart';

@riverpod
class NewNoteController extends _$NewNoteController {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addNote(int bookId, NewNoteDTO data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(bookNoteRepositoryProvider).addNote(bookId, data),
    );
  }

  Future<void> replyNote(int bookId, int noteId, NewNoteDTO data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () =>
          ref.read(bookNoteRepositoryProvider).replyNote(bookId, noteId, data),
    );
  }

  Future<void> removeNote(BookNote note) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(bookNoteRepositoryProvider).removeNote(note),
    );
  }

  Future<void> updateNote(BookNote note, NewNoteDTO data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(bookNoteRepositoryProvider).updateNote(note, data),
    );
  }
}
