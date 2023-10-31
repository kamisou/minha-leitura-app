import 'package:reading/books/data/dtos/new_note_dto.dart';
import 'package:reading/books/data/repositories/book_note_repository.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_note_controller.g.dart';

@riverpod
class NewNoteController extends _$NewNoteController {
  @override
  Future<NewNoteDTO?> build() async {
    return null;
  }

  Future<void> addNote(int bookId, NewNoteDTO note) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        await ref.read(bookNoteRepositoryProvider).addNote(bookId, note);
        return null;
      },
    );
  }

  Future<void> removeNote(BookNote note) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        await ref.read(bookNoteRepositoryProvider).removeNote(note);
        return const NewNoteDTO();
      },
    );
  }

  Future<void> updateNote(BookNote note, NewNoteDTO data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        await ref.read(bookNoteRepositoryProvider).updateNote(note, data);
        return data;
      },
    );
  }
}
