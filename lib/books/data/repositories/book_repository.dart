import 'package:reading/books/domain/models/book.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/shared/data/repository.dart';
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
Future<List<Book>> myBooks(MyBooksRef ref) {
  return ref.read(bookRepositoryProvider).getMyBooks();
}

@riverpod
Future<BookDetails> book(BookRef ref, int bookId) {
  return ref.read(bookRepositoryProvider).getBookDetails(bookId);
}

class OnlineBookRepository extends BookRepository {
  const OnlineBookRepository(super.ref);

  @override
  Future<List<Book>> getMyBooks() {
    return ref
        .read(restApiProvider)
        .get('books/my')
        .then((response) => (response as List<Json>).map(Book.fromJson))
        .then((books) => books.toList());
  }

  @override
  Future<BookDetails> getBookDetails(int bookId) {
    return ref
        .read(restApiProvider)
        .get('books/$bookId')
        .then((response) => BookDetails.fromJson(response as Json));
  }
}

class OfflineBookRepository extends BookRepository {
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

abstract class BookRepository extends Repository {
  const BookRepository(super.ref);

  Future<List<Book>> getMyBooks();
  Future<BookDetails> getBookDetails(int bookId);
}
