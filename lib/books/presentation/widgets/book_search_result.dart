import 'package:flutter/material.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/shared/presentation/widgets/book_cover.dart';
import 'package:reading/shared/util/bytes_extension.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
          child: BookCover(image: book.cover?.toImage()),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
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
