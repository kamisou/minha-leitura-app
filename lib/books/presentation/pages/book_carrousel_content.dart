import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../shared/presentation/hooks/use_page_notifier.dart';
import '../../domain/models/book.dart';
import '../widgets/book_details.dart';

class BookCarrouselContent extends HookWidget {
  BookCarrouselContent({
    super.key,
    required this.books,
  }) : assert(books.isNotEmpty);

  final List<Book> books;

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
                  color: Theme.of(context).textTheme.headlineSmall?.color,
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
        const SizedBox(height: 32),
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: books.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => AspectRatio(
              aspectRatio: 0.7,
              child: Center(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Image.network(books[index].coverArt),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        BookDetails(book: books[page.value]),
      ],
    );
  }
}
