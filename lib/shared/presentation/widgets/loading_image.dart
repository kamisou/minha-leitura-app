import 'dart:io';
import 'dart:typed_data';

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

  LoadingImage.url({
    super.key,
    required this.builder,
    required String? src,
    this.fit = BoxFit.cover,
  }) : imageProvider = NetworkImage(src ?? '');

  LoadingImage.file({
    super.key,
    required this.builder,
    required File file,
    this.fit = BoxFit.cover,
  }) : imageProvider = FileImage(file);

  LoadingImage.raw({
    super.key,
    required this.builder,
    required Uint8List bytes,
    this.fit = BoxFit.cover,
  }) : imageProvider = MemoryImage(bytes);

  final ImageProvider imageProvider;

  final Widget Function(Widget image) builder;

  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: imageProvider,
      fit: fit,
      errorBuilder: _errorBuilder,
      loadingBuilder: _loadingBuilder,
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
