import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/data/cached/books.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/books/presentation/widgets/bookshelf.dart';
import 'package:reading/shared/data/paginated_resource.dart';
import 'package:reading/shared/presentation/hooks/use_lazy_scroll_controller.dart';
import 'package:reading/shared/presentation/widgets/bookshelf_label.dart';
import 'package:reading/shared/util/theme_data_extension.dart';
import 'package:unicons/unicons.dart';

class BookshelfContent extends HookConsumerWidget {
  const BookshelfContent({
    super.key,
    required this.books,
  });

  final PaginatedResource<BookDetails> books;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useLazyScrollController(
      onEndOfScroll: ref.read(myBooksProvider.notifier).next,
    );

    return RefreshIndicator(
      onRefresh: () => ref.refresh(myBooksProvider.future),
      child: ListView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Text(
            'Sua Biblioteca',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
            textAlign: TextAlign.center,
          ),
          RichText(
            text: TextSpan(
              text: 'Total de ',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorExtension?.gray[600],
                  ),
              children: [
                TextSpan(
                  text: '${books.data.length} livros',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: ' cadastrados.'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 6,
            spacing: 12,
            children: [
              OutlinedButton.icon(
                onPressed: () => context.go('/book/new'),
                icon: const Icon(UniconsLine.plus),
                label: const Text('Adicionar'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Bookshelf(books: books.data),
          const SizedBox(height: 32),
          const BookshelfLabel(status: BookStatus.pending),
          const BookshelfLabel(status: BookStatus.reading),
          const BookshelfLabel(status: BookStatus.finished),
        ],
      ),
    );
  }
}
