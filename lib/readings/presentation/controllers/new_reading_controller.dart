import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/readings/data/repositories/reading_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_reading_controller.g.dart';

@riverpod
class NewReadingController extends _$NewReadingController {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addReading(int bookId, Pages pages) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(readingRepositoryProvider).addReading(bookId, pages),
    );
  }
}
