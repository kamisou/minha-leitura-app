import 'package:flutter/material.dart';
import 'package:reading/shared/presentation/widgets/loading_network_image.dart';

class BookCover extends StatelessWidget {
  const BookCover({
    super.key,
    this.url,
  });

  final String? url;

  @override
  Widget build(BuildContext context) {
    const baseCoverWidth = 230;

    return AspectRatio(
      aspectRatio: 0.7,
      child: LoadingNetworkImage(
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
      ),
    );
  }
}
