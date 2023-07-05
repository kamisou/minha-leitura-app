import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/books/presentation/hooks/use_book_read_percentage.dart';
import 'package:reading/books/presentation/widgets/animation_percentage_meter.dart';
import 'package:unicons/unicons.dart';

class BookSummary extends HookWidget {
  const BookSummary({
    super.key,
    required this.book,
  });

  static const _duration = Duration(milliseconds: 500);

  static const _curve = Curves.easeInOutQuart;

  final Book book;

  @override
  Widget build(BuildContext context) {
    final percentageRead = useBookReadPercentage(book);

    return Column(
      children: [
        Center(
          child: AnimatedPercentageMeter(
            percentage: percentageRead,
            duration: _duration,
            curve: _curve,
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: _duration,
          switchInCurve: _curve,
          switchOutCurve: _curve,
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: Column(
            key: ValueKey(book.id),
            children: [
              Text(
                book.title,
                key: ValueKey(book.id),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      // TODO(kamisou): lidar com essa cor repetida
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
