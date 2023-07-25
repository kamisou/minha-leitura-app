import 'package:flutter/material.dart';
import 'package:reading/shared/presentation/theme_extensions/animation_extension.dart';
import 'package:reading/shared/presentation/theme_extensions/color_extension.dart';

extension ThemeDataExtension on ThemeData {
  AnimationExtension? get animationExtension => extension<AnimationExtension>();

  ColorExtension? get colorExtension => extension<ColorExtension>();
}
