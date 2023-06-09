part of '../app.dart';

const Color _primaryColor = Color(0xFFF44336);
const String _fontFamily = 'Nunito';

final ThemeData _theme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: _primaryColor,
  ),
  outlinedButtonTheme: const OutlinedButtonThemeData(
    style: ButtonStyle(
      iconSize: MaterialStatePropertyAll(18),
      side: MaterialStatePropertyAll(
        BorderSide(
          color: _primaryColor,
        ),
      ),
      textStyle: MaterialStatePropertyAll(
        TextStyle(
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  ),
  textTheme: const TextTheme(
    labelMedium: TextStyle(
      color: Color(0xFF98A2A8),
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: Color(0xFF4D585F),
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: TextStyle(
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: TextStyle(
      color: Color(0xFF697B86),
      fontFamily: _fontFamily,
      fontWeight: FontWeight.w700,
    ),
  ),
  useMaterial3: true,
);
