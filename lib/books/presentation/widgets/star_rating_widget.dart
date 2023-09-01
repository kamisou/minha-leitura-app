import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class StarRatingWidget extends StatefulWidget {
  const StarRatingWidget({
    super.key,
    this.value,
    this.onChanged,
    this.stars = 5,
    this.enabled = false,
  }) : assert(
          value == null || value <= stars,
          'The rating cannot be bigger than the number of stars!',
        );

  final double? value;

  final void Function(double value)? onChanged;

  final double stars;

  final bool enabled;

  @override
  State<StarRatingWidget> createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < widget.stars; i += 1)
          GestureDetector(
            onTapDown: (details) => setState(() {
              print(details.localPosition);
              setState(() => _value = i + 1);
              widget.onChanged?.call(_value);
            }),
            child: Icon(
              i <= _value.ceil()
                  ? i == _value
                      ? UniconsSolid.star
                      : UniconsSolid.star_half_alt
                  : UniconsLine.star,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
      ],
    );
  }
}
