import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reading/shared/presentation/widgets/loading_network_image.dart';
import 'package:unicons/unicons.dart';

class BookCover extends StatelessWidget {
  const BookCover({
    super.key,
    this.url,
  }) : file = null;

  const BookCover.file({
    super.key,
    // ignore: tighten_type_of_initializing_formals
    required this.file,
  })  : url = null,
        assert(file != null, 'File cannot be null!');

  final String? url;

  final File? file;

  @override
  Widget build(BuildContext context) {
    const baseCoverWidth = 230;

    return AspectRatio(
      aspectRatio: 0.7,
      child: file == null
          ? LoadingNetworkImage(
              src: url,
              builder: (image) => LayoutBuilder(
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
              ),
            )
          : Image.file(
              file!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  alignment: Alignment.center,
                  color: Theme.of(context).disabledColor,
                  child: const Icon(UniconsThinline.image_v),
                );
              },
            ),
    );
  }
}
