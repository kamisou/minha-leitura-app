import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/books/data/dtos/new_rating_dto.dart';
import 'package:reading/books/domain/models/book_rating.dart';
import 'package:reading/books/domain/value_objects/description.dart';
import 'package:reading/books/domain/value_objects/rating.dart';
import 'package:reading/profile/data/repositories/profile_repository.dart';
import 'package:reading/profile/domain/models/user.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
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

class OnlineBookRatingRepository extends BookRatingRepository
    with OfflineUpdatePusher {
  const OnlineBookRatingRepository(super.ref);

  @override
  Future<List<BookRating>> getRatings(int bookId) {
    return ref
        .read(restApiProvider)
        .get('books/$bookId/ratings')
        .then((response) => (response as List<Json>).map(BookRating.fromJson))
        .then((ratings) => ratings.toList());
  }

  @override
  Future<void> addRating(int bookId, NewRatingDTO data) async {
    final rating = await ref
        .read(restApiProvider)
        .post('books/$bookId/ratings', body: data.toJson())
        .then((response) => BookRating.fromJson(response as Json));

    await save(rating);

    return super.addRating(bookId, data);
  }

  @override
  Future<void> removeRating(int bookId, BookRating rating) async {
    await ref
        .read(restApiProvider)
        .delete('books/$bookId/ratings/${rating.id}');

    ref.read(databaseProvider).removeById<BookRating>(rating.id).ignore();

    return super.removeRating(bookId, rating);
  }

  @override
  Future<void> pushUpdates() async {
    final ratings = await ref
        .read(databaseProvider) //
        .getAll<OfflineBookRating>();

    for (final rating in ratings) {
      final data = NewRatingDTO(
        comment: Description(rating.comment),
        rating: Rating(rating.rating),
      );

      await addRating(rating.bookId, data);
    }
  }
}

class FakeBookRatingRepository extends BookRatingRepository {
  const FakeBookRatingRepository(super.ref);

  @override
  Future<List<BookRating>> getRatings(int bookId) async {
    return [
      BookRating(
        id: 1,
        rating: 4.2,
        comment: 'Lorem ipsum dolor sit amet, consectetur adipiscing',
        author: const User(id: 5, name: 'Guilherme'),
        createdAt: DateTime(2022, 09, 26),
        bookId: bookId,
      ),
      BookRating(
        id: 2,
        rating: 3,
        comment: 'Lorem ipsum dolor sit amet, consectetur adipiscing',
        author: const User(id: 6, name: 'Ciclano da Silva'),
        createdAt: DateTime(2022, 09, 10),
        bookId: bookId,
      ),
    ];
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

  @override
  Future<void> addRating(int bookId, NewRatingDTO data) async {
    final rating = OfflineBookRating(
      rating: data.rating.value!,
      comment: data.comment.value,
      author: ref.read(profileProvider).requireValue.toUser(),
      bookId: bookId,
    );

    await save(rating);

    return super.addRating(bookId, data);
  }

  @override
  Future<void> removeRating(int bookId, BookRating rating) {
    throw OnlineOnlyOperationException();
  }
}

abstract class BookRatingRepository extends Repository with OfflinePersister {
  const BookRatingRepository(super.ref);

  @mustBeOverridden
  @mustCallSuper
  Future<void> addRating(int bookId, NewRatingDTO data) async {
    ref.invalidate(bookRatingsProvider);
  }

  Future<List<BookRating>> getRatings(int bookId);

  @mustBeOverridden
  Future<void> removeRating(int bookId, BookRating rating) async {
    ref.invalidate(bookRatingsProvider);
  }
}
