import 'package:flutter/material.dart' hide Title;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/books/domain/value_objects/description.dart';
import 'package:reading/books/domain/value_objects/title.dart';
import 'package:reading/books/presentation/hooks/use_book_note_form_reducer.dart';
import 'package:reading/common/extensions/theme_extension.dart';

class NewNoteDialog extends HookWidget {
  const NewNoteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final bookNoteForm = useBookNoteFormReducer();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Nova nota',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorExtension?.gray[800],
                ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(hintText: 'título'),
            onChanged: (value) => bookNoteForm.dispatch(Title(value)),
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(hintText: 'nota...'),
            maxLines: 4,
            onChanged: (value) => bookNoteForm.dispatch(Description(value)),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: context.pop,
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: () => context.pop(bookNoteForm.state),
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
