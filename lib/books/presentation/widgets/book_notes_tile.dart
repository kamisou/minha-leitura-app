import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:reading/books/presentation/dialogs/view_note_dialog.dart';
import 'package:reading/books/presentation/widgets/author_timestamp.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class BookNotesTile extends HookWidget {
  const BookNotesTile({
    super.key,
    required this.bookId,
    required this.note,
    this.response = false,
  });

  final int bookId;

  final BookNote note;

  final bool response;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: response ? null : HitTestBehavior.deferToChild,
      onTap: () => showModalBottomSheet<void>(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        isScrollControlled: true,
        shape: const Border(),
        builder: (context) => ViewNoteDialog(
          bookId: bookId,
          note: note,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
              if (!response)
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
          const SizedBox(height: 8),
          AuthorTimestamp(
            author: note.user.name,
            timestamp: note.createdAt,
          ),
          if (!response && note.replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 20,
              ),
              child: Column(
                children: [
                  ...note.replies.map(
                    (e) => BookNotesTile(
                      bookId: bookId,
                      note: e,
                      response: true,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
