import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/domain/models/book_rating.dart';

double useRatingAverage(List<BookRating> ratings) {
  return useMemoized(
    () {
      var total = 0.0;

      for (final rating in ratings) {
        total += rating.rating;
      }

      return total / ratings.length;
    },
    [...ratings],
  );
}
