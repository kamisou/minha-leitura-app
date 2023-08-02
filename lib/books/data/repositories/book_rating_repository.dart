import 'package:reading/books/domain/models/book_rating.dart';
import 'package:reading/profile/domain/models/user.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_rating_repository.g.dart';

@riverpod
BookRatingRepository bookRatingRepository(BookRatingRepositoryRef ref) {
  return FakeBookRatingRepository(ref);

  return ref.read(isConnectedProvider)
      ? OnlineBookRatingRepository(ref)
      : OfflineBookRatingRepository(ref);
}

@riverpod
Future<List<BookRating>> bookRatings(BookRatingsRef ref, int bookId) {
  return ref.read(bookRatingRepositoryProvider).getRatings(bookId);
}

class OnlineBookRatingRepository extends BookRatingRepository {
  const OnlineBookRatingRepository(super.ref);

  @override
  Future<List<BookRating>> getRatings(int bookId) {
    return ref
        .read(restApiProvider)
        .get('books/$bookId/ratings')
        .then((response) => (response as List<Json>).map(BookRating.fromJson))
        .then((ratings) => ratings.toList());
  }
}

class FakeBookRatingRepository extends BookRatingRepository
    with OfflineUpdatePusher {
  const FakeBookRatingRepository(super.ref);

  @override
  Future<List<BookRating>> getRatings(int bookId) async {
    return [
      BookRating(
        id: 1,
        rating: 4.2,
        comment: 'Lorem ipsum dolor sit amet, consectetur adipiscing',
        author: const User(id: 1, name: 'Guilherme'),
        createdAt: DateTime(2022, 09, 26),
        bookId: bookId,
      ),
      BookRating(
        id: 2,
        rating: 3,
        comment: 'Lorem ipsum dolor sit amet, consectetur adipiscing',
        author: const User(id: 1, name: 'Ciclano da Silva'),
        createdAt: DateTime(2022, 09, 10),
        bookId: bookId,
      ),
    ];
  }

  @override
  Future<void> pushUpdates() {
    // TODO: implement pushUpdates
    throw UnimplementedError();
  }
}

class OfflineBookRatingRepository extends BookRatingRepository {
  const OfflineBookRatingRepository(super.ref);

  @override
  Future<List<BookRating>> getRatings(int bookId) {
    final db = ref.read(databaseProvider);

    return Future.wait([
      db.getWhere<BookRating>((rating) => rating.bookId == bookId),
      db.getWhere<OfflineBookRating>((rating) => rating.bookId == bookId),
    ]) //
        .then((ratings) => [...ratings.first, ...ratings.last]);
  }
}

abstract class BookRatingRepository extends Repository {
  const BookRatingRepository(super.ref);

  Future<List<BookRating>> getRatings(int bookId);
}
