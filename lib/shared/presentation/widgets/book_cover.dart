import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reading/shared/presentation/widgets/loading_image.dart';

class BookCover extends StatelessWidget {
  const BookCover({
    super.key,
    required this.url,
  }) : file = null;

  const BookCover.file({
    super.key,
    required this.file,
  }) : url = null;

  final String? url;

  final File? file;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.7,
      child: file == null
          ? LoadingImage(
              src: url,
              builder: _builder,
            )
          : LoadingImage.file(
              file: file,
              builder: _builder,
            ),
    );
  }

  Widget _builder(Widget image) {
    const baseCoverWidth = 230;

    return LayoutBuilder(
      builder: (context, constraints) => Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              constraints.biggest.width / baseCoverWidth * 16,
            ),
          ),
        ),
        child: image,
      ),
    );
  }
}
