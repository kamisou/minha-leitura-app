import 'package:flutter/material.dart' hide Title;
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/data/dtos/new_note_dto.dart';
import 'package:reading/books/domain/value_objects/description.dart';
import 'package:reading/books/domain/value_objects/title.dart';
import 'package:reading/books/presentation/controllers/new_note_controller.dart';
import 'package:reading/books/presentation/hooks/use_book_note_form_reducer.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class NoteEditDialog extends HookConsumerWidget {
  const NoteEditDialog({
    super.key,
    required this.title,
    required this.callback,
    this.initialState,
  });

  final String title;

  final void Function(NewNoteDTO) Function(NewNoteController controller)
      callback;

  final NewNoteDTO? initialState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookNoteForm = useBookNoteFormReducer(initialState);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorExtension?.gray[800],
                ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(hintText: 'título'),
            initialValue: initialState?.title.value,
            onChanged: (value) => bookNoteForm.dispatch(Title(value)),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(hintText: 'nota...'),
            initialValue: initialState?.description.value,
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
                  onPressed: () {
                    callback(ref.read(newNoteControllerProvider.notifier))(
                      bookNoteForm.state,
                    );
                    context.pop();
                  },
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
