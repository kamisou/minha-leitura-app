import 'package:reading/books/data/repositories/book_rating_repository.dart';
import 'package:reading/books/domain/models/book_rating.dart';
import 'package:reading/shared/data/paginated_resource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_ratings.g.dart';

@riverpod
class BookRatings extends _$BookRatings {
  int? _bookId;

  @override
  Future<PaginatedResource<BookRating>> build(int bookId) async {
    _bookId = bookId;
    return _getRatings();
  }

  Future<PaginatedResource<BookRating>> _getRatings() async {
    final ratings = await ref
        .read(bookRatingRepositoryProvider)
        .getRatings((state.valueOrNull?.currentPage ?? 0) + 1, _bookId!);

    return ratings.copyWith(
      data: [...state.valueOrNull?.data ?? [], ...ratings.data],
      finished: ratings.data.length < ratings.perPage,
      loading: false,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(
      await ref.read(bookRatingRepositoryProvider).getRatings(1, _bookId!),
    );
  }

  Future<void> next() async {
    if (state.requireValue.finished) return;

    state = AsyncData(
      state.requireValue.copyWith(loading: true),
    );

    state = AsyncData(
      await _getRatings(),
    );
  }
}
