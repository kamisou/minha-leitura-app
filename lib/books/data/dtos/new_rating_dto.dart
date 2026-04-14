import 'package:reading/books/domain/value_objects/description.dart';
import 'package:reading/books/domain/value_objects/rating.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

class NewRatingDTO {
  const NewRatingDTO({
    this.rating = const Rating(),
    this.comment = const Description(),
  });

  final Rating rating;

  final Description comment;

  NewRatingDTO copyWith({
    Rating? rating,
    Description? comment,
  }) =>
      NewRatingDTO(
        rating: rating ?? this.rating,
        comment: comment ?? this.comment,
      );

  Json toJson() => {
        'rating': rating.value,
        'comment': comment.value,
      };
}
