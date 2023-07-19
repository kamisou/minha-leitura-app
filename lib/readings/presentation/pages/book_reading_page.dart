import 'package:flutter/material.dart';
import 'package:reading/readings/domain/models/reading.dart';
import 'package:reading/readings/presentation/widgets/book_reading_tile.dart';

class BookReadingPage extends StatelessWidget {
  const BookReadingPage({
    super.key,
    required this.readings,
  });

  final List<Reading> readings;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: readings.length,
      itemBuilder: (context, index) => BookReadingTile(
        reading: readings[index],
      ),
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
