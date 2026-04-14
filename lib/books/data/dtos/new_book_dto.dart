import 'dart:io';

import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/books/domain/value_objects/date.dart';
import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/books/domain/value_objects/title.dart';
import 'package:reading/profile/domain/value_objects/name.dart';

class NewBookDTO {
  const NewBookDTO({
    this.title = const Title(),
    this.author = const Name(),
    this.pages = const Pages(),
    this.cover,
    this.status,
    this.haveTheBook = 0,
    this.startedAt = const Date(),
    this.finishedAt = const Date(),
    this.actualPage = const Pages(),
  });

  final Title title;

  final Name author;

  final Pages pages;

  final File? cover;

  final BookStatus? status;

  final int haveTheBook;

  final Date startedAt;

  final Date finishedAt;

  final Pages actualPage;

  NewBookDTO copyWith({
    Title? title,
    Name? author,
    Pages? pages,
    File? cover,
    BookStatus? status,
    int? haveTheBook,
    Date? startedAt,
    Date? finishedAt,
    Pages? actualPage,
  }) =>
      NewBookDTO(
        title: title ?? this.title,
        author: author ?? this.author,
        pages: pages ?? this.pages,
        cover: cover ?? this.cover,
        status: status ?? this.status,
        haveTheBook: haveTheBook ?? this.haveTheBook,
        startedAt: startedAt ?? this.startedAt,
        finishedAt: finishedAt ?? this.finishedAt,
        actualPage: actualPage ?? this.actualPage,
      );
}
