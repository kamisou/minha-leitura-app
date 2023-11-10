import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/data/cached/book_notes.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:reading/books/presentation/controllers/new_note_controller.dart';
import 'package:reading/books/presentation/dialogs/note_edit_dialog.dart';
import 'package:reading/books/presentation/widgets/book_notes_tile.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
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
    useAutomaticKeepAlive();

    useControllerListener(
      ref,
      controller: newNoteControllerProvider,
      onError: (error) => switch (error) {
        BadResponseRestException(message: final message) => message,
        OnlineOnlyOperationException() => 'Você precisa conectar-se à internet',
        _ => null,
      },
    );

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        RefreshIndicator(
          onRefresh: () => ref.refresh(bookNotesProvider(bookId).future),
          child: notes.isEmpty
              ? SingleChildScrollView(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Nenhuma nota',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorExtension?.gray[500],
                          ),
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: notes.length,
                  itemBuilder: (context, index) => BookNotesTile(
                    bookId: bookId,
                    note: notes[index],
                  ),
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) => const Divider(),
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FilledButton.icon(
            onPressed: () => showModalBottomSheet<void>(
              backgroundColor: Theme.of(context).colorScheme.background,
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              builder: (context) => NoteEditDialog(
                title: 'Nova nota',
                callback: (controller) =>
                    (data) => controller.addNote(bookId, data),
              ),
            ),
            icon: const Icon(UniconsLine.edit),
            label: const Text('Adicionar anotação'),
          ),
        ),
      ],
    );
  }
}
