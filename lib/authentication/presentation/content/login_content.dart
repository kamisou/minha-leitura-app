import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/authentication/data/dtos/login_dto.dart';
import 'package:reading/authentication/domain/value_objects/password.dart';
import 'package:reading/authentication/presentation/controllers/login_controller.dart';
import 'package:reading/authentication/presentation/dialogs/password_recovery_dialog.dart';
import 'package:reading/authentication/presentation/hooks/use_login_form_reducer.dart';
import 'package:reading/profile/domain/value_objects/email.dart';
import 'package:reading/shared/presentation/widgets/button_progress_indicator.dart';
import 'package:reading/shared/presentation/widgets/obsfuscated_text_form_field.dart';

class LoginContent extends HookConsumerWidget {
  const LoginContent({
    super.key,
    this.email,
  });

  final String? email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useRef(GlobalKey<FormState>());
    final loginForm = useLoginFormReducer();

    return Form(
      key: formKey.value,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => context.go('/intro'),
                icon: const Icon(Icons.chevron_left),
              ),
              TextButton(
                onPressed: () => context.go('/signup'),
                child: const Text('Criar conta'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Minha conta',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Preencha seus dados para entrar',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextFormField(
            decoration: const InputDecoration(hintText: 'E-mail'),
            onChanged: (value) => loginForm.dispatch(Email(value)),
            textInputAction: TextInputAction.next,
            validator: (value) => switch (Email.validate(value)) {
              EmailError.empty => 'Informe um endereço de e-mail',
              EmailError.invalid => 'Informe um endereço de e-mail válido',
              _ => null,
            },
          ),
          const SizedBox(height: 24),
          ObfuscatedTextFormField(
            decoration: const InputDecoration(hintText: 'Senha'),
            onChanged: (value) => loginForm.dispatch(Password(value)),
            onFieldSubmitted: (value) => _login(
              context,
              ref,
              formKey.value.currentState!,
              loginForm.state,
            ),
            validator: (value) => switch (Password.validate(value)) {
              PasswordError.empty => 'Informe uma senha',
              _ => null,
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (context) => const PasswordRecoveryDialog(),
                ),
                child: const Text('Esqueci minha senha'),
              ),
              ButtonProgressIndicator(
                isLoading: ref.watch(loginControllerProvider).isLoading,
                onPressed: () => _login(
                  context,
                  ref,
                  formKey.value.currentState!,
                  loginForm.state,
                ),
                child: const Text('Entrar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _login(
    BuildContext context,
    WidgetRef ref,
    FormState form,
    LoginDTO data,
  ) {
    if (!form.validate()) {
      return;
    }

    ref
        .read(loginControllerProvider.notifier) //
        .login(data)
        .then(
          (value) => ref.read(loginControllerProvider).asError == null
              ? context.go('/')
              : null,
        );
  }
}
