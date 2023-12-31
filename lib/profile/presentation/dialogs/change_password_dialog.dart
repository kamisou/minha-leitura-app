import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/authentication/domain/value_objects/password.dart';
import 'package:reading/profile/presentation/controllers/profile_password_controller.dart';
import 'package:reading/profile/presentation/hooks/use_password_form_reducer.dart';
import 'package:reading/shared/presentation/widgets/button_progress_indicator.dart';
import 'package:reading/shared/presentation/widgets/obsfuscated_text_form_field.dart';

class ChangePasswordDialog extends HookConsumerWidget {
  const ChangePasswordDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useRef(GlobalKey<FormState>());
    final passwordForm = usePasswordFormReducer();

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Alterar senha',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
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
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  ObfuscatedTextFormField(
                    decoration:
                        const InputDecoration(hintText: 'repetir senha'),
                    onChanged: (value) =>
                        passwordForm.dispatch(PasswordConfirm(value)),
                    textInputAction: TextInputAction.done,
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
                  child: ButtonProgressIndicator(
                    isLoading: ref
                        .watch(profilePasswordControllerProvider) //
                        .isLoading,
                    child: FilledButton(
                      onPressed: () {
                        if (!formKey.value.currentState!.validate()) {
                          return;
                        }

                        ref
                            .read(profilePasswordControllerProvider.notifier)
                            .savePassword(passwordForm.state);

                        context.pop();
                      },
                      child: const Text('Salvar'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
