import 'package:flutter/material.dart';
import 'package:reading/books/domain/models/book_rating.dart';
import 'package:reading/books/presentation/widgets/book_rating_tile.dart';

class BookRatingsPage extends StatelessWidget {
  const BookRatingsPage({
    super.key,
    required this.ratings,
  });

  final List<BookRating> ratings;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ratings.length,
      itemBuilder: (context, index) => BookRatingTile(
        rating: ratings[index],
      ),
      padding: EdgeInsets.zero,
    );
  }
}
