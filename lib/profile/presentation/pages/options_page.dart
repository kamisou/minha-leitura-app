import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/authentication/data/repositories/auth_repository.dart';
import 'package:reading/common/presentation/hooks/use_user_initials.dart';
import 'package:reading/profile/presentation/widgets/profile_menu_option.dart';
import 'package:unicons/unicons.dart';

class OptionsPage extends HookConsumerWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).requireValue!;
    final initials = useUserInitials(user);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
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
                    // TODO(kamisou): ir para tela de meus dados
                    onTap: () {},
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
