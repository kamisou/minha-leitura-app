import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/books/data/repositories/book_rating_repository.dart';
import 'package:reading/books/domain/models/book_rating.dart';
import 'package:reading/books/presentation/widgets/author_timestamp.dart';
import 'package:reading/books/presentation/widgets/star_rating_widget.dart';
import 'package:reading/profile/data/repositories/profile_repository.dart';
import 'package:reading/shared/util/theme_data_extension.dart';
import 'package:unicons/unicons.dart';

class BookRatingTile extends ConsumerWidget {
  const BookRatingTile({
    super.key,
    required this.rating,
  });

  final BookRating rating;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StarRatingWidget(value: rating.rating),
            if (rating.author.id == ref.read(profileProvider).requireValue!.id)
              GestureDetector(
                onTap: () => ref
                    .read(bookRatingRepositoryProvider)
                    .removeRating(rating.bookId, rating),
                child: Icon(
                  UniconsLine.trash_alt,
                  color: Theme.of(context).colorExtension?.gray[800],
                ),
              ),
          ],
        ),
        Text(
          rating.comment,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorExtension?.gray[600],
              ),
        ),
        AuthorTimestamp(
          author: rating.author.name,
          timestamp: rating.createdAt,
        ),
      ],
    );
  }
}
