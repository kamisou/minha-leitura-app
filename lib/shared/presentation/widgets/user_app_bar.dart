import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/profile/data/cached/profile.dart';
import 'package:reading/shared/presentation/hooks/use_initials.dart';

class UserAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  const UserAppBar({
    super.key,
    this.leading,
  });

  final Widget? leading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider).requireValue!;
    final initials = useInitials(user);

    return AppBar(
      automaticallyImplyLeading: false,
      leading: leading,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => context.go('/profile'),
            child: CircleAvatar(
              child: Text(
                initials,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: 'Olá, ',
                style: Theme.of(context).appBarTheme.titleTextStyle,
                children: [
                  TextSpan(
                    text: user.name,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
