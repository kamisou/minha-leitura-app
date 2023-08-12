import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/profile/data/repositories/profile_repository.dart';
import 'package:reading/shared/presentation/hooks/use_initials.dart';

class ProfilePicture extends HookConsumerWidget {
  const ProfilePicture({
    super.key,
    required this.radius,
  });

  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider).requireValue!;
    final initials = useInitials(user);

    return DecoratedBox(
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
        radius: radius,
        child: Text(
          initials,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
