import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/profile/presentation/widgets/profile_menu_option.dart';
import 'package:reading/profile/presentation/widgets/profile_picture.dart';
import 'package:unicons/unicons.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        child: Column(
          children: [
            const ProfilePicture(radius: 36),
            const SizedBox(height: 50),
            Expanded(
              child: Column(
                children: [
                  ProfileMenuOption(
                    icon: UniconsLine.user_check,
                    label: 'Meus Dados',
                    onTap: () => context.go('/myProfile'),
                  ),
                  const Divider(),
                  ProfileMenuOption(
                    icon: UniconsLine.medal,
                    label: 'Conquistas',
                    onTap: () => context.go('/achievements'),
                  ),
                  const Divider(),
                  ProfileMenuOption(
                    icon: UniconsLine.bell_school,
                    label: 'Suas Turmas',
                    onTap: () => context.go('/classes'),
                  ),
                  const Divider(),
                  ProfileMenuOption(
                    icon: UniconsLine.setting,
                    label: 'Ajustes',
                    // TODO(kamisou): ir para tela de ajustes
                    onTap: () {},
                  ),
                ],
              ),
            ),
            ProfileMenuOption(
              icon: UniconsLine.exit,
              label: 'Sair',
              onTap: () => context.go('/login'),
            ),
          ],
        ),
      ),
    );
  }
}
