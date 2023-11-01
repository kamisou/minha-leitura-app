import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/books/presentation/widgets/book_summary.dart';
import 'package:reading/shared/data/paginated_resource.dart';
import 'package:reading/shared/presentation/hooks/use_page_notifier.dart';
import 'package:reading/shared/presentation/widgets/book_cover.dart';
import 'package:reading/shared/presentation/widgets/new_book_widget.dart';
import 'package:reading/shared/util/bytes_extension.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class BookCarrouselContent extends HookConsumerWidget {
  const BookCarrouselContent({
    super.key,
    required this.books,
    required this.pageController,
  });

  final PaginatedResource<BookDetails> books;

  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = usePageNotifier(pageController);
    final pendingBooks = useMemoized(
      () => books.data
          .where((book) => book.status != BookStatus.finished)
          .toList(),
      [books.data],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Lendo agora',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
          textAlign: TextAlign.center,
        ),
        RichText(
          text: TextSpan(
            text: 'você está lendo ',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorExtension?.gray[600],
                ),
            children: [
              TextSpan(
                text: '${pendingBooks.length} livros',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const TextSpan(text: ' no momento.'),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: pendingBooks.length + 1,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == pendingBooks.length) {
                if (books.loading && !books.finished) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(
                    child: GestureDetector(
                      onTap: () => context.go('/book/new'),
                      child: const NewBookWidget(),
                    ),
                  );
                }
              }

              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () =>
                      context.go('/book', extra: pendingBooks[index].id),
                  child: BookCover(
                    image: pendingBooks[index].book.cover?.toImage(),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ValueListenableBuilder(
            valueListenable: page,
            builder: (context, value, child) {
              if (value == pendingBooks.length) {
                return const SizedBox(height: 138);
              }

              return BookSummary(
                book: pendingBooks[value],
              );
            },
          ),
        ),
      ],
    );
  }
}
