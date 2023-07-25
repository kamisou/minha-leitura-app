import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/shared/presentation/widgets/book_cover.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class Bookshelf extends StatelessWidget {
  const Bookshelf({
    super.key,
    required this.books,
    required this.booksPerRow,
  });

  final List<Book> books;

  final int booksPerRow;

  @override
  Widget build(BuildContext context) {
    final rowCount = (books.length / booksPerRow).ceil();

    return Column(
      children: [
        for (var row = 0; row < rowCount; row += 1)
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CustomPaint(
                painter: _ShelfPainter(
                  backColor: Colors.white,
                  frontColor: Theme.of(context).colorExtension!.gray[200]!,
                ),
                size: const Size.fromHeight(46),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var book = 0; book < booksPerRow; book += 1)
                      if (row * booksPerRow + book < books.length)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: GestureDetector(
                            onTap: () => context.go(
                              '/book',
                              extra: books[row * booksPerRow + book],
                            ),
                            child: BookCover(
                              url: books[row * booksPerRow + book].coverArt,
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _ShelfPainter extends CustomPainter {
  const _ShelfPainter({
    required this.frontColor,
    required this.backColor,
  });

  final Color frontColor;

  final Color backColor;

  @override
  void paint(Canvas canvas, Size size) {
    const shelfThickness = 4.0;
    const shelfBackHeight = 42.0;
    const shelfBackWidthReduction = 24.0;

    final frontPaint = Paint()..color = frontColor;
    final backPaint = Paint()..color = backColor;

    final frontRRect = RRect.fromRectAndCorners(
      Rect.fromLTRB(
        0,
        size.height - shelfThickness,
        size.width,
        size.height,
      ),
      bottomLeft: const Radius.circular(2),
      bottomRight: const Radius.circular(2),
    );
    final backTrapezoid = Path()
      ..moveTo(0, size.height - shelfThickness)
      ..lineTo(size.width, size.height - shelfThickness)
      ..lineTo(
        size.width - shelfBackWidthReduction,
        size.height - shelfThickness - shelfBackHeight,
      )
      ..lineTo(
        0 + shelfBackWidthReduction,
        size.height - shelfThickness - shelfBackHeight,
      );

    canvas
      ..drawShadow(backTrapezoid, const Color(0x7F000000), 10, false)
      ..drawPath(backTrapezoid, backPaint)
      ..drawRRect(frontRRect, frontPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
