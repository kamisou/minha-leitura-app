import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

class NewReadingDTO {
  const NewReadingDTO({
    this.pages = const Pages(),
    this.target = const Pages(),
  });

  final Pages pages;

  final Pages target;

  NewReadingDTO copyWith({
    Pages? pages,
    Pages? target,
  }) =>
      NewReadingDTO(
        pages: pages ?? this.pages,
        target: target ?? this.target,
      );

  Json toJson() => {
        'pages': pages.value,
        'target': target.value,
      };
}
