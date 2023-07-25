import 'package:flutter/material.dart';

class ButtonProgressIndicator extends StatelessWidget {
  const ButtonProgressIndicator({
    super.key,
    required this.isLoading,
    required this.child,
    this.onPressed,
  });

  final bool isLoading;

  final Widget child;

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            alignment: Alignment.center,
            height: Theme.of(context)
                .filledButtonTheme
                .style
                ?.minimumSize
                ?.resolve({})?.height,
            child: const CircularProgressIndicator(),
          )
        : FilledButton(
            onPressed: onPressed,
            child: child,
          );
  }
}
