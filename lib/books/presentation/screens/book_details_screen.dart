import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/data/repositories/book_note_repository.dart';
import 'package:reading/books/data/repositories/book_reading_repository.dart';
import 'package:reading/books/presentation/pages/book_details/book_details_page.dart';
import 'package:reading/books/presentation/pages/book_details/book_notes_page.dart';
import 'package:reading/books/presentation/widgets/animation_percentage_meter.dart';
import 'package:reading/shared/presentation/widgets/book_cover.dart';
import 'package:reading/shared/util/theme_data_extension.dart';
import 'package:unicons/unicons.dart';

class BookDetailsScreen extends HookConsumerWidget {
  const BookDetailsScreen({
    super.key,
    required this.bookId,
  });

  final int bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);
    final bookDetails = ref.watch(bookDetailsProvider(bookId));

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.network(
                        bookDetails.book.cover ?? '',
                        fit: BoxFit.cover,
                        opacity: const AlwaysStoppedAnimation(0.4),
                        height: MediaQuery.of(context).size.height * 0.2,
                        errorBuilder: (context, error, stackTrace) => Container(
                          alignment: Alignment.center,
                          color: Theme.of(context).disabledColor,
                          child: const Icon(UniconsThinline.image_v),
                        ),
                      ),
                      Container(
                        height: 4,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () => context.go('/'),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.chevron_left,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: BookCover(url: bookDetails.book.cover),
                        ),
                        const Expanded(
                          flex: 2,
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    '${bookDetails.percentageRead.toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedPercentageMeter(
                    percentage: bookDetails.percentageRead,
                    duration: Duration.zero,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    bookDetails.book.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorExtension?.gray[800],
                          fontWeight: FontWeight.w700,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    bookDetails.book.author ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorExtension?.gray[500],
                          fontWeight: FontWeight.w700,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  // const SizedBox(height: 20),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 24),
                  //   child: Wrap(
                  //     spacing: 16,
                  //     children: [
                  //       FilledButton.icon(
                  //         onPressed: () {
                  //           // TODO: implement define goals
                  //           throw UnimplementedError();
                  //         },
                  //         icon: const Icon(UniconsLine.book_open),
                  //         label: const Text('Definir Meta'),
                  //       ),
                  //       OutlinedButton.icon(
                  //         onPressed: () {
                  //           // TODO: implement share book
                  //           throw UnimplementedError();
                  //         },
                  //         icon: const Icon(UniconsLine.share_alt),
                  //         label: const Text('Compartilhar'),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            sliver: SliverToBoxAdapter(
              child: TabBar(
                controller: tabController,
                indicator: const BoxDecoration(),
                isScrollable: true,
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.3,
                ),
                physics: const NeverScrollableScrollPhysics(),
                splashFactory: NoSplash.splashFactory,
                tabs: const [
                  Tab(text: 'Detalhes'),
                  Tab(text: 'Anotações'),
                  // Tab(text: 'Histórico'),
                  // Tab(text: 'Avaliações'),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: tabController,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: BookDetailsPage(book: bookDetails),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ref.watch(bookNotesProvider(bookDetails.id)).maybeWhen(
                    data: (data) => BookNotesPage(
                      bookId: bookDetails.id,
                      notes: data,
                    ),
                    error: (error, stackTrace) => Text('$error:\n$stackTrace'),
                    orElse: () => const SizedBox(),
                  ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 24),
            //   child: ref.watch(bookReadingsProvider(book.id)).maybeWhen(
            //         data: (data) => BookReadingPage(readings: data),
            //         orElse: () => const SizedBox(),
            //       ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 24),
            //   child: ref.watch(bookRatingsProvider(book.id)).maybeWhen(
            //         data: (data) => BookRatingsPage(
            //           bookId: book.id,
            //           ratings: data,
            //         ),
            //         orElse: () => const SizedBox(),
            //       ),
            // ),
          ],
        ),
      ),
    );
  }
}
