import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/profile/data/repositories/profile_repository.dart';
import 'package:reading/shared/presentation/hooks/use_initials.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class UserAppBar extends HookConsumerWidget {
  const UserAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider);
    final initials = useInitials(user);

    return Row(
      children: [
        CircleAvatar(
          foregroundImage: user.avatar != null
              ? NetworkImage(
                  user.avatar!,
                )
              : null,
          child: Text(
            initials,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: 'Olá, ',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorExtension?.gray[800],
                  ),
              children: [
                TextSpan(
                  text: user.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
