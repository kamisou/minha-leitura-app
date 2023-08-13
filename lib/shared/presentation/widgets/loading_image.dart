import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reading/shared/util/theme_data_extension.dart';
import 'package:unicons/unicons.dart';

class LoadingImage extends StatelessWidget {
  const LoadingImage({
    super.key,
    required this.builder,
    required this.src,
    this.fit = BoxFit.cover,
  }) : file = null;

  const LoadingImage.file({
    super.key,
    required this.builder,
    required this.file,
    this.fit = BoxFit.cover,
  }) : src = null;

  final String? src;

  final File? file;

  final Widget Function(Widget image) builder;

  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return file == null
        ? Image.network(
            src ?? '',
            fit: fit,
            errorBuilder: _errorBuilder,
            loadingBuilder: _loadingBuilder,
          )
        : builder(
            Image.file(
              file!,
              fit: fit,
              errorBuilder: _errorBuilder,
            ),
          );
  }

  Widget _errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
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
