import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/shared/infrastructure/database.dart';
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
  Future<List<BookDetails>> getMyBooks() async {
    // final books = await ref
    //     .read(restApiProvider)
    //     .get('app/reading')
    //     .then((response) => (response as Json)['data'] as List)
    //     .then((list) => list.cast<Json>().map(BookDetails.fromJson))
    //     .then((books) => books.toList());

    // saveAll<BookDetails>(books, (book) => book.id).ignore();

    return [];
  }
}

class OfflineBookRepository extends BookRepository {
  const OfflineBookRepository(super.db);

  @override
  Future<List<BookDetails>> getMyBooks() {
    return ref.read(databaseProvider).getAll<BookDetails>();
  }
}

abstract class BookRepository extends Repository with OfflinePersister {
  const BookRepository(super.ref);

  Future<List<BookDetails>> getMyBooks();
}
