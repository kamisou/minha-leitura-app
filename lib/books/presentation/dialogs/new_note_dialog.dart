import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/common/extensions/color_extension.dart';

class NewNoteDialog extends StatelessWidget {
  const NewNoteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
              onPressed: context.pop,
              child: const Text('Cancelar'),
            ),
            FilledButton(
              // TODO(kamisou): salvar nota
              onPressed: () {},
              child: const Text('Salvar'),
            ),
          ],
        ),
      ],
    );
  }
}
