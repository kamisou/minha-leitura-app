import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/authentication/domain/value_objects/password.dart';
import 'package:reading/authentication/presentation/dialogs/delete_account_confirmation_dialog.dart';
import 'package:reading/debugging/presentation/widgets/debug_scaffold.dart';
import 'package:reading/profile/data/cached/profile.dart';
import 'package:reading/profile/data/dtos/profile_change_dto.dart';
import 'package:reading/profile/domain/value_objects/email.dart';
import 'package:reading/profile/domain/value_objects/name.dart';
import 'package:reading/profile/presentation/controllers/delete_profile_controller.dart';
import 'package:reading/profile/presentation/controllers/profile_controller.dart';
import 'package:reading/profile/presentation/controllers/profile_password_controller.dart';
import 'package:reading/profile/presentation/dialogs/change_password_dialog.dart';
import 'package:reading/profile/presentation/hooks/use_profile_form_reducer.dart';
import 'package:reading/profile/presentation/widgets/profile_picture.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
import 'package:reading/shared/exceptions/rest_exception.dart';
import 'package:reading/shared/presentation/hooks/use_controller_listener.dart';
import 'package:reading/shared/presentation/widgets/button_progress_indicator.dart';
import 'package:reading/shared/presentation/widgets/obsfuscated_text_form_field.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider).requireValue!;
    final formKey = useRef(GlobalKey<FormState>());
    final initialState = useRef(
      ProfileChangeDTO(
        email: Email(user.email),
        name: Name(user.name),
      ),
    );
    final profileForm = useProfileFormReducer(initialState: initialState.value);

    useControllerListener(
      ref,
      controller: profileControllerProvider,
      onError: (error) => switch (error) {
        BadResponseRestException(message: final message) => message,
        OnlineOnlyOperationException() => 'Você precisa conectar-se à internet',
        _ => null,
      },
      onSuccess: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('As alterações do perfil foram realizadas'),
          ),
        ),
      ),
    );

    useControllerListener(
      ref,
      controller: profilePasswordControllerProvider,
      onError: (error) => switch (error) {
        BadResponseRestException(message: final message) => message,
        OnlineOnlyOperationException() => 'Você precisa conectar-se à internet',
        _ => null,
      },
      onSuccess: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('A senha foi alterada com sucesso'),
          ),
        ),
      ),
    );

    useControllerListener(
      ref,
      controller: deleteProfileControllerProvider,
      onError: (error) => switch (error) {
        BadResponseRestException(message: final message) => message,
        OnlineOnlyOperationException() => 'Você precisa conectar-se à internet',
        _ => null,
      },
      onSuccess: () {
        context.go('/login');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('Sua conta foi removida com sucesso'),
            ),
          ),
        );
      },
    );

    return DebugScaffold(
      appBar: AppBar(
        title: const Text('Meus Dados'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Form(
              key: formKey.value,
              child: ListView(
                children: [
                  const Center(
                    child: ProfilePicture(radius: 55),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Nome de usuário',
                    ),
                    initialValue: user.name,
                    onChanged: (value) => profileForm.dispatch(Name(value)),
                    validator: (value) => switch (Name.validate(value)) {
                      NameError.invalid => 'Informe um nome completo',
                      _ => null,
                    },
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'E-mail',
                    ),
                    initialValue: user.email,
                    onChanged: (value) => profileForm.dispatch(Email(value)),
                    validator: (value) => switch (Email.validate(value)) {
                      EmailError.invalid =>
                        'Informe um endereço de e-mail válido',
                      _ => null,
                    },
                  ),
                  if (profileForm.state != initialState.value)
                    Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: ObfuscatedTextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Senha',
                        ),
                        onChanged: (value) =>
                            profileForm.dispatch(Password(value)),
                        validator: (value) =>
                            switch (Password.validate(value)) {
                          PasswordError.empty => 'Confirme sua senha',
                          _ => null,
                        },
                      ),
                    ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => showDialog<void>(
                        context: context,
                        builder: (context) => const ChangePasswordDialog(),
                      ),
                      child: const Text('Alterar senha'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () => showDialog<void>(
                        context: context,
                        builder: (context) =>
                            const DeleteAccountConfirmationDialog(),
                      ),
                      child: const Text('Excluir conta'),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              child: ButtonProgressIndicator(
                isLoading: ref.watch(profileControllerProvider).isLoading,
                child: FilledButton(
                  onPressed: profileForm.state != initialState.value &&
                          profileForm.state.validate()
                      ? () {
                          if (!formKey.value.currentState!.validate()) {
                            return;
                          }

                          ref
                              .read(profileControllerProvider.notifier)
                              .save(profileForm.state);
                        }
                      : null,
                  child: const Text('Salvar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
