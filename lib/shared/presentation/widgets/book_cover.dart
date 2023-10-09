import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:reading/shared/presentation/widgets/loading_image.dart';

class BookCover extends StatelessWidget {
  const BookCover({
    super.key,
    required this.url,
  })  : file = null,
        bytes = null,
        type = BookCoverData.url;

  const BookCover.file({
    super.key,
    required this.file,
  })  : url = null,
        bytes = null,
        type = BookCoverData.file;

  const BookCover.raw({
    super.key,
    required this.bytes,
  })  : file = null,
        url = null,
        type = BookCoverData.bytes;

  final BookCoverData type;

  final String? url;

  final File? file;

  final Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.7,
      child: file == null
          ? bytes == null
              ? LoadingImage.url(
                  src: url!,
                  builder: _builder,
                )
              : LoadingImage.raw(
                  builder: _builder,
                  bytes: bytes!,
                )
          : bytes == null
              ? LoadingImage.file(
                  file: file!,
                  builder: _builder,
                )
              : LoadingImage.raw(
                  builder: _builder,
                  bytes: bytes!,
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

enum BookCoverData { bytes, file, url }
