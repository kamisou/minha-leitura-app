import 'package:flutter/material.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:reading/books/presentation/widgets/book_notes_tile.dart';
import 'package:reading/common/extensions/color_extension.dart';
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
              builder: (context) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      'Nova nota',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            color: Theme.of(context).colorExtension?.gray[800],
                          ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'título'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'nota...'),
                      maxLines: 6,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text('Cancelar'),
                        ),
                        FilledButton(
                          onPressed: () {},
                          child: const Text('Salvar'),
                        ),
                      ],
                    )
                  ],
                ),
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
