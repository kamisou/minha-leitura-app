import 'package:flutter/material.dart';
import 'package:reading/common/presentation/widgets/loading_network_image.dart';

class BookCover extends StatelessWidget {
  const BookCover({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.7,
      child: LoadingNetworkImage(
        src: url,
        builder: (image) => Container(
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: image,
        ),
      ),
    );
  }
}
