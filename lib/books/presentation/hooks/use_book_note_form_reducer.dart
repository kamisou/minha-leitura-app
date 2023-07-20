import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/data/dtos/note_dto.dart';
import 'package:reading/books/domain/value_objects/description.dart';
import 'package:reading/books/domain/value_objects/title.dart';

Store<NoteDTO, dynamic> useBookNoteFormReducer() {
  return useReducer(
    (state, action) => switch (action) {
      Title() => state.copyWith(title: action),
      Description() => state.copyWith(description: action),
      _ => state,
    },
    initialState: const NoteDTO(),
    initialAction: null,
  );
}
