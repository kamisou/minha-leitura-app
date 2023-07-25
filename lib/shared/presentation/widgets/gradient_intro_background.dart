import 'package:flutter/material.dart';

class GradientIntroBackground extends StatelessWidget {
  const GradientIntroBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0x4BFEC107),
                  Color(0x20FFEBAE),
                  Color(0x00FFFFFF),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
