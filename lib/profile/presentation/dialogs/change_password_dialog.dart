import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/authentication/domain/value_objects/password.dart';
import 'package:reading/shared/presentation/widgets/obsfuscated_text_form_field.dart';
import 'package:reading/profile/presentation/hooks/use_password_form_reducer.dart';

class ChangePasswordDialog extends HookWidget {
  const ChangePasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useRef(GlobalKey<FormState>());
    final passwordForm = usePasswordFormReducer();

    return Dialog(
      child: Column(
        children: [
          const Text('Alterar senha'),
          const SizedBox(height: 16),
          Form(
            key: formKey.value,
            child: Column(
              children: [
                ObfuscatedTextFormField(
                  decoration: const InputDecoration(hintText: 'senha atual'),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) =>
                      passwordForm.dispatch({'old': Password(value)}),
                  validator: (value) => switch (Password.validate(value)) {
                    PasswordError.empty => 'Informe a senha',
                    _ => null,
                  },
                ),
                ObfuscatedTextFormField(
                  decoration: const InputDecoration(hintText: 'nova senha'),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) =>
                      passwordForm.dispatch({'new': Password(value)}),
                  validator: (value) => switch (Password.validate(value)) {
                    PasswordError.empty => 'Informe uma senha',
                    _ => null,
                  },
                ),
                ObfuscatedTextFormField(
                  decoration: const InputDecoration(hintText: 'repetir senha'),
                  onChanged: (value) =>
                      passwordForm.dispatch(PasswordConfirm(value)),
                  onFieldSubmitted: (value) => context.pop(passwordForm.state),
                  validator: (value) => switch (PasswordConfirm.validate(
                    value,
                    passwordForm.state.newPassword.value,
                  )) {
                    PasswordError.noMatch => 'As senhas não coincidem',
                    _ => null,
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: context.pop,
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: () => context.pop(passwordForm.state),
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
