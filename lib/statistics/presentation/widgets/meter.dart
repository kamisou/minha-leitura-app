import 'dart:math';

import 'package:flutter/material.dart';

class Meter extends StatelessWidget {
  const Meter({
    super.key,
    required this.value,
    required this.max,
    required this.radius,
    this.backgroundColor,
    this.color,
    this.gradient,
    this.label,
    this.labelStyle,
    this.style,
  }) : assert(
          (color != null) ^ (gradient != null),
          'Color and Gradient are exclusive!',
        );

  final double value;

  final double max;

  final double radius;

  final Color? backgroundColor;

  final Color? color;

  final Gradient? gradient;

  final String? label;

  final TextStyle? labelStyle;

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomPaint(
              size: Size(
                radius * 2,
                radius,
              ),
              painter: _MeterPainter(
                value: value,
                max: max,
                backgroundColor: backgroundColor,
                color: color,
                gradient: gradient,
              ),
            ),
            Positioned(
              bottom: -6,
              child: Text(
                value.toStringAsPrecision(2),
                style: style,
              ),
            ),
          ],
        ),
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              label!,
              style: labelStyle,
            ),
          ),
      ],
    );
  }
}

class _MeterPainter extends CustomPainter {
  const _MeterPainter({
    this.value,
    this.max,
    this.backgroundColor,
    this.color,
    this.gradient,
  });

  final double? value;

  final double? max;

  final Color? backgroundColor;

  final Color? color;

  final Gradient? gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0, 0, size.width, size.height * 2);

    final backgroundPaint = Paint();
    final fillPaint = Paint();

    final sweepAngle =
        value != null && max != null ? (value! / max!) * -pi : 0.0;

    if (backgroundColor != null) {
      backgroundPaint.color = backgroundColor!;
    }

    if (color != null) {
      fillPaint.color = color!;
    } else if (gradient != null) {
      fillPaint.shader = gradient!.createShader(rect);
    }

    final clipPath = Path()
      ..addArc(rect.deflate(16), 0, 2 * pi)
      ..addRect(rect)
      ..fillType = PathFillType.evenOdd;

    canvas
      ..clipPath(clipPath)
      ..drawArc(rect, 0, -pi, true, backgroundPaint)
      ..drawArc(rect, pi, -sweepAngle, true, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _MeterPainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.max != max ||
      oldDelegate.color != color ||
      oldDelegate.gradient != gradient;
}
