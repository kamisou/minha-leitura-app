import 'package:flutter/material.dart';

class AnimationExtension extends ThemeExtension<AnimationExtension> {
  const AnimationExtension({
    required this.curve,
    required this.duration,
  });

  final Curve curve;

  final Duration duration;

  @override
  ThemeExtension<AnimationExtension> copyWith({
    Curve? curve,
    Duration? duration,
  }) =>
      AnimationExtension(
        curve: curve ?? this.curve,
        duration: duration ?? this.duration,
      );

  @override
  ThemeExtension<AnimationExtension> lerp(
    covariant ThemeExtension<AnimationExtension>? other,
    double t,
  ) {
    if (other is! AnimationExtension) {
      return this;
    }

    return AnimationExtension(
      curve: other.curve,
      duration: other.duration,
    );
  }
}
