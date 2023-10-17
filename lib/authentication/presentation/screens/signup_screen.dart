import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/authentication/presentation/content/signup_content.dart';
import 'package:reading/authentication/presentation/controllers/signup_controller.dart';
import 'package:reading/intro/presentation/hooks/use_intro_screen_theme_override.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
import 'package:reading/shared/exceptions/rest_exception.dart';
import 'package:reading/shared/presentation/hooks/use_snackbar_error_listener.dart';
import 'package:reading/shared/presentation/widgets/gradient_intro_background.dart';
import 'package:reading/shared/presentation/widgets/server_settings_drawer.dart';

class SignupScreen extends HookConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeOverride = useIntroScreenThemeOverride();

    useSnackbarErrorListener(
      ref,
      provider: signupControllerProvider,
      messageBuilder: (error) => switch (error) {
        BadResponseRestException(message: final message) => message,
        OnlineOnlyOperationException() =>
          'Você precisa estar online para se registrar!',
        _ => null,
      },
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const GradientIntroBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Theme(
              data: themeOverride,
              child: const SignupContent(),
            ),
          ),
          drawer: kDebugMode ? const ServerSettingsDrawer() : null,
        ),
      ],
    );
  }
}
