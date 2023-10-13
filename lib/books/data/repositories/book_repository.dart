import 'package:reading/books/data/dtos/new_book_dto.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/shared/data/paginated_resource.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:reading/shared/util/file_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_repository.g.dart';

@riverpod
BookRepository bookRepository(BookRepositoryRef ref) {
  return ref.read(isConnectedProvider)
      ? OnlineBookRepository(ref)
      : OfflineBookRepository(ref);
}

@riverpod
class MyBooks extends _$MyBooks {
  @override
  Future<PaginatedResource<BookDetails>> build() async {
    return _getMyBooks();
  }

  Future<PaginatedResource<BookDetails>> _getMyBooks() {
    return ref
        .read(bookRepositoryProvider)
        .getMyBooks((state.valueOrNull?.currentPage ?? 0) + 1);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await ref.read(bookRepositoryProvider).getMyBooks(1));
  }

  Future<void> next() async {
    state = AsyncData(
      state.requireValue.copyWith(loading: true),
    );

    final books = await _getMyBooks();

    state = AsyncData(
      books.copyWith(
        data: [...state.requireValue.data, ...books.data],
        finished: books.data.length < books.perPage,
        loading: false,
      ),
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

  Future<PaginatedResource<Book>> _getBooks({String? searchTerm}) {
    return ref.read(bookRepositoryProvider).getBooks(
          (state.valueOrNull?.currentPage ?? 0) + 1,
          searchTerm: searchTerm,
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
    state = AsyncData(
      state.requireValue.copyWith(loading: true),
    );

    final books = await _getBooks(searchTerm: _searchTerm);

    state = AsyncData(
      books.copyWith(
        data: [...state.requireValue.data, ...books.data],
        finished: books.data.length < books.perPage,
        loading: false,
      ),
    );
  }
}

class OnlineBookRepository extends BookRepository {
  const OnlineBookRepository(super.ref);

  @override
  Future<PaginatedResource<Book>> getBooks(
    int page, {
    String? searchTerm,
  }) {
    return ref
        .read(restApiProvider) //
        .get('app/reading?page=$page')
        .then(
          (response) => PaginatedResource.fromJson(
            response as Json,
            Book.fromJson,
          ),
        );
  }

  @override
  Future<Book> addBook(NewBookDTO data) async {
    final book = await ref
        .read(restApiProvider) //
        .post(
      'app/book',
      body: {
        'author': data.author.value,
        'cover': data.cover?.readAsBase64(),
        'pages': data.pages.value,
        'title': data.title.value,
      },
    ).then((response) => Book.fromJson(response as Json));

    ref.read(myBooksProvider.notifier).refresh().ignore();

    return book;
  }

  @override
  Future<void> addReading(Book book, NewBookDTO data) async {
    final reading = await ref
        .read(restApiProvider)
        .post(
          'app/reading',
          body: {
            'book_id': book.id,
            'status': data.status!.name,
            'started_at': data.startedAt.value,
            'finished_at': data.finishedAt.value,
            'actual_page': data.actualPage.value,
            'have_the_book': data.haveTheBook,
          },
        ) //
        .then((response) => {...response as Json, 'book': book.toJson()})
        .then(BookDetails.fromJson);

    await save<BookDetails>(reading, reading.id);

    ref.read(myBooksProvider.notifier).refresh().ignore();
  }

  @override
  Future<void> addBookAndReading(NewBookDTO data) async {
    final book = await addBook(data);
    return addReading(book, data);
  }

  @override
  Future<PaginatedResource<BookDetails>> getMyBooks(int page) async {
    final books = await ref
        .read(restApiProvider) //
        .get('app/reading?page=$page')
        .then(
          (response) => PaginatedResource.fromJson(
            response as Json,
            BookDetails.fromJson,
          ),
        );

    saveAll<BookDetails>(books.data, (book) => book.id).ignore();

    return books;
  }
}

class OfflineBookRepository extends BookRepository {
  const OfflineBookRepository(super.db);

  static const pageSize = 20;

  @override
  Future<PaginatedResource<Book>> getBooks(int page, {String? searchTerm}) {
    throw OnlineOnlyOperationException();
  }

  @override
  Future<Book> addBook(NewBookDTO data) {
    throw OnlineOnlyOperationException();
  }

  @override
  Future<void> addReading(Book book, NewBookDTO data) {
    throw OnlineOnlyOperationException();
  }

  @override
  Future<void> addBookAndReading(NewBookDTO data) {
    throw OnlineOnlyOperationException();
  }

  @override
  Future<PaginatedResource<BookDetails>> getMyBooks(int page) async {
    final books = await ref.read(databaseProvider).getAll<BookDetails>(
          limit: pageSize,
          offset: (page - 1) * pageSize,
        );

    return PaginatedResource(
      currentPage: page,
      data: books,
      perPage: pageSize,
    );
  }
}

abstract class BookRepository extends Repository with OfflinePersister {
  const BookRepository(super.ref);

  Future<PaginatedResource<Book>> getBooks(int page, {String? searchTerm});
  Future<Book> addBook(NewBookDTO data);
  Future<void> addReading(Book book, NewBookDTO data);
  Future<void> addBookAndReading(NewBookDTO data);
  Future<PaginatedResource<BookDetails>> getMyBooks(int page);
}
