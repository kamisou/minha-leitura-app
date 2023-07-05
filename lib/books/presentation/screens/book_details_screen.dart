import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/books/presentation/hooks/use_book_read_percentage.dart';
import 'package:reading/books/presentation/widgets/animation_percentage_meter.dart';
import 'package:reading/common/presentation/widgets/book_cover.dart';
import 'package:unicons/unicons.dart';

class BookDetailsScreen extends HookWidget {
  const BookDetailsScreen({
    super.key,
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    final percentageRead = useBookReadPercentage(book);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 4,
                      ),
                    ),
                  ),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: 5.5,
                      sigmaY: 5.5,
                    ),
                    child: Image.network(
                      book.coverArt,
                      fit: BoxFit.cover,
                      opacity: const AlwaysStoppedAnimation(0.6),
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                  ),
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
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: BookCover(url: book.coverArt),
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
          Column(
            children: [
              Text(
                '${percentageRead.toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              AnimatedPercentageMeter(
                percentage: percentageRead,
                duration: Duration.zero,
              ),
              const SizedBox(height: 18),
              Text(
                book.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      // TODO(kamisou): lidar com essa cor repetida
                      color: const Color(0xFF3B4149),
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                book.author,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF808E96),
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrap(
                  spacing: 16,
                  children: [
                    FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(UniconsLine.book_open),
                      label: const Text('Definir Meta'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(UniconsLine.share_alt),
                      label: const Text('Compartilhar'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 38),
            ],
          ),
        ],
      ),
    );
  }
}
