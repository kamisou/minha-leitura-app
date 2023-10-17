import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class StarRatingWidget extends StatefulWidget {
  const StarRatingWidget({
    super.key,
    this.value,
    this.onChanged,
    this.enabled = false,
    this.iconSize = 28,
    this.stars = 5,
  }) : assert(
          value == null || value <= stars,
          'The rating cannot be bigger than the number of stars!',
        );

  final double? value;

  final void Function(double value)? onChanged;

  final bool enabled;

  final double iconSize;

  final double stars;

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
  void didUpdateWidget(covariant StarRatingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled) {
      _value = widget.value ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < widget.stars; i += 1)
          GestureDetector(
            onTap: widget.enabled
                ? () {
                    setState(() => _value = i + 1);
                    widget.onChanged?.call(_value);
                  }
                : null,
            child: Icon(
              i < _value
                  ? i < _value - 0.5
                      ? UniconsSolid.star
                      : UniconsSolid.star_half_alt
                  : UniconsLine.star,
              color: Theme.of(context).colorScheme.primary,
              size: widget.iconSize,
            ),
          ),
      ],
    );
  }
}
