import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/common/presentation/widgets/book_cover.dart';

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({
    super.key,
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 4,
                      ),
                    ),
                  ),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: 5.5,
                      sigmaY: 5.5,
                    ),
                    child: Image.network(
                      book.coverArt,
                      fit: BoxFit.cover,
                      opacity: const AlwaysStoppedAnimation(0.6),
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () => context.go('/'),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                Icons.chevron_left,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: BookCover(url: book.coverArt),
                      ),
                      const Expanded(
                        flex: 2,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
