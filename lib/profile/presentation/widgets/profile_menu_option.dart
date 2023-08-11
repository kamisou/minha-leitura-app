import 'package:flutter/material.dart';

class ProfileMenuOption extends StatelessWidget {
  const ProfileMenuOption({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.style,
  });

  final IconData icon;

  final String label;

  final void Function()? onTap;

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: style ??
                  Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
