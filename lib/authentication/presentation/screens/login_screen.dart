import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/authentication/presentation/content/login_content.dart';
import 'package:reading/authentication/presentation/controllers/login_controller.dart';
import 'package:reading/intro/presentation/hooks/use_intro_screen_theme_override.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
import 'package:reading/shared/exceptions/rest_exception.dart';
import 'package:reading/shared/presentation/hooks/use_controller_listener.dart';
import 'package:reading/shared/presentation/widgets/gradient_intro_background.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeOverride = useIntroScreenThemeOverride();

    useControllerListener(
      ref,
      controller: loginControllerProvider,
      onError: (error) => switch (error) {
        BadResponseRestException(message: final message) => message,
        OnlineOnlyOperationException() => 'Você precisa conectar-se à internet',
        _ => 'Não foi possível realizar login',
      },
      onSuccess: () => context.go('/'),
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
              child: const LoginContent(),
            ),
          ),
        ),
      ],
    );
  }
}
