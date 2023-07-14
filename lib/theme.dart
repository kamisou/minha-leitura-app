import 'package:flutter/material.dart';
import 'package:reading/common/extensions/color_extension.dart';
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
        outlineVariant: const Color(0xFFDDE0E4),
        primary: primaryColor,
        surface: const Color(0x189A9A9A),
      ),
      disabledColor: const Color(0xFFE6E6E6),
      dividerTheme: const DividerThemeData(space: 42),
      extensions: const [
        ColorExtension(
          gray: MaterialColor(
            0xFF3B4149,
            {
              100: Color(0xFFFAFAFA),
              200: Color(0xFFE8EAED),
              300: Color(0xFFB7BCBF),
              400: Color(0xFF98A2A8),
              500: Color(0xFF808E96),
              600: Color(0xFF697B86),
              700: Color(0xFF4D585F),
              800: Color(0xFF3B4149),
            },
          ),
        ),
      ],
      inputDecorationTheme: InputDecorationTheme(
        border: MaterialStateOutlineInputBorder.resolveWith(
          (states) => OutlineInputBorder(
            borderSide: states.contains(MaterialState.error)
                ? const BorderSide(
                    color: Color(0xFFFF4336),
                  )
                : BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
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
      tabBarTheme: TabBarTheme(
        labelColor: const Color(0xFF3B4149),
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelColor: const Color(0xFFB7BCBF),
        unselectedLabelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
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
