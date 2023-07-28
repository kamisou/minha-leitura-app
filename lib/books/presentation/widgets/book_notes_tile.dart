import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:reading/shared/presentation/hooks/use_dd_mm_yy_h_m.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class BookNotesTile extends HookWidget {
  const BookNotesTile({
    super.key,
    required this.note,
    this.response = false,
  });

  final BookNote note;

  final bool response;

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
        DefaultTextStyle(
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Theme.of(context).colorExtension?.gray[400],
                fontWeight: FontWeight.w400,
              ),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  note.author.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                useddMMyyHm(note.createdAt),
              ),
            ],
          ),
        ),
        if (!response)
          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 20,
            ),
            child: Column(
              children: [
                ...note.responses.map(
                  (e) => BookNotesTile(
                    note: note,
                    response: true,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
