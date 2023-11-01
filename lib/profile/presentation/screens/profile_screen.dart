import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/authentication/domain/value_objects/password.dart';
import 'package:reading/authentication/presentation/dialogs/delete_account_confirmation_dialog.dart';
import 'package:reading/profile/data/dtos/password_change_dto.dart';
import 'package:reading/profile/data/dtos/profile_change_dto.dart';
import 'package:reading/profile/data/repositories/profile_repository.dart';
import 'package:reading/profile/domain/value_objects/email.dart';
import 'package:reading/profile/domain/value_objects/name.dart';
import 'package:reading/profile/presentation/controllers/profile_controller.dart';
import 'package:reading/profile/presentation/dialogs/change_password_dialog.dart';
import 'package:reading/profile/presentation/hooks/use_profile_form_reducer.dart';
import 'package:reading/profile/presentation/widgets/profile_picture.dart';
import 'package:reading/shared/exceptions/rest_exception.dart';
import 'package:reading/shared/infrastructure/image_picker.dart';
import 'package:reading/shared/presentation/hooks/use_controller_listener.dart';
import 'package:reading/shared/presentation/widgets/button_progress_indicator.dart';
import 'package:reading/shared/presentation/widgets/obsfuscated_text_form_field.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider).requireValue!;
    final formKey = useRef(GlobalKey<FormState>());
    final profileForm = useProfileFormReducer(
      initialState: ProfileChangeDTO(
        email: Email(user.email),
        name: Name(user.name),
      ),
    );
    final changed = useMemoized(
      () =>
          user.email != profileForm.state.email?.value ||
          user.name != profileForm.state.name?.value,
      [user.email, user.name, profileForm.state],
    );
    final isValid = useMemoized(
      () {
        final form = profileForm.state;
        return changed &&
            (form.password?.value.isNotEmpty ?? false) &&
            (form.name?.value.isNotEmpty ?? false) &&
            (form.email?.value.isNotEmpty ?? false);
      },
      [changed, profileForm.state],
    );

    useControllerListener(
      ref,
      controller: profileControllerProvider,
      onError: (error) => switch (error) {
        BadResponseRestException(message: final message) => message,
        _ => 'Ocorreu um erro ao salvar as alterações do perfil',
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

    return Scaffold(
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
                  Center(
                    child: GestureDetector(
                      onTap: () => _changeAvatar(ref),
                      child: const ProfilePicture(radius: 55),
                    ),
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
                  if (changed)
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
                  // const SizedBox(height: 18),
                  // TextFormField(
                  //   initialValue: user.phone,
                  //   onChanged: (value) => profileForm.dispatch(Phone(value)),
                  //   validator: (value) => switch (Phone.validate(value)) {
                  //     PhoneError.invalid => 'Informe um telefone válido',
                  //     _ => null,
                  //   },
                  // ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => showDialog<PasswordChangeDTO?>(
                        context: context,
                        builder: (context) => const ChangePasswordDialog(),
                      ).then(
                        (value) => value != null
                            ? ref
                                .read(profileControllerProvider.notifier)
                                .savePassword(value)
                            : null,
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
                  onPressed: isValid
                      ? () => _save(
                            context,
                            ref,
                            formKey.value.currentState!,
                            profileForm.state,
                          )
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

  Future<void> _changeAvatar(WidgetRef ref) async {
    final avatar = await ref.read(imagePickerProvider).pickImage();

    if (avatar == null) {
      return;
    }

    return ref.read(profileControllerProvider.notifier).saveAvatar(avatar);
  }

  void _save(
    BuildContext context,
    WidgetRef ref,
    FormState form,
    ProfileChangeDTO data,
  ) {
    if (!form.validate()) {
      return;
    }

    ref.read(profileControllerProvider.notifier).save(data);
  }
}
