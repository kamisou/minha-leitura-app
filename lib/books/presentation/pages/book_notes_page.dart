import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/data/dtos/new_note_dto.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:reading/books/presentation/controllers/new_note_controller.dart';
import 'package:reading/books/presentation/dialogs/new_note_dialog.dart';
import 'package:reading/books/presentation/dialogs/view_note_dialog.dart';
import 'package:reading/books/presentation/widgets/book_notes_tile.dart';
import 'package:reading/shared/presentation/hooks/use_snackbar_error_listener.dart';
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
    useSnackbarErrorListener(
      ref,
      provider: newNoteControllerProvider,
      messageBuilder: (error) => 'Não foi possível salvar a nota.',
    );

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ListView.separated(
          itemCount: notes.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => showModalBottomSheet<void>(
              context: context,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              isScrollControlled: true,
              shape: const Border(),
              builder: (context) => const ViewNoteDialog(),
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
            onPressed: () => showModalBottomSheet<NewNoteDTO?>(
              backgroundColor: Theme.of(context).colorScheme.background,
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              builder: (context) => const NewNoteDialog(),
            ).then(
              (value) => value != null
                  ? ref
                      .read(newNoteControllerProvider.notifier)
                      .addNote(bookId, value)
                  : null,
            ),
            icon: const Icon(UniconsLine.edit),
            label: const Text('Adicionar anotação'),
          ),
        ),
      ],
    );
  }
}
