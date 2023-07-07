import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:reading/common/extensions/color_extension.dart';
import 'package:reading/common/presentation/hooks/use_dmmyhm.dart';

class BookNotesTile extends HookWidget {
  const BookNotesTile({
    super.key,
    required this.note,
  });

  final BookNote note;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          note.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorExtension?.gray[800],
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                note.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorExtension?.gray[600],
                    ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          usedMMyHm(note.createdAt),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorExtension?.gray[400],
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }
}
