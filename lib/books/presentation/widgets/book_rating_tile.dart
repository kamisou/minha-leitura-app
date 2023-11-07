import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/books/domain/models/book_rating.dart';
import 'package:reading/books/presentation/controllers/new_rating_controller.dart';
import 'package:reading/books/presentation/widgets/author_timestamp.dart';
import 'package:reading/books/presentation/widgets/star_rating_widget.dart';
import 'package:reading/profile/data/cached/profile.dart';
import 'package:reading/shared/presentation/widgets/button_progress_indicator.dart';
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
            StarRatingWidget(
              iconSize: 16,
              value: rating.rating,
            ),
            if (rating.author.id == ref.watch(profileProvider).requireValue!.id)
              SizedBox(
                width: 24,
                height: 24,
                child: ButtonProgressIndicator(
                  isLoading: ref.watch(newRatingControllerProvider).isLoading,
                  child: IconButton(
                    onPressed: () => ref
                        .read(newRatingControllerProvider.notifier)
                        .removeRating(rating.bookId, rating),
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      UniconsLine.trash_alt,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
        Text(
          rating.comment,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorExtension?.gray[600]),
        ),
        const SizedBox(height: 16),
        AuthorTimestamp(
          author: rating.author.name,
          timestamp: rating.createdAt,
        ),
      ],
    );
  }
}
