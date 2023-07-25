import 'package:flutter/material.dart';

class LoadingNetworkImage extends StatelessWidget {
  const LoadingNetworkImage({
    super.key,
    required this.src,
    required this.builder,
    this.fit = BoxFit.cover,
  });

  final String src;

  final Widget Function(Widget image) builder;

  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      src,
      fit: fit,
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
