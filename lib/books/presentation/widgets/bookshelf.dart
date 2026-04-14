import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/books/presentation/hooks/use_status_info.dart';
import 'package:reading/books/presentation/widgets/shelf.dart';
import 'package:reading/shared/presentation/widgets/book_cover.dart';
import 'package:reading/shared/util/bytes_extension.dart';

class Bookshelf extends HookWidget {
  const Bookshelf({
    super.key,
    required this.books,
  });

  static const _booksPerRow = 3;

  final List<BookDetails> books;

  @override
  Widget build(BuildContext context) {
    final rowCount = (books.length / _booksPerRow).ceil();
    final coverWidth = useMemoized(
      () => MediaQuery.of(context).size.width * 0.22,
    );

    return Column(
      children: [
        for (var row = 0; row < rowCount; row += 1)
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              const Shelf(),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var book = 0; book < _booksPerRow; book += 1)
                      SizedBox(
                        width: coverWidth,
                        child: _bookBuilder(context, row, book),
                      ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget? _bookBuilder(BuildContext context, int row, int index) {
    if (row * _booksPerRow + index >= books.length) {
      return null;
    }

    final book = books[row * _booksPerRow + index];

    return GestureDetector(
      onTap: () => context.go('/book', extra: book.id),
      child: Stack(
        children: [
          BookCover(
            image: book.book.cover?.toImage(),
          ),
          Positioned(
            top: 0,
            right: 8,
            child: CustomPaint(
              size: const Size(14, 20),
              painter: _FlairPainter(
                color: useStatusInfo(book.status).color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlairPainter extends CustomPainter {
  const _FlairPainter({
    required this.color,
  });

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, size.height - size.height * 0.3)
      ..lineTo(0, size.height)
      ..lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
