import 'package:reading/books/domain/models/book.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/shared/application/repository_service.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_repository.g.dart';

@riverpod
Future<List<Book>> myBooks(MyBooksRef ref) {
  return ref
      .read(repositoryServiceProvider)<BookRepository>() //
      .getMyBooks();
}

@riverpod
Future<BookDetails> book(BookRef ref, int bookId) {
  return ref
      .read(repositoryServiceProvider)<BookRepository>()
      .getBookDetails(bookId);
}

class OnlineBookRepository extends OnlineRepository implements BookRepository {
  const OnlineBookRepository(super.ref);

  @override
  Future<BookDetails> getBookDetails(int bookId) {
    return ref
        .read(restApiProvider)
        .get('books/$bookId')
        .then((response) => BookDetails.fromJson(response as Json));
  }

  @override
  Future<List<Book>> getMyBooks() {
    return ref
        .read(restApiProvider)
        .get('books/my')
        .then((response) => (response as List<Json>).map(Book.fromJson))
        .then((books) => books.toList());
  }
}

class OfflineBookRepository extends OfflineRepository
    implements BookRepository {
  const OfflineBookRepository(super.db);

  @override
  Future<BookDetails> getBookDetails(int bookId) {
    return ref.read(databaseProvider).getById(bookId);
  }

  @override
  Future<List<Book>> getMyBooks() {
    return ref.read(databaseProvider).getAll();
  }
}

abstract class BookRepository {
  Future<List<Book>> getMyBooks();
  Future<BookDetails> getBookDetails(int bookId);
}
