import 'package:flutter/material.dart';

class ButtonProgressIndicator extends StatelessWidget {
  const ButtonProgressIndicator({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;

  final ButtonStyleButton child;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            alignment: Alignment.center,
            height: child.style?.minimumSize?.resolve({})?.height,
            child: const CircularProgressIndicator(),
          )
        : child;
  }
}
