import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/authentication/presentation/controllers/login_controller.dart';
import 'package:reading/authentication/presentation/hooks/use_intro_screen_theme_override.dart';
import 'package:reading/authentication/presentation/widgets/login_form.dart';
import 'package:reading/common/exceptions/rest_exception.dart';
import 'package:reading/common/presentation/hooks/use_snackbar_error_listener.dart';
import 'package:reading/common/presentation/widgets/gradient_intro_background.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeOverride = useIntroScreenThemeOverride(Theme.of(context));

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
          const GradientIntroBackground(),
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
