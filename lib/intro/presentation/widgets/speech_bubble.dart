import 'dart:math';

import 'package:flutter/material.dart';

class SpeechBubble extends StatelessWidget {
  const SpeechBubble({
    super.key,
    required this.icon,
  });

  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 124,
      height: 124,
      child: Stack(
        alignment: const Alignment(0, -0.2),
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _SpeechBubblePainter(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
              ),
            ),
          ),
          icon,
        ],
      ),
    );
  }
}

class _SpeechBubblePainter extends CustomPainter {
  const _SpeechBubblePainter({
    required this.color,
  });

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const tailsize = 20.0;
    final bubbleBottom = size.height - 10;

    final paint = Paint()..color = color;
    final rrect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      bubbleBottom,
      const Radius.circular(30),
    );
    final crect = Rect.fromLTRB(0, bubbleBottom, size.width, size.height);
    final rrect2 = RRect.fromLTRBR(
      0,
      0,
      tailsize,
      tailsize,
      const Radius.circular(4),
    );
    canvas
      ..drawRRect(rrect, paint)
      ..clipRect(crect)
      ..translate(size.width / 2, size.height - tailsize * 1.4)
      ..rotate(pi / 4)
      ..drawRRect(rrect2, paint);
  }

  @override
  bool shouldRepaint(covariant _SpeechBubblePainter oldDelegate) =>
      oldDelegate.color != color;
}
