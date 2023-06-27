import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:unicons/unicons.dart';

class BookDetails extends HookWidget {
  const BookDetails({
    super.key,
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 500);
    const curve = Curves.easeInOutQuart;

    final percentageRead = useMemoized(
      () => book.pagesRead / book.pageCount * 100.0,
      [book.pageCount, book.pagesRead],
    );

    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(.2),
                  shape: const StadiumBorder(),
                ),
                width: 100,
                height: 6,
              ),
              AnimatedPositioned(
                duration: duration,
                curve: curve,
                left: 0,
                width: percentageRead,
                height: 6,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: duration,
          switchInCurve: curve,
          switchOutCurve: curve,
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: Column(
            key: ValueKey(book.id),
            children: [
              Text(
                book.title,
                key: ValueKey(book.id),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF3B4149),
                      fontWeight: FontWeight.w700,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    UniconsLine.bookmark,
                    color: Theme.of(context).textTheme.labelMedium?.color,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${book.pagesRead} / ${book.pageCount} páginas lidas',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
