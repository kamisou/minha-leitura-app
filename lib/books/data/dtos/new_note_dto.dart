import 'package:reading/books/domain/value_objects/description.dart';
import 'package:reading/books/domain/value_objects/title.dart';
import 'package:reading/shared/infrastructure/datasources/rest_api.dart';

class NewNoteDTO {
  const NewNoteDTO({
    this.title = const Title(),
    this.description = const Description(),
  });

  final Title title;

  final Description description;

  NewNoteDTO copyWith({
    Title? title,
    Description? description,
  }) =>
      NewNoteDTO(
        title: title ?? this.title,
        description: description ?? this.description,
      );

  Json toJson() => {
        'title': title.value,
        'description': description.value,
      };
}
