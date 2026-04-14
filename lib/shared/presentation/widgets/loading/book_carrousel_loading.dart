import 'package:flutter/material.dart';
import 'package:reading/shared/presentation/widgets/loading/loading_placeholder.dart';

class BookCarrouselLoading extends StatelessWidget {
  const BookCarrouselLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        const LoadingPlaceholder(
          width: 160,
          height: 28,
        ),
        const SizedBox(height: 12),
        const LoadingPlaceholder(
          width: 230,
          height: 12,
        ),
        Expanded(
          child: PageView.builder(
            controller: PageController(
              initialPage: 1,
              viewportFraction: 0.72,
            ),
            itemCount: 3,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => const Center(
              child: LoadingPlaceholder(
                width: 230,
                height: 328,
              ),
            ),
          ),
        ),
        const LoadingPlaceholder(
          width: 100,
          height: 6,
        ),
        const SizedBox(height: 16),
        const LoadingPlaceholder(
          width: 220,
          height: 22,
        ),
        const SizedBox(height: 12),
        const LoadingPlaceholder(
          width: 140,
          height: 12,
        ),
        const SizedBox(height: 64),
      ],
    );
  }
}
