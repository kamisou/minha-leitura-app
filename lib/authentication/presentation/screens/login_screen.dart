import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/authentication/presentation/controllers/login_controller.dart';
import 'package:reading/authentication/presentation/hooks/use_login_screen_theme_override.dart';
import 'package:reading/authentication/presentation/widgets/login_form.dart';
import 'package:reading/common/exceptions/rest_exception.dart';
import 'package:reading/common/presentation/hooks/use_snackbar_error_listener.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeOverride = useLoginScreenThemeOverride(Theme.of(context));

    useSnackbarErrorListener(
      ref,
      provider: loginControllerProvider,
      messageBuilder: (error) => switch (error) {
        BadResponseRestException(message: final message) => message,
        NoResponseRestException() =>
          'Você está sem acesso à internet. Tente novamente mais tarde.',
        _ => null,
      },
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
