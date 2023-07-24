import 'dart:math';

import 'package:flutter/material.dart';

class Meter extends ImplicitlyAnimatedWidget {
  const Meter({
    super.key,
    required super.duration,
    required this.value,
    required this.max,
    required this.radius,
    super.curve,
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
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _MeterState();
}

class _MeterState extends ImplicitlyAnimatedWidgetState<Meter> {
  Tween<double>? _valueTween;

  Tween<double>? _maxTween;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomPaint(
              size: Size(
                widget.radius * 2,
                widget.radius,
              ),
              painter: _MeterPainter(
                value: _valueTween?.evaluate(animation),
                max: _maxTween?.evaluate(animation),
                backgroundColor: widget.backgroundColor,
                color: widget.color,
                gradient: widget.gradient,
              ),
            ),
            Text(
              widget.value.toStringAsPrecision(1),
              style: widget.style,
            ),
          ],
        ),
        if (widget.label != null)
          Text(
            widget.label!,
            style: widget.labelStyle,
          ),
      ],
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _valueTween = visitor(
      _valueTween,
      widget.value,
      (targetValue) => Tween(begin: targetValue),
    ) as Tween<double>?;
    _maxTween = visitor(
      _maxTween,
      widget.max,
      (targetValue) => Tween(begin: targetValue),
    ) as Tween<double>?;
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
    final rect = Rect.fromLTRB(0, 0, size.width, size.height);

    final backgroundPaint = Paint();
    final fillPaint = Paint();

    final sweepAngle =
        value != null && max != null ? (value! / max!) * (-pi / 2) : 0.0;

    if (backgroundColor != null) {
      backgroundPaint.color = backgroundColor!;
    }

    if (color != null) {
      fillPaint.color = color!;
    } else if (gradient != null) {
      fillPaint.shader = gradient!.createShader(rect);
    }

    canvas
      ..drawArc(rect, 0, -pi / 2, false, backgroundPaint)
      ..drawArc(rect, pi, sweepAngle, false, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _MeterPainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.max != max ||
      oldDelegate.color != color ||
      oldDelegate.gradient != gradient;
}
