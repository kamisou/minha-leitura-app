import 'package:flutter/material.dart';
import 'package:reading/shared/util/theme_data_extension.dart';
import 'package:unicons/unicons.dart';

class LoadingImage<T extends Object> extends StatelessWidget {
  const LoadingImage({
    super.key,
    required this.builder,
    required this.imageProvider,
    this.fit = BoxFit.cover,
  });

  final ImageProvider? imageProvider;

  final Widget Function(Widget image) builder;

  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return imageProvider == null
        ? _errorBuilder(context)
        : Image(
            image: imageProvider!,
            fit: fit,
            errorBuilder: (context, error, stackTrace) =>
                _errorBuilder(context),
            loadingBuilder: _loadingBuilder,
          );
  }

  Widget _errorBuilder(BuildContext context) {
    return builder(
      Container(
        alignment: Alignment.center,
        color: Theme.of(context).disabledColor,
        child: Icon(
          UniconsThinline.image_v,
          color: Theme.of(context).colorExtension?.gray[600],
        ),
      ),
    );
  }

  Widget _loadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    if (loadingProgress == null) {
      return builder(child);
    }

    return builder(
      ColoredBox(
        color: Theme.of(context).disabledColor,
      ),
    );
  }
}
