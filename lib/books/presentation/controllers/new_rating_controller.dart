import 'package:reading/books/data/dtos/new_rating_dto.dart';
import 'package:reading/books/data/repositories/book_rating_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_rating_controller.g.dart';

@riverpod
class NewRatingController extends _$NewRatingController {
  @override
  Future<NewRatingDTO?> build() async {
    return null;
  }

  Future<void> addRating(int bookId, NewRatingDTO data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        await ref.read(bookRatingRepositoryProvider).addRating(bookId, data);
        return data;
      },
    );
  }
}
