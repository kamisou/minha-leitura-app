import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/authentication/data/repositories/auth_repository.dart';
import 'package:reading/profile/presentation/widgets/profile_picture.dart';

class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).requireValue!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Dados'),
        titleSpacing: 0,
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Center(
                child: GestureDetector(
                  // TODO(kamisou): alterar foto
                  onTap: () {},
                  child: const ProfilePicture(radius: 110),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(initialValue: user.name),
              const SizedBox(height: 18),
              TextFormField(initialValue: user.email),
              const SizedBox(height: 18),
              TextFormField(initialValue: user.phone),
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
          FilledButton(
            // TODO(kamisou) salvar alterações
            onPressed: () {},
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
