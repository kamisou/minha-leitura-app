import 'package:flutter/material.dart';

class ColorExtension extends ThemeExtension<ColorExtension> {
  const ColorExtension({
    required this.gray,
    required this.information,
  });

  final MaterialColor gray;

  final Color information;

  @override
  ThemeExtension<ColorExtension> copyWith({
    MaterialColor? gray,
    Color? information,
  }) =>
      ColorExtension(
        gray: gray ?? this.gray,
        information: information ?? this.information,
      );

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
      information: Color.lerp(information, other.information, t) ?? information,
    );
  }
}
