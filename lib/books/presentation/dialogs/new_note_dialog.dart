import 'package:flutter/material.dart' hide Title;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/books/data/dtos/new_note_dto.dart';
import 'package:reading/books/domain/value_objects/description.dart';
import 'package:reading/books/domain/value_objects/title.dart';
import 'package:reading/books/presentation/hooks/use_book_note_form_reducer.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class NewNoteDialog extends HookWidget {
  const NewNoteDialog({
    super.key,
    this.note,
  });

  final NewNoteDTO? note;

  @override
  Widget build(BuildContext context) {
    final bookNoteForm = useBookNoteFormReducer(note);

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
            initialValue: note?.title.value,
            onChanged: (value) => bookNoteForm.dispatch(Title(value)),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(hintText: 'nota...'),
            initialValue: note?.description.value,
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
