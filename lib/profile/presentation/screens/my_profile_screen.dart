import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/authentication/data/repositories/auth_repository.dart';
import 'package:reading/common/infrastructure/image_picker.dart';
import 'package:reading/common/presentation/hooks/use_snackbar_error_listener.dart';
import 'package:reading/common/presentation/widgets/button_progress_indicator.dart';
import 'package:reading/profile/data/dtos/profile_dto.dart';
import 'package:reading/profile/domain/value_objects/email.dart';
import 'package:reading/profile/domain/value_objects/name.dart';
import 'package:reading/profile/domain/value_objects/phone.dart';
import 'package:reading/profile/presentation/controllers/my_profile_controller.dart';
import 'package:reading/profile/presentation/hooks/use_profile_form_reducer.dart';
import 'package:reading/profile/presentation/widgets/profile_picture.dart';

class MyProfileScreen extends HookConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).requireValue!;
    final formKey = useRef(GlobalKey<FormState>());
    final profileForm = useProfileFormReducer(
      initialState: ProfileDTO(
        email: Email(user.email),
        name: Name(user.name),
        phone: Phone(user.phone),
      ),
    );

    useSnackbarErrorListener(
      ref,
      provider: myProfileControllerProvider,
      messageBuilder: (error) =>
          'Ocorreu um erro ao salvar as alterações do perfil.',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Dados'),
        titleSpacing: 0,
      ),
      body: Stack(
        children: [
          Form(
            key: formKey.value,
            child: ListView(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () => _changeAvatar(ref),
                    child: const ProfilePicture(radius: 110),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  initialValue: user.name,
                  onChanged: (value) => profileForm.dispatch(Name(value)),
                  validator: (value) => switch (Name.validate(value)) {
                    NameError.invalid => 'Informe um nome completo',
                    _ => null,
                  },
                ),
                const SizedBox(height: 18),
                TextFormField(
                  initialValue: user.email,
                  onChanged: (value) => profileForm.dispatch(Email(value)),
                  validator: (value) => switch (Email.validate(value)) {
                    EmailError.invalid =>
                      'Informe um endereço de e-mail válido',
                    _ => null,
                  },
                ),
                const SizedBox(height: 18),
                TextFormField(
                  initialValue: user.phone,
                  onChanged: (value) => profileForm.dispatch(Phone(value)),
                  validator: (value) => switch (Phone.validate(value)) {
                    PhoneError.invalid => 'Informe um telefone válido',
                    _ => null,
                  },
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    // TODO(kamisou): alterar senha
                    onPressed: () {},
                    child: const Text('Alterar senha'),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    // TODO(kamisou): excluir conta
                    onPressed: () {},
                    child: const Text('Excluir conta'),
                  ),
                ),
              ],
            ),
          ),
          ButtonProgressIndicator(
            onPressed: () => _save(
              ref,
              formKey.value.currentState!,
              profileForm.state,
            ),
            isLoading: ref.watch(myProfileControllerProvider).isLoading,
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _changeAvatar(WidgetRef ref) async {
    final avatar = await ref.read(imagePickerProvider).pickImage();

    if (avatar == null) {
      return;
    }

    return ref.read(myProfileControllerProvider.notifier).saveAvatar(avatar);
  }

  void _save(WidgetRef ref, FormState form, ProfileDTO data) {
    if (!form.validate()) {
      return;
    }

    ref.read(myProfileControllerProvider.notifier).save(data);
  }
}
