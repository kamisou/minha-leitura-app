import 'package:reading/books/data/repositories/book_repository.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/shared/data/paginated_resource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'books.g.dart';

@riverpod
class MyBooks extends _$MyBooks {
  @override
  Future<PaginatedResource<BookDetails>> build() async {
    return _getMyBooks();
  }

  Future<PaginatedResource<BookDetails>> _getMyBooks() async {
    final books = await ref
        .read(bookRepositoryProvider) //
        .getMyBooks((state.valueOrNull?.currentPage ?? 0) + 1);

    return books.copyWith(
      data: [...state.valueOrNull?.data ?? [], ...books.data],
      finished: books.data.length < books.perPage,
      loading: false,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await ref.read(bookRepositoryProvider).getMyBooks(1));
  }

  Future<void> next() async {
    if (state.requireValue.finished) return;

    state = AsyncData(
      state.requireValue.copyWith(loading: true),
    );

    state = AsyncData(
      await _getMyBooks(),
    );
  }
}

@riverpod
class Books extends _$Books {
  String? _searchTerm;

  @override
  Future<PaginatedResource<Book>> build({String? searchTerm}) async {
    _searchTerm = searchTerm;
    return _getBooks(searchTerm: searchTerm);
  }

  Future<PaginatedResource<Book>> _getBooks({String? searchTerm}) async {
    final books = await ref
        .read(bookRepositoryProvider) //
        .getBooks(
          (state.valueOrNull?.currentPage ?? 0) + 1,
          searchTerm: searchTerm,
        );

    return books.copyWith(
      data: [...state.valueOrNull?.data ?? [], ...books.data],
      finished: books.data.length < books.perPage,
      loading: false,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(
      await ref
          .read(bookRepositoryProvider)
          .getBooks(1, searchTerm: _searchTerm),
    );
  }

  Future<void> next() async {
    if (state.requireValue.finished) return;

    state = AsyncData(
      state.requireValue.copyWith(loading: true),
    );

    state = AsyncData(
      await _getBooks(searchTerm: _searchTerm),
    );
  }
}
