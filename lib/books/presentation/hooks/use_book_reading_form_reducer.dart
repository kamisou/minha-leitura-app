import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/data/dtos/new_reading_dto.dart';
import 'package:reading/books/domain/value_objects/pages.dart';

Store<NewReadingDTO, dynamic> useBookReadingFormReducer() {
  return useReducer(
    (state, action) => switch (action) {
      Pages() => state.copyWith(page: action),
      _ => state,
    },
    initialState: const NewReadingDTO(),
    initialAction: null,
  );
}
