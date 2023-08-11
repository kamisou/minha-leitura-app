import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/data/dtos/new_rating_dto.dart';
import 'package:reading/books/domain/value_objects/description.dart';
import 'package:reading/books/domain/value_objects/rating.dart';

Store<NewRatingDTO, dynamic> useBookRatingFormReducer() {
  return useReducer(
    (state, action) => switch (action) {
      Rating() => state.copyWith(rating: action),
      Description() => state.copyWith(comment: action),
      _ => state,
    },
    initialState: const NewRatingDTO(),
    initialAction: null,
  );
}
