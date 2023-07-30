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

    ref.read(databaseProvider).update(details, details.id).ignore();

    return details;
  }

  @override
  Future<List<Book>> getMyBooks() async {
    final books = await ref
        .read(restApiProvider)
        .get('books/my')
        .then((response) => (response as List<Json>).map(Book.fromJson))
        .then((books) => books.toList());

    ref.read(databaseProvider).updateAll(books, (book) => book.id).ignore();

    return books;
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
            'https://s3-alpha-sig.figma.com/img/fc51/9370/48b40648284f72d5ba23eb7f53b20da8?Expires=1691366400&Signature=njikvp9J48lDWb047c2gun3VPYwmjh5qTKTg2UeZCSHc0wIf95pEsAZeNevlMC6sUpwj1FVTCLJZZ5tUHV--q5MBCbVeZiOcnGwzWQJ5TT4lJG17ZkQcFnWiRlGFbzGz4xnyQw7TwNp32f-lAb57ok4brWPGNymy5hUKIxoCU7-S2wtPaEhnJPYmMqgR-F8KUz4MIXuGkrm19XedYVKNFCREBQCP-m0HaZ0k1yGlD7gMVgeq-0keTv-Em9p6jOHsfF0~tPa129jNkR7SUl3FO3hg2H-vPPjDmQYkDQPSnZ8rFy-M268eez4iA9HxxStJ7yUgJW2W~GNYXxb9VbodXQ__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4',
        title: 'Alice no País das Maravilhas',
        author: 'Lewis Carroll',
        pageCount: 248,
        pagesRead: 72,
      ),
    ];
  }
}

abstract class BookRepository extends Repository {
  const BookRepository(super.ref);

  Future<BookDetails> getBookDetails(int bookId);
  Future<List<Book>> getMyBooks();
}
