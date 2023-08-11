import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

class NewReadingDTO {
  const NewReadingDTO({
    this.page = const Pages(),
  });

  final Pages page;

  NewReadingDTO copyWith({
    Pages? page,
  }) =>
      NewReadingDTO(
        page: page ?? this.page,
      );

  Json toJson() => {'page': page.value};
}
