import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/authentication/presentation/controllers/email_recovery_controller.dart';
import 'package:reading/profile/domain/value_objects/email.dart';
import 'package:reading/shared/presentation/widgets/button_progress_indicator.dart';
import 'package:reading/shared/util/theme_data_extension.dart';
import 'package:reading/theme.dart';

class PasswordRecoveryDialog extends HookConsumerWidget {
  const PasswordRecoveryDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useRef(GlobalKey<FormState>());
    final email = useState(const Email());

    return Theme(
      data: ref.read(themeManagerProvider),
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 24,
            right: 24,
            bottom: 8,
            left: 24,
          ),
          child: Form(
            key: formKey.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Esqueceu sua senha?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorExtension?.gray[800],
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Insira seu endereço de e-mail associado com a sua conta e '
                  'enviaremos um link para recuperação da senha.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorExtension?.gray[600],
                      ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'E-mail'),
                  onChanged: (value) => email.value = Email(value),
                  validator: (value) => switch (Email.validate(value)) {
                    EmailError.empty => 'Insira um endereço de e-mail.',
                    EmailError.invalid =>
                      'Insira um endereço de e-mail válido.',
                    _ => null,
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ButtonProgressIndicator(
                      isLoading:
                          ref.watch(emailRecoveryControllerProvider).isLoading,
                      child: TextButton(
                        onPressed: () {
                          if (!formKey.value.currentState!.validate()) {
                            return;
                          }

                          ref
                              .read(emailRecoveryControllerProvider.notifier)
                              .recover(email.value);

                          context.pop();
                        },
                        child: const Text('Recuperar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
