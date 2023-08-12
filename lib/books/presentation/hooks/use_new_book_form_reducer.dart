import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/data/dtos/new_book_dto.dart';
import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/books/domain/value_objects/title.dart';
import 'package:reading/profile/domain/value_objects/name.dart';

Store<NewBookDTO, dynamic> useNewBookFormReducer() {
  return useReducer(
    (state, action) => switch (action) {
      Title() => state.copyWith(title: action),
      Name() => state.copyWith(author: action),
      Pages() => state.copyWith(pages: action),
      _ => state,
    },
    initialState: const NewBookDTO(),
    initialAction: null,
  );
}
