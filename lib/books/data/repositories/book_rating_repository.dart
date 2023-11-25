// ignore_for_file: avoid_dynamic_calls

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/books/data/cached/book_ratings.dart';
import 'package:reading/books/data/dtos/new_rating_dto.dart';
import 'package:reading/books/domain/models/book_rating.dart';
import 'package:reading/books/domain/value_objects/description.dart';
import 'package:reading/books/domain/value_objects/rating.dart';
import 'package:reading/profile/data/cached/profile.dart';
import 'package:reading/shared/data/cached/connection_status.dart';
import 'package:reading/shared/data/paginated_resource.dart';
import 'package:reading/shared/data/repository.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_rating_repository.g.dart';

@riverpod
BookRatingRepository bookRatingRepository(BookRatingRepositoryRef ref) {
  return ref.read(isConnectedProvider)
      ? OnlineBookRatingRepository(ref)
      : OfflineBookRatingRepository(ref);
}

class OnlineBookRatingRepository extends BookRatingRepository
    with OfflineUpdatePusher {
  OnlineBookRatingRepository(super.ref) {
    pushUpdates();
  }

  @override
  Future<PaginatedResource<BookRating>> getRatings(int page, int bookId) async {
    final ratings = await ref
        .read(restApiProvider) //
        .get('app/review/$bookId')
        .then(
          (response) => PaginatedResource.fromJson(
            response as Json,
            BookRating.fromJson,
          ),
        );

    saveAll<BookRating>(ratings.data, (rating) => rating.id).ignore();

    return ratings;
  }

  @override
  Future<void> addRating(int bookId, NewRatingDTO data) async {
    final body = {
      ...data.toJson(),
      'book_id': bookId,
    };

    final rating = await ref
        .read(restApiProvider)
        .post('app/review', body: body)
        .then((response) {
      response['user'] = {
        'id': response['user_id'],
        'name': ref.read(profileProvider).requireValue!.name,
      };

      return BookRating.fromJson(response as Json);
    });

    await save<BookRating>(rating, rating.id);

    return super.addRating(bookId, data);
  }

  @override
  Future<void> removeRating(int bookId, BookRating rating) async {
    await ref.read(restApiProvider).delete('app/review/${rating.id}');

    ref.read(databaseProvider).removeById<BookRating>(rating.id).ignore();

    return super.removeRating(bookId, rating);
  }

  @override
  Future<void> pushUpdates() async {
    final ratings = await ref.read(databaseProvider).getAll<BookRating>();

    for (final rating in ratings) {
      if (rating.id != null && !rating.markedForDeletion) {
        continue;
      }

      final data = NewRatingDTO(
        comment: Description(rating.comment),
        rating: Rating(rating.rating),
      );

      if (rating.id == null) {
        await addRating(rating.bookId, data);
      } else {
        if (rating.markedForDeletion) {
          await removeRating(rating.bookId, rating);
        }
      }
    }
  }
}

class OfflineBookRatingRepository extends BookRatingRepository {
  const OfflineBookRatingRepository(super.ref);

  static const pageSize = 20;

  @override
  Future<PaginatedResource<BookRating>> getRatings(int page, int bookId) async {
    final ratings = await ref
        .read(databaseProvider) //
        .getWhere<BookRating>(
          (rating) => rating.bookId == bookId && !rating.markedForDeletion,
          limit: pageSize,
          offset: (page - 1) * pageSize,
        );

    return PaginatedResource(
      currentPage: page,
      data: ratings..sort(),
      perPage: pageSize,
    );
  }

  @override
  Future<void> addRating(int bookId, NewRatingDTO data) async {
    final rating = BookRating(
      rating: data.rating.value!,
      comment: data.comment.value,
      author: ref.read(profileProvider).requireValue!.toUser(),
      bookId: bookId,
    );

    await save<BookRating>(rating);

    return super.addRating(bookId, data);
  }

  @override
  Future<void> removeRating(int bookId, BookRating rating) async {
    if (rating.id == null) {
      await ref.read(databaseProvider).removeById<BookRating>(rating.key);
    } else {
      final marked = rating.copyWith(markedForDeletion: true);
      await save<BookRating>(marked, rating.key);
    }

    return super.removeRating(bookId, rating);
  }
}

abstract class BookRatingRepository extends Repository with OfflinePersister {
  const BookRatingRepository(super.ref);

  @mustBeOverridden
  @mustCallSuper
  Future<void> addRating(int bookId, NewRatingDTO data) {
    return ref.read(bookRatingsProvider(bookId).notifier).refresh();
  }

  Future<PaginatedResource<BookRating>> getRatings(int page, int bookId);

  @mustCallSuper
  @mustBeOverridden
  Future<void> removeRating(int bookId, BookRating rating) {
    return ref.read(bookRatingsProvider(bookId).notifier).refresh();
  }
}
