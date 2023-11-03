import 'package:flutter/widgets.dart';
import 'package:reading/books/presentation/widgets/shelf.dart';
import 'package:reading/shared/presentation/widgets/loading/loading_placeholder.dart';

class BookshelfLoading extends StatelessWidget {
  const BookshelfLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                        width: MediaQuery.of(context).size.width,
                        child: const Center(
                          child: LoadingPlaceholder(
                            width: 230,
                            height: 328,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
