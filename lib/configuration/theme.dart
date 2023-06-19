import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme.g.dart';

@riverpod
class ThemeManager extends _$ThemeManager {
  String get _fontFamily => 'Nunito';

  @override
  ThemeData build() {
    return _generateThemeData(
      primaryColor: const Color(0xFFF44336),
      fontFamily: _fontFamily,
    );
  }

  void setPrimaryColor(Color primaryColor) {
    state = state.copyWith(primaryColor: primaryColor);
  }

  ThemeData _generateThemeData({
    required Color primaryColor,
    required String fontFamily,
  }) {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        outlineVariant: const Color(0xFFDDE0E4),
      ),
      dividerTheme: const DividerThemeData(space: 42),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          iconSize: const MaterialStatePropertyAll(18),
          side: MaterialStatePropertyAll(
            BorderSide(color: primaryColor),
          ),
          textStyle: MaterialStatePropertyAll(
            TextStyle(
              fontFamily: fontFamily,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      textTheme: TextTheme(
        labelMedium: TextStyle(
          color: const Color(0xFF98A2A8),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: const Color(0xFF4D585F),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w400,
        ),
        titleLarge: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w400,
        ),
        headlineSmall: TextStyle(
          color: const Color(0xFF697B86),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
        ),
      ),
      useMaterial3: true,
    );
  }
}
