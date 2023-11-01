import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/profile/data/cached/profile.dart';
import 'package:reading/shared/presentation/hooks/use_initials.dart';

class UserAppBar extends HookConsumerWidget {
  const UserAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider).requireValue!;
    final initials = useInitials(user);

    return Row(
      children: [
        CircleAvatar(
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
              style: DefaultTextStyle.of(context).style,
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
    );
  }
}
