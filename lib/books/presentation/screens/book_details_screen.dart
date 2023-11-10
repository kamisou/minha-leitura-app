import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/data/cached/book_notes.dart';
import 'package:reading/books/data/cached/book_ratings.dart';
import 'package:reading/books/data/cached/book_readings.dart';
import 'package:reading/books/presentation/pages/book_details/book_details_page.dart';
import 'package:reading/books/presentation/pages/book_details/book_notes_page.dart';
import 'package:reading/books/presentation/pages/book_details/book_ratings_page.dart';
import 'package:reading/books/presentation/widgets/animation_percentage_meter.dart';
import 'package:reading/debugging/presentation/widgets/debug_scaffold.dart';
import 'package:reading/shared/presentation/hooks/use_asyncvalue_listener.dart';
import 'package:reading/shared/presentation/widgets/book_cover.dart';
import 'package:reading/shared/util/bytes_extension.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class BookDetailsScreen extends HookConsumerWidget {
  const BookDetailsScreen({
    super.key,
    required this.bookId,
  });

  final int bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 3);
    final bookDetails = ref.watch(bookDetailsProvider(bookId));

    return DebugScaffold(
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
                      Image.memory(
                        bookDetails.book.cover ?? Uint8List(0),
                        fit: BoxFit.cover,
                        opacity: const AlwaysStoppedAnimation(0.4),
                        height: MediaQuery.of(context).size.height * 0.2,
                        errorBuilder: (context, error, stackTrace) => Container(
                          alignment: Alignment.center,
                          color: Theme.of(context).disabledColor,
                          height: MediaQuery.of(context).size.height * 0.2,
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
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 12,
                                  color: Color(0x18000000),
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: BookCover(
                              image: bookDetails.book.cover?.toImage(),
                            ),
                          ),
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
                    bookDetails.book.author,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorExtension?.gray[500],
                          fontWeight: FontWeight.w700,
                        ),
                    textAlign: TextAlign.center,
                  ),
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
                splashFactory: NoSplash.splashFactory,
                tabs: const [
                  Tab(text: 'Detalhes'),
                  Tab(text: 'Anotações'),
                  Tab(text: 'Avaliações'),
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
              child: Consumer(
                builder: (context, ref, child) {
                  logAsyncValueError(ref, bookNotesProvider(bookDetails.id));

                  return ref.watch(bookNotesProvider(bookDetails.id)).maybeWhen(
                        skipLoadingOnRefresh: false,
                        data: (notes) => BookNotesPage(
                          bookId: bookDetails.id,
                          notes: notes,
                        ),
                        orElse: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Consumer(
                builder: (context, ref, child) {
                  logAsyncValueError(
                    ref,
                    bookRatingsProvider(bookDetails.book.id),
                  );

                  return ref
                      .watch(bookRatingsProvider(bookDetails.book.id))
                      .maybeWhen(
                        skipLoadingOnRefresh: false,
                        data: (ratings) => BookRatingsPage(
                          book: bookDetails,
                          ratings: ratings.data,
                        ),
                        orElse: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
