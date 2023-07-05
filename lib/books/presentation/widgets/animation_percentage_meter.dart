import 'package:flutter/material.dart';

class AnimatedPercentageMeter extends StatelessWidget {
  const AnimatedPercentageMeter({
    super.key,
    required this.percentage,
    required this.duration,
    this.curve = Curves.linear,
  });

  final double percentage;

  final Duration duration;

  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: ShapeDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(.2),
            shape: const StadiumBorder(),
          ),
          width: 100,
          height: 6,
        ),
        AnimatedPositioned(
          duration: duration,
          curve: curve,
          left: 0,
          width: percentage,
          height: 6,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: const StadiumBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
