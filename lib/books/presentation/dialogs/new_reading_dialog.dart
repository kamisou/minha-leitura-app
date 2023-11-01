import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/books/presentation/controllers/new_reading_controller.dart';
import 'package:reading/books/presentation/hooks/use_book_reading_form_reducer.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
import 'package:reading/shared/exceptions/rest_exception.dart';
import 'package:reading/shared/presentation/hooks/use_controller_listener.dart';
import 'package:reading/shared/presentation/widgets/simple_text_field.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class NewReadingDialog extends HookConsumerWidget {
  const NewReadingDialog({
    super.key,
    required this.book,
  });

  final BookDetails book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingForm = useBookReadingFormReducer();

    useControllerListener(
      ref,
      controller: newReadingControllerProvider,
      onError: (error) => switch (error) {
        BadResponseRestException(message: final message) => message,
        OnlineOnlyOperationException() => 'Você precisa conectar-se à internet',
        _ => null,
      },
      onSuccess: context.pop,
    );

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
            onChanged: (value) => readingForm.dispatch(Pages.fromString(value)),
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
                  onPressed: () => ref
                      .read(newReadingControllerProvider.notifier)
                      .updateReading(book.id, readingForm.state),
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
