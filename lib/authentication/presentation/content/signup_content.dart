import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/authentication/data/dtos/signup_dto.dart';
import 'package:reading/authentication/domain/value_objects/email.dart';
import 'package:reading/authentication/domain/value_objects/name.dart';
import 'package:reading/authentication/domain/value_objects/password.dart';
import 'package:reading/authentication/presentation/controllers/login_controller.dart';
import 'package:reading/authentication/presentation/controllers/signup_controller.dart';
import 'package:reading/authentication/presentation/hooks/use_signup_form_reducer.dart';
import 'package:reading/common/presentation/hooks/use_snackbar_error_listener.dart';
import 'package:reading/common/presentation/widgets/button_progress_indicator.dart';
import 'package:reading/common/presentation/widgets/obsfuscated_text_form_field.dart';

class SignupContent extends HookConsumerWidget {
  const SignupContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useRef(GlobalKey<FormState>());
    final signupForm = useSignupFormReducer();

    useSnackbarErrorListener(
      ref,
      provider: signupControllerProvider,
      messageBuilder: (error) =>
          'Ocorreu um erro ao fazer cadastro. Tente novamente.',
    );

    return Form(
      key: formKey.value,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => context.go(
                  '/login',
                  extra: signupForm.state.email.value,
                ),
                child: const Text('Entrar'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Meu cadastro',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Preencha seus dados para cadastrar',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextFormField(
            decoration: const InputDecoration(hintText: 'Nome completo'),
            onChanged: (value) => signupForm.dispatch(Name(value)),
            textInputAction: TextInputAction.next,
            validator: (value) => switch (Name.validate(value)) {
              NameError.empty => 'Informe um nome',
              NameError.invalid => 'Informe o nome completo',
              _ => null,
            },
          ),
          const SizedBox(height: 24),
          TextFormField(
            decoration: const InputDecoration(hintText: 'E-mail'),
            onChanged: (value) => signupForm.dispatch(Email(value)),
            textInputAction: TextInputAction.next,
            validator: (value) => switch (Email.validate(value)) {
              EmailError() => 'Informe um endereço de e-mail',
              _ => null,
            },
          ),
          const SizedBox(height: 24),
          ObfuscatedTextFormField(
            decoration: const InputDecoration(hintText: 'Senha'),
            onChanged: (value) => signupForm.dispatch(Password(value)),
            validator: (value) => switch (Password.validate(value)) {
              PasswordError() => 'Informe uma senha',
              _ => null,
            },
          ),
          const SizedBox(height: 24),
          ObfuscatedTextFormField(
            decoration: const InputDecoration(hintText: 'Confirme a senha'),
            onChanged: (value) => signupForm.dispatch(PasswordConfirm(value)),
            onFieldSubmitted: (value) => _signup(
              context,
              ref,
              formKey.value.currentState!,
              signupForm.state,
            ),
            validator: (value) => switch (PasswordConfirm.validate(
              value,
              signupForm.state.password.value,
            )) {
              PasswordError.noMatch => 'As senhas não coincidem',
              _ => null,
            },
          ),
          const SizedBox(height: 24),
          ButtonProgressIndicator(
            isLoading: ref.watch(loginControllerProvider).isLoading,
            onPressed: () => _signup(
              context,
              ref,
              formKey.value.currentState!,
              signupForm.state,
            ),
            child: const Text('Cadastrar'),
          ),
        ],
      ),
    );
  }

  void _signup(
    BuildContext context,
    WidgetRef ref,
    FormState form,
    SignupDTO data,
  ) {
    if (!form.validate()) {
      return;
    }

    ref
        .read(signupControllerProvider.notifier)
        .signup(data)
        .then((value) => context.go('/'));
  }
}
