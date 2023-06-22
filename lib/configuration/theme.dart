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
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
      ),
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        inverseSurface: const Color(0xFF202020),
        onInverseSurface: Colors.white,
        onSurfaceVariant: const Color(0xFF313539),
        outlineVariant: const Color(0xFFDDE0E4),
        primary: primaryColor,
        surface: const Color(0x19A49A99),
      ),
      disabledColor: const Color(0xFFE6E6E6),
      dividerTheme: const DividerThemeData(space: 42),
      inputDecorationTheme: InputDecorationTheme(
        border: MaterialStateOutlineInputBorder.resolveWith(
          (states) {
            final Color color = states.contains(MaterialState.focused)
                ? primaryColor
                : const Color(0xFFA39A99);

            return OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide(
                color: color,
              ),
            );
          },
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        filled: true,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          iconSize: const MaterialStatePropertyAll(18),
          side: MaterialStatePropertyAll(
            BorderSide(color: primaryColor),
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      textTheme: TextTheme(
        // 14
        bodyMedium: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w400,
        ),
        // 16
        bodyLarge: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w400,
        ),
        // 12
        labelMedium: TextStyle(
          color: const Color(0xFF98A2A8),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
        ),
        // 14
        labelLarge: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
        ),
        // 16
        titleMedium: TextStyle(
          color: const Color(0xFF4D585F),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w400,
        ),
        // 22
        titleLarge: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w400,
        ),
        // 24
        headlineSmall: TextStyle(
          color: const Color(0xFF697B86),
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
        ),
        // 28
        headlineMedium: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
        ),
      ),
      useMaterial3: true,
    );
  }
}
