import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:reading/books/presentation/controllers/new_note_controller.dart';
import 'package:reading/books/presentation/dialogs/note_edit_dialog.dart';
import 'package:reading/books/presentation/dialogs/view_note_dialog.dart';
import 'package:reading/books/presentation/widgets/book_notes_tile.dart';
import 'package:reading/shared/exceptions/rest_exception.dart';
import 'package:reading/shared/presentation/hooks/use_controller_listener.dart';
import 'package:reading/shared/util/theme_data_extension.dart';
import 'package:unicons/unicons.dart';

class BookNotesPage extends HookConsumerWidget {
  const BookNotesPage({
    super.key,
    required this.bookId,
    required this.notes,
  });

  final int bookId;

  final List<BookNote> notes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useControllerListener(
      ref,
      controller: newNoteControllerProvider,
      onError: (error) => switch (error) {
        BadResponseRestException(message: final message) => message,
        _ => null,
      },
    );

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if (notes.isEmpty)
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Nenhuma nota',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorExtension?.gray[500],
                  ),
            ),
          )
        else
          ListView.separated(
            itemCount: notes.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => showModalBottomSheet<void>(
                context: context,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                isScrollControlled: true,
                shape: const Border(),
                builder: (context) => ViewNoteDialog(note: notes[index]),
              ),
              child: BookNotesTile(
                note: notes[index],
              ),
            ),
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) => const Divider(),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FilledButton.icon(
            onPressed: () => _addNote(context, ref),
            icon: const Icon(UniconsLine.edit),
            label: const Text('Adicionar anotação'),
          ),
        ),
      ],
    );
  }

  void _addNote(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      backgroundColor: Theme.of(context).colorScheme.background,
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => NoteEditDialog(
        title: 'Nova nota',
        callback: (controller) => (data) => controller.addNote(bookId, data),
      ),
    );
  }
}
