import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/books/presentation/widgets/book_details.dart';
import 'package:reading/shared/presentation/hooks/use_page_notifier.dart';
import 'package:reading/shared/presentation/widgets/loading_network_image.dart';

class BookCarrouselContent extends HookWidget {
  BookCarrouselContent({
    super.key,
    required this.books,
  }) : assert(books.isNotEmpty, 'The book carrousel cannot be empty!');

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
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => Center(
              child: AspectRatio(
                aspectRatio: 0.7,
                child: LoadingNetworkImage(
                  src: books[index].coverArt,
                  builder: (image) => Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: image,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        ValueListenableBuilder(
          valueListenable: page,
          builder: (context, value, child) => BookDetails(
            book: books[page.value],
          ),
        ),
      ],
    );
  }
}
