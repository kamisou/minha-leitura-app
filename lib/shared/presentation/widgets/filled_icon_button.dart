import 'package:flutter/material.dart';

class FilledIconButton extends StatelessWidget {
  const FilledIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size,
  });

  final IconData icon;

  final void Function()? onPressed;

  final double? size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
          Theme.of(context).colorScheme.primary,
        ),
      ),
      icon: Icon(
        icon,
        color: Theme.of(context).colorScheme.onPrimary,
        size: size,
      ),
    );
  }
}
