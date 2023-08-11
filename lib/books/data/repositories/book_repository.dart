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
  return FakeBookRepository(ref);

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
  Future<BookDetails> getBookDetails(int bookId) async {
    final details = await ref
        .read(restApiProvider)
        .get('books/$bookId')
        .then((response) => BookDetails.fromJson(response as Json));

    save<BookDetails>(details, details.id).ignore();

    return details;
  }

  @override
  Future<List<Book>> getMyBooks() async {
    final books = await ref
        .read(restApiProvider)
        .get('books/my')
        .then((response) => (response as List<Json>).map(Book.fromJson))
        .then((books) => books.toList());

    saveAll<Book>(books, (book) => book.id).ignore();

    return books;
  }
}

class OfflineBookRepository extends BookRepository {
  const OfflineBookRepository(super.db);

  @override
  Future<BookDetails> getBookDetails(int bookId) {
    return ref.read(databaseProvider).getById<BookDetails>(bookId);
  }

  @override
  Future<List<Book>> getMyBooks() {
    return ref.read(databaseProvider).getAll<Book>();
  }
}

class FakeBookRepository extends BookRepository {
  const FakeBookRepository(super.ref);

  @override
  Future<BookDetails> getBookDetails(int bookId) async {
    return BookDetails(
      id: 1,
      pageCount: 248,
      pagesRead: 72,
      currentPage: 36,
      dailyPageGoal: 10,
      started: DateTime(2021, 02, 10),
    );
  }

  @override
  Future<List<Book>> getMyBooks() async {
    return [
      const Book(
        id: 1,
        coverArt:
            'https://s3-alpha-sig.figma.com/img/fc51/9370/48b40648284f72d5ba23eb7f53b20da8?Expires=1692576000&Signature=aKraWa~X7NBXf5ye~xvnYDGbFXRPNM2efo-g9vBkG~U3L3EMNwfY6enOO-8qCDQusmLXZ72tXiBCnLWmQo20l7ZlNx96XW~F0RhFzrJrbEEMD9vaCxr-peXytt2PuvsCLA959-sWGzTWsYZDDjozwfHLGtZTe4vGplYyfer7NBPqhQ~PPhWYBORQEDsrnmhpSYuVeWAxmj~zLSrUj2y3Ri6xScZHscDYqoBLiA6paR5AbHcoTlbmtY7AOIGK4rN~wLqJarBhuBMG3n5Zx6TM9BOIB4wpo2H~CjDq4eqmyPQWYrYTjdOf1zL3AEsYB1xJ9VRGYo5cdPc5XMpDvxVbLg__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4',
        title: 'Alice no País das Maravilhas',
        author: 'Lewis Carroll',
        pageCount: 248,
        pagesRead: 72,
      ),
    ];
  }
}

abstract class BookRepository extends Repository with OfflinePersister {
  const BookRepository(super.ref);

  Future<BookDetails> getBookDetails(int bookId);
  Future<List<Book>> getMyBooks();
}
