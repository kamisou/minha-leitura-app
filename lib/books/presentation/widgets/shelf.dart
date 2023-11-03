import 'package:flutter/material.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class Shelf extends StatelessWidget {
  const Shelf({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ShelfPainter(
        backColor: Theme.of(context).scaffoldBackgroundColor,
        frontColor: Theme.of(context).colorExtension!.gray[200]!,
      ),
      size: const Size.fromHeight(46),
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
