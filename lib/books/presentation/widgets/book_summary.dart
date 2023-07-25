import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/books/presentation/hooks/use_book_read_percentage.dart';
import 'package:reading/books/presentation/widgets/animation_percentage_meter.dart';
import 'package:reading/common/presentation/theme_extension.dart';
import 'package:unicons/unicons.dart';

class BookSummary extends HookWidget {
  const BookSummary({
    super.key,
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    final percentageRead = useBookReadPercentage(book);

    return Column(
      children: [
        Center(
          child: AnimatedPercentageMeter(
            percentage: percentageRead,
            duration: Theme.of(context).animationExtension!.duration,
            curve: Theme.of(context).animationExtension!.curve,
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: Theme.of(context).animationExtension!.duration,
          switchInCurve: Theme.of(context).animationExtension!.curve,
          switchOutCurve: Theme.of(context).animationExtension!.curve,
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: Column(
            key: ValueKey(book.id),
            children: [
              Text(
                book.title,
                key: ValueKey(book.id),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorExtension?.gray[800],
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
                    color: Theme.of(context).colorExtension?.gray[400],
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${book.pagesRead} / ${book.pageCount} páginas lidas',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorExtension?.gray[400],
                        ),
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
