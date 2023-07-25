import 'package:flutter/material.dart';

class ColorExtension extends ThemeExtension<ColorExtension> {
  const ColorExtension({
    required this.gray,
  });

  final MaterialColor gray;

  @override
  ThemeExtension<ColorExtension> copyWith({MaterialColor? gray}) =>
      ColorExtension(gray: gray ?? this.gray);

  @override
  ThemeExtension<ColorExtension> lerp(
    covariant ThemeExtension<ColorExtension>? other,
    double t,
  ) {
    if (other is! ColorExtension) {
      return this;
    }

    return ColorExtension(
      gray: MaterialColor(
        Color.lerp(gray, other.gray, t)?.value ?? gray.value,
        Map.fromEntries(
          [
            MapEntry(50, Color.lerp(gray[50], other.gray[50], t) ?? gray[50]!),
            for (int i = 100; i < 1000; i += 100)
              MapEntry(i, Color.lerp(gray[i], other.gray[i], t) ?? gray[i]!),
          ],
        ),
      ),
    );
  }
}

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

extension ThemeExtensionGetters on ThemeData {
  AnimationExtension? get animationExtension => extension<AnimationExtension>();

  ColorExtension? get colorExtension => extension<ColorExtension>();
}
