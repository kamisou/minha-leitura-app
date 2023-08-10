import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class StarRatingWidget extends StatelessWidget {
  const StarRatingWidget({
    super.key,
    required this.value,
    this.stars = 5,
  }) : assert(
          value <= stars,
          'The rating cannot be bigger than the number of stars!',
        );

  final double value;

  final double stars;

  @override
  Widget build(BuildContext context) {
    final full = value.floor();
    final empty = stars - full - 1;

    return Row(
      children: [
        for (int i = 0; i < full; i += 1)
          Icon(
            UniconsSolid.star,
            color: Theme.of(context).colorScheme.primary,
          ),
        if (value != full)
          Icon(
            value - full == 0 ? UniconsLine.star : UniconsSolid.star_half_alt,
            color: Theme.of(context).colorScheme.primary,
          ),
        for (int i = 0; i < empty; i += 1)
          Icon(
            UniconsLine.star,
            color: Theme.of(context).colorScheme.primary,
          ),
      ],
    );
  }
}
