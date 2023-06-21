import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../widgets/login_form.dart';
import '../hooks/use_login_screen_theme_override.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeOverride = useLoginScreenThemeOverride(Theme.of(context));

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0x4BFEC107),
                  Color(0x20FFEBAE),
                  Color(0x00FFFFFF),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Theme(
              data: themeOverride,
              child: const LoginForm(),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
