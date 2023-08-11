import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/authentication/presentation/controllers/login_controller.dart';
import 'package:reading/profile/presentation/widgets/profile_menu_option.dart';
import 'package:reading/profile/presentation/widgets/profile_picture.dart';
import 'package:unicons/unicons.dart';

class OptionsPage extends ConsumerWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  // ProfileMenuOption(
                  //   icon: UniconsLine.user_check,
                  //   label: 'Meus Dados',
                  //   onTap: () => context.go('/profile'),
                  // ),
                  // const Divider(),
                  // ProfileMenuOption(
                  //   icon: UniconsLine.medal,
                  //   label: 'Conquistas',
                  //   onTap: () {
                  //     // TODO: implement go to achievements
                  //     throw UnimplementedError();
                  //   },
                  // ),
                  // const Divider(),
                  ProfileMenuOption(
                    icon: UniconsLine.bell_school,
                    label: 'Suas Turmas',
                    onTap: () => context.go('/classes'),
                  ),
                  const Divider(),
                  // ProfileMenuOption(
                  //   icon: UniconsLine.setting,
                  //   label: 'Ajustes',
                  //   onTap: () {
                  //     // TODO: implement go to settings
                  //     throw UnimplementedError();
                  //   },
                  // ),
                ],
              ),
            ),
            ProfileMenuOption(
              icon: UniconsLine.exit,
              label: 'Sair',
              onTap: () {
                context.go('/login');
                ref.read(loginControllerProvider.notifier).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
