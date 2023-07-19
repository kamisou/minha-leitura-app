import 'package:flutter/material.dart';
import 'package:reading/books/domain/models/note.dart';
import 'package:reading/books/presentation/dialogs/new_note_dialog.dart';
import 'package:reading/books/presentation/widgets/book_notes_tile.dart';
import 'package:unicons/unicons.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({
    super.key,
    required this.notes,
  });

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ListView.separated(
          itemCount: notes.length,
          itemBuilder: (context, index) => BookNotesTile(
            note: notes[index],
          ),
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) => const Divider(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FilledButton.icon(
            onPressed: () => showModalBottomSheet<void>(
              backgroundColor: Theme.of(context).colorScheme.background,
              context: context,
              showDragHandle: true,
              builder: (context) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: NewNoteDialog(),
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
