import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/data/dtos/new_rating_dto.dart';
import 'package:reading/books/domain/models/book_rating.dart';
import 'package:reading/books/presentation/controllers/new_rating_controller.dart';
import 'package:reading/books/presentation/dialogs/new_rating_dialog.dart';
import 'package:reading/books/presentation/hooks/use_rating_average.dart';
import 'package:reading/books/presentation/widgets/book_rating_tile.dart';
import 'package:reading/books/presentation/widgets/star_rating_widget.dart';
import 'package:reading/shared/presentation/hooks/use_snackbar_error_listener.dart';
import 'package:reading/shared/util/theme_data_extension.dart';
import 'package:unicons/unicons.dart';

class BookRatingsPage extends HookConsumerWidget {
  const BookRatingsPage({
    super.key,
    required this.ratings,
    required this.bookId,
  });

  final List<BookRating> ratings;

  final int bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final average = useRatingAverage(ratings);

    useSnackbarErrorListener(
      ref,
      provider: newRatingControllerProvider,
      messageBuilder: (error) => 'Não foi possível salvar a avaliação.',
    );

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '$average',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 42,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StarRatingWidget(value: average),
                      Text(
                        'Média entre ${ratings.length} opiniões',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium //
                            ?.copyWith(
                              color:
                                  Theme.of(context).colorExtension?.gray[800],
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              FilledButton.icon(
                onPressed: () {
                  showModalBottomSheet<NewRatingDTO?>(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    builder: (context) => const NewRatingDialog(),
                  ).then(
                    (value) => value != null
                        ? ref
                            .read(newRatingControllerProvider.notifier)
                            .addRating(bookId, value)
                        : null,
                  );
                },
                icon: const Icon(UniconsSolid.star),
                label: const Text('Avaliar'),
                style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
        SliverList.builder(
          itemCount: ratings.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: BookRatingTile(
              rating: ratings[index],
            ),
          ),
        ),
      ],
    );
  }
}
