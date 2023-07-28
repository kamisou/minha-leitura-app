import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/shared/infrastructure/datasources/connection_status.dart';
import 'package:reading/shared/infrastructure/datasources/database.dart';
import 'package:reading/shared/infrastructure/datasources/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_repository.g.dart';

@riverpod
BookRepository bookRepository(BookRepositoryRef ref) {
  return ref.watch(isConnectedProvider)
      ? OnlineBookRepository(ref)
      : OfflineBookRepository(ref);
}

@riverpod
Future<List<Book>> myBooks(MyBooksRef ref) {
  return ref.watch(bookRepositoryProvider).getMyBooks();
}

@riverpod
Future<BookDetails> book(BookRef ref, int bookId) {
  return ref.watch(bookRepositoryProvider).getBookDetails(bookId);
}

abstract class BookRepository {
  const BookRepository(this.ref);

  final Ref ref;

  Future<List<Book>> getMyBooks();
  Future<BookDetails> getBookDetails(int bookId);
}

class OnlineBookRepository extends BookRepository {
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

class OfflineBookRepository extends BookRepository {
  const OfflineBookRepository(super.ref);

  @override
  Future<BookDetails> getBookDetails(int bookId) {
    return ref.read(databaseProvider).getById(bookId);
  }

  @override
  Future<List<Book>> getMyBooks() {
    return ref.read(databaseProvider).getAll();
  }
}
