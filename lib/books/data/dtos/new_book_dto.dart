import 'dart:io';

import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/books/domain/value_objects/title.dart';
import 'package:reading/profile/domain/value_objects/name.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

class NewBookDTO {
  const NewBookDTO({
    this.title = const Title(),
    this.author = const Name(),
    this.pages = const Pages(),
    this.file,
  });

  final Title title;

  final Name author;

  final Pages pages;

  final File? file;

  NewBookDTO copyWith({
    Title? title,
    Name? author,
    Pages? pages,
    File? file,
  }) =>
      NewBookDTO(
        title: title ?? this.title,
        author: author ?? this.author,
        pages: pages ?? this.pages,
        file: file ?? this.file,
      );

  Json toJson() => {
        'title': title.value,
        'author': author.value,
        'pages': pages.value,
      };
}
