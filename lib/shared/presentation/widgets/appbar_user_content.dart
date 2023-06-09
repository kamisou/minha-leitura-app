import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppBarUserContent extends HookWidget {
  const AppBarUserContent({
    super.key,
    required this.userName,
    this.avatarUrl,
    this.maxInitialLetters = 2,
  });

  final String userName;

  final String? avatarUrl;

  final int maxInitialLetters;

  @override
  Widget build(BuildContext context) {
    final initials = useMemoized(
      () => userName.split(' ').take(maxInitialLetters).map((e) => e[0]).join(),
      [userName, maxInitialLetters],
    );

    return Row(
      children: [
        CircleAvatar(
          foregroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          child: Text(
            initials,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            text: 'Olá, ',
            style: Theme.of(context).textTheme.titleMedium,
            children: [
              TextSpan(
                text: userName,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
