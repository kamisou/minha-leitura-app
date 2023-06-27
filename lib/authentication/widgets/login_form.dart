import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/authentication/data/dto/login_dto.dart';
import 'package:reading/authentication/domain/value_objects/email.dart';
import 'package:reading/authentication/domain/value_objects/password.dart';
import 'package:reading/authentication/presentation/controllers/login_controller.dart';
import 'package:reading/authentication/presentation/hooks/use_login_form_reducer.dart';
import 'package:reading/shared/presentation/widgets/obsfuscated_text_form_field.dart';

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

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
              // TODO(kamisou): adicionar botão para voltar para tela de intro
              const Icon(Icons.chevron_left),
              Text(
                // TODO(kamisou): criar conta
                'Criar conta',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Minha conta',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Preencha seus dados para entrar',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextFormField(
            decoration: const InputDecoration(hintText: 'E-mail'),
            onChanged: (value) => loginForm.dispatch(Email(value)),
            textInputAction: TextInputAction.next,
            validator: (value) => switch (Email.validate(value)) {
              EmailError() => 'Informe um endereço de e-mail',
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
              PasswordError() => 'Informe uma senha',
              _ => null,
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // TODO(kamisou): recuperar senha
                'Esqueci minha senha',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (!ref.watch(loginControllerProvider).isLoading)
                FilledButton(
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
        .read(loginControllerProvider.notifier)
        .login(data)
        .then((value) => context.go('/'));
  }
}
