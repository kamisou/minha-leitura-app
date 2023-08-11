import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class LoadingNetworkImage extends StatelessWidget {
  const LoadingNetworkImage({
    super.key,
    required this.builder,
    this.src,
    this.fit = BoxFit.cover,
  });

  final String? src;

  final Widget Function(Widget image) builder;

  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      src ?? '',
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          alignment: Alignment.center,
          color: Theme.of(context).disabledColor,
          child: const Icon(UniconsThinline.image_v),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return builder(child);
        }

        return builder(
          ColoredBox(
            color: Theme.of(context).disabledColor,
          ),
        );
      },
    );
  }
}
