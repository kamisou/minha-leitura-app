import 'package:flutter/material.dart';
import 'package:reading/shared/presentation/theme_extensions/animation_extension.dart';
import 'package:reading/shared/presentation/theme_extensions/color_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme.g.dart';

@riverpod
class ThemeManager extends _$ThemeManager {
  @override
  ThemeData build() {
    const primaryColor = Color(0xFFF44336);
    const fontFamily = 'Nunito';

    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
      ),
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        inverseSurface: Color(0xFF202020),
        onInverseSurface: Colors.white,
        outlineVariant: Color(0xFFDDE0E4),
        primary: primaryColor,
        surface: Color(0x189A9A9A),
      ),
      disabledColor: const Color(0xFFE6E6E6),
      dividerTheme: const DividerThemeData(space: 42),
      extensions: const [
        AnimationExtension(
          curve: Curves.easeInOutQuart,
          duration: Duration(milliseconds: 300),
        ),
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
              900: Color(0x19FFFFFF),
            },
          ),
          information: Color(0xFF2895FA),
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
      outlinedButtonTheme: const OutlinedButtonThemeData(
        style: ButtonStyle(
          iconSize: MaterialStatePropertyAll(18),
          side: MaterialStatePropertyAll(
            BorderSide(color: primaryColor),
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: Color(0xFF3B4149),
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelColor: Color(0xFFB7BCBF),
        unselectedLabelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: const TextTheme(
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

  void setPrimaryColor(Color primaryColor) {
    state = state.copyWith(primaryColor: primaryColor);
  }
}
