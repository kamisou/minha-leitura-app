import 'package:reading/books/data/dtos/new_note_dto.dart';
import 'package:reading/books/data/repositories/book_note_repository.dart';
import 'package:reading/shared/application/repository_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_note_controller.g.dart';

@riverpod
class NewNoteController extends _$NewNoteController {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addNote(int bookId, NewNoteDTO note) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(repositoryServiceProvider)<BookNoteRepository>()
          .addNote(bookId, note),
    );
  }
}
