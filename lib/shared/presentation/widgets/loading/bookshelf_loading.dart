import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reading/books/presentation/widgets/shelf.dart';
import 'package:reading/shared/presentation/widgets/loading/loading_placeholder.dart';

class BookshelfLoading extends StatelessWidget {
  const BookshelfLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 42),
        const LoadingPlaceholder(
          width: 180,
          height: 26,
        ),
        const SizedBox(height: 8),
        const LoadingPlaceholder(
          width: 220,
          height: 16,
        ),
        const SizedBox(height: 24),
        const LoadingPlaceholder(
          width: 120,
          height: 50,
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            for (var row = 0; row < 3; row += 1)
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  const Shelf(),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var book = 0; book < 3; book += 1)
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: AspectRatio(
                              aspectRatio: 0.7,
                              child: LayoutBuilder(
                                builder: (context, constraints) =>
                                    LoadingPlaceholder(
                                  width: constraints.minWidth,
                                  height: constraints.minHeight,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
