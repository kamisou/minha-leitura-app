import 'package:reading/books/data/cached/books.dart';
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

class OnlineBookRepository extends BookRepository {
  const OnlineBookRepository(super.ref);

  @override
  Future<PaginatedResource<Book>> getBooks(
    int page, {
    String? searchTerm,
  }) {
    final query = {
      'page': page,
      if (searchTerm != null) //
        'q': searchTerm,
    };

    return ref
        .read(restApiProvider) //
        .get('app/book', query: query)
        .then(
          (response) => PaginatedResource.fromJson(
            response as Json,
            Book.fromJson,
          ),
        );
  }

  @override
  Future<Book> addBook(NewBookDTO data) async {
    final body = {
      'author': data.author.value,
      'cover': data.cover?.readAsBase64(),
      'pages': data.pages.value,
      'title': data.title.value,
    };

    final book = await ref
        .read(restApiProvider) //
        .post('app/book', body: body)
        .then((response) => Book.fromJson(response as Json));

    ref.read(myBooksProvider.notifier).refresh().ignore();

    return book;
  }

  @override
  Future<void> addReading(Book book, NewBookDTO data) async {
    final body = {
      'book_id': book.id,
      'status': data.status!.name,
      'started_at': data.startedAt.value?.toIso8601String(),
      'finished_at': data.finishedAt.value?.toIso8601String(),
      'actual_page': data.actualPage.value,
      'have_the_book': data.haveTheBook,
    };

    final reading = await ref
        .read(restApiProvider)
        .post('app/reading', body: body) //
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
    final books = await ref
        .read(databaseProvider) //
        .getAll<BookDetails>(
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
