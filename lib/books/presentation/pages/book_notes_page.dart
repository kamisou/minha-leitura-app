import 'package:flutter/material.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:reading/books/presentation/widgets/book_notes_tile.dart';
import 'package:unicons/unicons.dart';

class BookNotesPage extends StatelessWidget {
  const BookNotesPage({
    super.key,
    required this.notes,
  });

  final List<BookNote> notes;

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
          separatorBuilder: (context, index) => const Divider(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FilledButton.icon(
            onPressed: () {},
            icon: const Icon(UniconsLine.edit),
            label: const Text('Adicionar anotação'),
          ),
        ),
      ],
    );
  }
}
