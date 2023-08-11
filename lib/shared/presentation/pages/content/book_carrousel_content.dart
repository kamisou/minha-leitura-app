import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/books/presentation/widgets/book_summary.dart';
import 'package:reading/shared/presentation/hooks/use_page_notifier.dart';
import 'package:reading/shared/presentation/widgets/book_cover.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class BookCarrouselContent extends HookWidget {
  BookCarrouselContent({
    super.key,
    required this.books,
  }) : assert(books.isNotEmpty, 'The book carrousel cannot be empty!');

  final List<BookDetails> books;

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(viewportFraction: 0.72);
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
                text: '${books.length} livros',
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
            itemCount: books.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () => context.go('/book', extra: books[index]),
                child: BookCover(url: books[index].book.cover),
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: page,
          builder: (context, value, child) => BookSummary(
            book: books[page.value],
          ),
        ),
      ],
    );
  }
}
