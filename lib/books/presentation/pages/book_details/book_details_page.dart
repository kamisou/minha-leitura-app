import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reading/books/data/cached/book_notes.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/books/presentation/controllers/new_reading_controller.dart';
import 'package:reading/books/presentation/dialogs/new_reading_dialog.dart';
import 'package:reading/books/presentation/widgets/book_details_tile.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
import 'package:reading/shared/exceptions/rest_exception.dart';
import 'package:reading/shared/presentation/hooks/use_controller_listener.dart';
import 'package:unicons/unicons.dart';

class BookDetailsPage extends HookConsumerWidget {
  const BookDetailsPage({
    super.key,
    required this.book,
  });

  final BookDetails book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useControllerListener(
      ref,
      controller: newReadingControllerProvider,
      onError: (error) => switch (error) {
        BadResponseRestException(message: final message) => message,
        OnlineOnlyOperationException() => 'Você precisa conectar-se à internet',
        _ => null,
      },
      onSuccess: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'A leitura foi salva com sucesso',
            ),
          ),
        ),
      ),
    );

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ListView(
          padding: EdgeInsets.zero,
          children: [
            BookDetailsTile(
              icon: UniconsLine.book_alt,
              label: 'Total de Páginas',
              value: '${book.book.pages}',
            ),
            const Divider(),
            BookDetailsTile(
              icon: UniconsLine.calendar_alt,
              label: 'Início',
              value: DateFormat.yMMMMd().format(book.startedAt),
            ),
            const Divider(),
            BookDetailsTile(
              icon: UniconsLine.file,
              label: 'Página Atual',
              value: '${book.actualPage}',
            ),
            const Divider(),
            BookDetailsTile(
              icon: UniconsLine.edit,
              label: 'Suas Anotações',
              value: ref.watch(bookNotesProvider(book.id)).maybeWhen(
                    data: (data) => '${data.length} nota(s)',
                    orElse: () => '0 nota(s)',
                  ),
            ),
            const SizedBox(height: 24),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FilledButton.icon(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              backgroundColor: Theme.of(context).colorScheme.background,
              isScrollControlled: true,
              showDragHandle: true,
              builder: (context) => NewReadingDialog(book: book),
            ),
            icon: const Icon(UniconsLine.bookmark),
            label: const Text('Lançar Leitura'),
          ),
        ),
      ],
    );
  }
}
