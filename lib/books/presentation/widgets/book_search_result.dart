import 'package:flutter/material.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/shared/presentation/widgets/book_cover.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class BookSearchResult extends StatelessWidget {
  const BookSearchResult({
    super.key,
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BookCover.raw(bytes: book.cover),
        Expanded(
          child: Column(
            children: [
              Text(
                book.title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorExtension?.gray[800],
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                book.author,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorExtension?.gray[400],
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
