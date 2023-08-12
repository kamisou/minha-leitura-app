import 'package:reading/books/data/dtos/new_book_dto.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_repository.g.dart';

@riverpod
BookRepository bookRepository(BookRepositoryRef ref) {
  return ref.read(isConnectedProvider)
      ? OnlineBookRepository(ref)
      : OfflineBookRepository(ref);
}

@riverpod
Future<List<BookDetails>> myBooks(MyBooksRef ref) {
  return ref.read(bookRepositoryProvider).getMyBooks();
}

class OnlineBookRepository extends BookRepository {
  const OnlineBookRepository(super.ref);

  @override
  Future<Book> addBook(NewBookDTO data) async {
    final book = await ref
        .read(restApiProvider) //
        .post(
      'app/book',
      body: {
        'author': data.author.value,
        // TODO: capa
        'cover': null,
        'pages': data.pages.value,
        'title': data.title.value,
      },
    ).then((response) => Book.fromJson(response as Json));

    await save<Book>(book, book.id);

    ref.invalidate(myBooksProvider);

    return book;
  }

  @override
  Future<void> addBookAndReading(NewBookDTO data) async {
    final book = await addBook(data);

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

    ref.invalidate(myBooksProvider);
  }

  @override
  Future<List<BookDetails>> getMyBooks() async {
    final books = await ref
        .read(restApiProvider)
        .get('app/reading')
        .then((response) => (response as Json)['data'] as List)
        .then((list) => list.cast<Json>().map(BookDetails.fromJson))
        .then((books) => books.toList());

    saveAll<BookDetails>(books, (book) => book.id).ignore();

    return books;
  }
}

class OfflineBookRepository extends BookRepository {
  const OfflineBookRepository(super.db);

  @override
  Future<Book> addBook(NewBookDTO data) {
    throw OnlineOnlyOperationException();
  }

  @override
  Future<void> addBookAndReading(NewBookDTO data) {
    throw OnlineOnlyOperationException();
  }

  @override
  Future<List<BookDetails>> getMyBooks() {
    return ref.read(databaseProvider).getAll<BookDetails>();
  }
}

abstract class BookRepository extends Repository with OfflinePersister {
  const BookRepository(super.ref);

  Future<Book> addBook(NewBookDTO data);
  Future<void> addBookAndReading(NewBookDTO data);
  Future<List<BookDetails>> getMyBooks();
}
