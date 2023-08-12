import 'package:flutter/material.dart';
import 'package:reading/shared/util/color_extension.dart';

class SelectionButton extends StatelessWidget {
  const SelectionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.selected = false,
  });

  final String text;

  final void Function()? onPressed;

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      statesController: MaterialStatesController({
        if (selected) MaterialState.selected,
      }),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? Theme.of(context).colorScheme.primary.withLightness(0.96)
              : Theme.of(context).colorScheme.background,
        ),
        elevation: const MaterialStatePropertyAll(5),
        shadowColor: const MaterialStatePropertyAll(Color(0x50000000)),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        side: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? BorderSide(color: Theme.of(context).colorScheme.primary)
              : BorderSide.none,
        ),
      ),
      child: Text(text),
    );
  }
}
