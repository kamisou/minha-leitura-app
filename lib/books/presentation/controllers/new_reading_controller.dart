import 'package:reading/books/data/dtos/new_reading_dto.dart';
import 'package:reading/books/data/repositories/book_reading_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_reading_controller.g.dart';

@riverpod
class NewReadingController extends _$NewReadingController {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updateReading(int bookId, NewReadingDTO data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(bookReadingRepositoryProvider).updateReading(bookId, data),
    );
  }
}
