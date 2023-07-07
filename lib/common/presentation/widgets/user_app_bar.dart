import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/common/extensions/color_extension.dart';
import 'package:reading/common/presentation/hooks/use_user_initials.dart';
import 'package:reading/profile/domain/models/user.dart';

class UserAppBar extends HookWidget {
  const UserAppBar({
    super.key,
    required this.user,
    this.maxInitialLetters = 2,
  });

  final User user;

  final int maxInitialLetters;

  @override
  Widget build(BuildContext context) {
    final initials = useUserInitials(user);

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
