import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../domain/models/user.dart';
import '../hooks/use_user_initials.dart';
import '../widgets/profile_menu_option.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: use real app user
    const user = User(name: 'João Marcos Kaminoski de Souza');

    final initials = useUserInitials(user);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 32,
        ),
        child: Column(
          children: [
            DecoratedBox(
              decoration: ShapeDecoration(
                shape: CircleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  ),
                ),
              ),
              child: CircleAvatar(
                foregroundImage: user.avatar != null
                    ? NetworkImage(
                        user.avatar!,
                      )
                    : null,
                radius: 36,
                child: Text(
                  initials,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: Column(
                children: [
                  ProfileMenuOption(
                    icon: UniconsLine.user_check,
                    label: 'Meus Dados',
                    // TODO: go to my data screen
                    onTap: () {},
                  ),
                  const Divider(),
                  ProfileMenuOption(
                    icon: UniconsLine.setting,
                    label: 'Ajustes',
                    // TODO: go to settings screen
                    onTap: () {},
                  ),
                ],
              ),
            ),
            ProfileMenuOption(
              icon: UniconsLine.exit,
              label: 'Sair',
              // TODO: go to login screen
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
