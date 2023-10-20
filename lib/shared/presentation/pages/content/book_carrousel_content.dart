import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/data/repositories/book_repository.dart';
import 'package:reading/books/presentation/widgets/book_summary.dart';
import 'package:reading/shared/presentation/hooks/use_page_notifier.dart';
import 'package:reading/shared/presentation/widgets/book_cover.dart';
import 'package:reading/shared/presentation/widgets/new_book_widget.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class BookCarrouselContent extends HookConsumerWidget {
  const BookCarrouselContent({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(myBooksProvider).requireValue;
    final page = usePageNotifier(pageController);

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
                text: '${books.data.length} livros',
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
            itemCount: books.data.length + 1,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == books.data.length) {
                if (books.loading) {
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
                  onTap: () => context.go('/book', extra: books.data[index].id),
                  child: BookCover.raw(bytes: books.data[index].book.cover),
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
              if (value == books.data.length) {
                return const SizedBox(height: 138);
              }

              return BookSummary(
                book: books.data[value],
              );
            },
          ),
        ),
      ],
    );
  }
}
