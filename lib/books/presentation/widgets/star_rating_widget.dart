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
    final full = _value.floor();
    final empty = widget.stars - full - 1;

    return Row(
      children: [
        for (int i = 0; i < full; i += 1)
          GestureDetector(
            onTap: () => _onChanged(() => _value = i.toDouble()),
            child: Icon(
              UniconsSolid.star,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        if (_value != full)
          GestureDetector(
            onTap: () => _onChanged(() => _value.ceil()),
            child: Icon(
              _value - full == 0
                  ? UniconsLine.star
                  : UniconsSolid.star_half_alt,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        for (int i = 0; i < empty; i += 1)
          GestureDetector(
            onTap: () => _onChanged(() => _value = (i + full).toDouble()),
            child: Icon(
              UniconsLine.star,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
      ],
    );
  }

  void _onChanged(void Function() set) {
    setState(set);
    widget.onChanged?.call(_value);
  }
}
