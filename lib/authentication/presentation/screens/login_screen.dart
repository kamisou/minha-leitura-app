import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/presentation/hooks/use_snackbar_error_listener.dart';
import '../../widgets/login_form.dart';
import '../controllers/login_controller.dart';
import '../hooks/use_login_screen_theme_override.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeOverride = useLoginScreenThemeOverride(Theme.of(context));

    useSnackbarErrorListener(
      ref,
      provider: loginControllerProvider,
      message: 'A senha ou e-mail estão incorretos.',
    );

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
