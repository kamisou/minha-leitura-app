import 'package:reading/books/data/dtos/new_book_dto.dart';
import 'package:reading/books/data/repositories/book_repository.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_book_controller.g.dart';

@riverpod
class NewBookController extends _$NewBookController {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addBook(NewBookDTO data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => data.status == BookStatus.pending
          ? ref.read(bookRepositoryProvider).addBook(data)
          : ref.read(bookRepositoryProvider).addBookAndReading(data),
    );
  }
}
