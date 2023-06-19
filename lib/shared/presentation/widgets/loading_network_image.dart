import 'package:flutter/material.dart';

class LoadingNetworkImage extends StatelessWidget {
  const LoadingNetworkImage({
    super.key,
    required this.src,
    required this.builder,
  });

  final String src;

  final Widget Function(Widget image) builder;
  @override
  Widget build(BuildContext context) {
    return Image.network(
      src,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return builder(child);
        }

        final value = loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null;

        return CircularProgressIndicator(value: value);
      },
    );
  }
}
