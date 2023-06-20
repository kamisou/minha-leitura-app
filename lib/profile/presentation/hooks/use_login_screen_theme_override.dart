import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ThemeData useLoginScreenThemeOverride(ThemeData baseTheme) {
  return use(
    _LoginThemeData(
      themeData: baseTheme.copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionHandleColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: MaterialStateOutlineInputBorder.resolveWith(
            (states) {
              final Color color = states.contains(MaterialState.focused)
                  ? Colors.white
                  : Colors.transparent;

              return OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide(color: color),
              );
            },
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          fillColor: const Color(0x19FFFFFF),
          filled: true,
          hintStyle: TextStyle(
            color: Colors.white,
            fontFamily: baseTheme.textTheme.bodyLarge?.fontFamily,
          ),
          suffixIconColor: Colors.white,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            fontFamily: baseTheme.textTheme.bodyLarge?.fontFamily,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

class _LoginThemeData extends Hook<ThemeData> {
  const _LoginThemeData({
    required this.themeData,
  });

  final ThemeData themeData;

  @override
  HookState<ThemeData, Hook<ThemeData>> createState() => _LoginThemeDataState();
}

class _LoginThemeDataState extends HookState<ThemeData, _LoginThemeData> {
  late ThemeData _themeData;

  @override
  void initHook() {
    super.initHook();
    _themeData = hook.themeData;
  }

  @override
  ThemeData build(BuildContext context) {
    return _themeData;
  }
}
