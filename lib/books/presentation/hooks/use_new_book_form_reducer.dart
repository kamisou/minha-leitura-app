import 'dart:io';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/data/dtos/new_book_dto.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/books/domain/value_objects/date.dart';
import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/books/domain/value_objects/title.dart';
import 'package:reading/profile/domain/value_objects/name.dart';

Store<NewBookDTO, dynamic> useNewBookFormReducer() {
  return useReducer(
    (state, action) => switch (action) {
      Title() => state.copyWith(title: action),
      Name() => state.copyWith(author: action),
      File() => state.copyWith(cover: action),
      BookStatus() => state.copyWith(status: action),
      int() => state.copyWith(haveTheBook: action),
      <String, Date>{'started_at': Date()} =>
        state.copyWith(startedAt: action['started_at']),
      <String, Date>{'finished_at': Date()} =>
        state.copyWith(finishedAt: action['finished_at']),
      <String, Pages>{'actual_page': Pages()} =>
        state.copyWith(actualPage: action['actual_page']),
      <String, Pages>{'pages': Pages()} =>
        state.copyWith(pages: action['pages']),
      _ => state,
    },
    initialState: const NewBookDTO(),
    initialAction: null,
  );
}
