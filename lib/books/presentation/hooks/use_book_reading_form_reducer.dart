import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/data/dtos/new_reading_dto.dart';
import 'package:reading/books/domain/value_objects/pages.dart';

Store<NewReadingDTO, dynamic> useBookReadingFormReducer(int target) {
  return useReducer(
    (state, action) => switch (action) {
      Pages() => state.copyWith(pages: action),
      _ => state,
    },
    initialState: NewReadingDTO(pages: Pages(target)),
    initialAction: null,
  );
}
