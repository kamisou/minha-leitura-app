import 'package:flutter/material.dart';
import 'package:reading/shared/presentation/widgets/loading/loading_placeholder.dart';

class BookCarrouselLoading extends StatelessWidget {
  const BookCarrouselLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 8),
        LoadingPlaceholder(
          width: 160,
          height: 28,
        ),
        SizedBox(height: 12),
        LoadingPlaceholder(
          width: 230,
          height: 12,
        ),
        Expanded(
          child: Center(
            child: LoadingPlaceholder(
              width: 245,
              height: 356,
            ),
          ),
        ),
        LoadingPlaceholder(
          width: 100,
          height: 6,
        ),
        SizedBox(height: 16),
        LoadingPlaceholder(
          width: 220,
          height: 22,
        ),
        SizedBox(height: 12),
        LoadingPlaceholder(
          width: 140,
          height: 12,
        ),
        SizedBox(height: 64),
      ],
    );
  }
}
