import 'package:flutter/material.dart';
import 'package:reading/shared/presentation/widgets/loading_image.dart';

class BookCover extends StatelessWidget {
  const BookCover({
    super.key,
    required this.image,
  });

  final ImageProvider? image;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.7,
      child: LoadingImage(
        builder: _builder,
        imageProvider: image,
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
