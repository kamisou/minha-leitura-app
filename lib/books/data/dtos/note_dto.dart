import 'package:reading/books/domain/value_objects/description.dart';
import 'package:reading/books/domain/value_objects/title.dart';
import 'package:reading/common/infrastructure/rest_api.dart';

class NoteDTO {
  const NoteDTO({
    this.title = const Title(),
    this.description = const Description(),
  });

  final Title title;

  final Description description;

  NoteDTO copyWith({
    Title? title,
    Description? description,
  }) =>
      NoteDTO(
        title: title ?? this.title,
        description: description ?? this.description,
      );

  Json toJson() => {
        'title': title.value,
        'description': description.value,
      };
}
