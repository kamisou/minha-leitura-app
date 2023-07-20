import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/books/presentation/controllers/new_reading_controller.dart';
import 'package:reading/books/presentation/dialogs/new_reading_dialog.dart';
import 'package:reading/books/presentation/widgets/book_details_tile.dart';
import 'package:reading/common/presentation/hooks/use_d_mmmm_y.dart';
import 'package:reading/common/presentation/hooks/use_snackbar_error_listener.dart';
import 'package:unicons/unicons.dart';

class BookDetailsPage extends HookConsumerWidget {
  const BookDetailsPage({
    super.key,
    required this.book,
  });

  final BookDetails book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expectedEnding = useMemoized(
      () => book.expectedEnding,
      [book.pageCount, book.dailyPageGoal],
    );
    final remainingDays = useMemoized(
      () => book.remainingDays,
      [expectedEnding, book.started],
    );

    useSnackbarErrorListener(
      ref,
      provider: newReadingControllerProvider,
      messageBuilder: (error) => 'Não foi possível lançar a leitura.',
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
              value: '${book.pageCount}',
            ),
            const Divider(),
            BookDetailsTile(
              icon: UniconsLine.calendar_alt,
              label: 'Início',
              value: usedMMMMy(book.started),
            ),
            const Divider(),
            BookDetailsTile(
              icon: UniconsLine.clock,
              label: 'Previsão de Término',
              value: usedMMMMy(expectedEnding),
            ),
            const Divider(),
            BookDetailsTile(
              icon: UniconsLine.file,
              label: 'Página Atual',
              value: '${book.currentPage}',
            ),
            const Divider(),
            BookDetailsTile(
              icon: Icons.flag_outlined,
              label: 'Sua Meta Diária',
              value: '${book.dailyPageGoal} página(s)',
            ),
            const Divider(),
            BookDetailsTile(
              icon: UniconsLine.edit,
              label: 'Suas Anotações',
              value: '${book.dailyPageGoal} nota(s)',
            ),
            const Divider(),
            BookDetailsTile(
              icon: UniconsLine.bookmark,
              label: 'Páginas Lidas',
              value: '${book.pagesRead} página(s)',
            ),
            const Divider(),
            BookDetailsTile(
              icon: UniconsLine.calendar_alt,
              label: 'Dias Restantes',
              value: '${remainingDays.inDays} dia(s)',
            ),
            const SizedBox(height: 24),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FilledButton.icon(
            onPressed: () => showModalBottomSheet<Pages?>(
              context: context,
              backgroundColor: Theme.of(context).colorScheme.background,
              isScrollControlled: true,
              showDragHandle: true,
              builder: (context) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: NewReadingDialog(),
              ),
            ).then(
              (value) => value != null
                  ? ref
                      .read(newReadingControllerProvider.notifier)
                      .addReading(book.id, value)
                  : null,
            ),
            icon: const Icon(UniconsLine.bookmark),
            label: const Text('Lançar Leitura'),
          ),
        ),
      ],
    );
  }
}
