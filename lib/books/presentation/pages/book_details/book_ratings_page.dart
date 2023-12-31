import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/data/cached/book_ratings.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/books/domain/models/book_rating.dart';
import 'package:reading/books/presentation/controllers/new_rating_controller.dart';
import 'package:reading/books/presentation/dialogs/new_rating_dialog.dart';
import 'package:reading/books/presentation/hooks/use_rating_average.dart';
import 'package:reading/books/presentation/widgets/book_rating_tile.dart';
import 'package:reading/books/presentation/widgets/star_rating_widget.dart';
import 'package:reading/profile/data/cached/profile.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
import 'package:reading/shared/exceptions/rest_exception.dart';
import 'package:reading/shared/presentation/hooks/use_controller_listener.dart';
import 'package:reading/shared/presentation/hooks/use_lazy_scroll_controller.dart';
import 'package:reading/shared/util/theme_data_extension.dart';
import 'package:unicons/unicons.dart';

class BookRatingsPage extends HookConsumerWidget {
  const BookRatingsPage({
    super.key,
    required this.ratings,
    required this.book,
  });

  final List<BookRating> ratings;

  final BookDetails book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final average = useRatingAverage(ratings);
    final myRating = useMemoized(
      () => ratings.cast<BookRating?>().firstWhere(
            (rating) =>
                rating!.author.id == //
                ref.watch(profileProvider).requireValue!.id,
            orElse: () => null,
          ),
      [ratings],
    );
    final scrollController = useLazyScrollController(
      onEndOfScroll: ref.watch(bookRatingsProvider(book.book.id).notifier).next,
    );

    useAutomaticKeepAlive();

    useControllerListener(
      ref,
      controller: newRatingControllerProvider,
      onError: (error) => switch (error) {
        BadResponseRestException(message: final message) => message,
        OnlineOnlyOperationException() => 'Você precisa conectar-se à internet',
        _ => null,
      },
    );

    return RefreshIndicator(
      onRefresh: ref.read(bookRatingsProvider(book.book.id).notifier).refresh,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      average.toStringAsFixed(1),
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 42,
                              ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StarRatingWidget(value: average),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            'Média entre ${ratings.length} opiniões',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium //
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorExtension
                                      ?.gray[800],
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                FilledButton.icon(
                  onPressed:
                      book.status == BookStatus.finished && myRating == null
                          ? () => showModalBottomSheet<void>(
                                backgroundColor:
                                    Theme.of(context).colorScheme.background,
                                context: context,
                                isScrollControlled: true,
                                showDragHandle: true,
                                builder: (context) =>
                                    NewRatingDialog(bookId: book.book.id),
                              )
                          : null,
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
          if (ratings.isNotEmpty)
            SliverList.builder(
              itemCount: ratings.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: BookRatingTile(
                  rating: ratings[index],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Nenhuma avaliação',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorExtension?.gray[500],
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
