import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color withLightness(double lightness) {
    final newColor = HSLColor.fromColor(this);
    return newColor.withLightness(lightness).toColor();
  }

  MaterialStateColor get materialStateAll =>
      MaterialStateColor.resolveWith((states) => this);
}
