import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/books/presentation/hooks/use_book_reading_form_reducer.dart';
import 'package:reading/shared/presentation/widgets/simple_text_field.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class NewReadingDialog extends HookWidget {
  const NewReadingDialog({
    super.key,
    required this.book,
  });

  final BookDetails book;

  @override
  Widget build(BuildContext context) {
    final readingForm = useBookReadingFormReducer();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Lançar Leitura',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorExtension?.gray[800],
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Informe o número da página que você parou',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorExtension?.gray[500],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SimpleTextField(
            hintText: '00',
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            keyboardType: TextInputType.number,
            onChanged: (value) => readingForm.dispatch(
              {'pages': Pages.fromString(value)},
            ),
            validator: (value) => switch (Pages.validate(value)) {
              PagesError.empty => 'Informe o número da página',
              PagesError.invalid ||
              PagesError.zero =>
                'Informe uma página válida',
              _ => null,
            },
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
                  onPressed: () => context.pop(readingForm.state),
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          ),
        ],
      ),
    );
  }
}
