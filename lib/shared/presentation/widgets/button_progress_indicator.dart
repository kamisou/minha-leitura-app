import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ButtonProgressIndicator extends StatelessWidget {
  const ButtonProgressIndicator({
    super.key,
    required this.isLoading,
    required this.child,
  }) : assert(
          child is ButtonStyleButton || child is IconButton,
          'child is ButtonStyleButton || child is IconButton',
        );

  final bool isLoading;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final height = useMemoized(
      () => switch (child) {
        ButtonStyleButton(style: final style) =>
          style?.minimumSize?.resolve({})?.height,
        IconButton(iconSize: final iconSize) => iconSize,
        _ => 0.0,
      },
      [child],
    );

    return isLoading
        ? Container(
            alignment: Alignment.center,
            height: height,
            child: const CircularProgressIndicator(),
          )
        : child;
  }
}
