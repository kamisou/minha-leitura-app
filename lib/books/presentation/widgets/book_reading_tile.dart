import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:reading/books/domain/models/book_reading.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class BookReadingTile extends HookWidget {
  const BookReadingTile({
    super.key,
    required this.reading,
  });

  final BookReading reading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorExtension?.gray[150],
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              FeatherIcons.calendar,
              color: Theme.of(context).colorExtension?.gray[700],
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            reading is! OfflineBookReading
                ? DateFormat.yMd().add_jm().format(reading.createdAt)
                : 'Não sincronizado',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorExtension?.gray[600]),
          ),
        ),
        const SizedBox(width: 8),
        DecoratedBox(
          decoration: ShapeDecoration(
            color: Theme.of(context).colorExtension?.gray[150],
            shape: const StadiumBorder(),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: Text(
              '${reading.page} pág. lidas',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorExtension?.gray[600],
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
