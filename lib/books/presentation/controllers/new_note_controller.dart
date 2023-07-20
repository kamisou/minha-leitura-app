import 'package:reading/books/data/dtos/note_dto.dart';
import 'package:reading/books/data/repositories/book_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_note_controller.g.dart';

@riverpod
class NewNoteController extends _$NewNoteController {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addNote(int bookId, NoteDTO note) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(bookRepositoryProvider).addNote(bookId, note),
    );
  }
}
