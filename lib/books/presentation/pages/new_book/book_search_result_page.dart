import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/data/cached/books.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/books/presentation/widgets/book_search_result.dart';
import 'package:reading/shared/presentation/hooks/use_asyncvalue_listener.dart';
import 'package:reading/shared/presentation/hooks/use_lazy_scroll_controller.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class BookSearchResultPage extends HookConsumerWidget {
  const BookSearchResultPage({
    super.key,
    required this.searchTerm,
    this.onTapBook,
  });

  final String searchTerm;

  final void Function(Book book)? onTapBook;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksResult = booksProvider(searchTerm: searchTerm);
    final booksScrollController = useLazyScrollController(
      onEndOfScroll: ref
          .read(booksProvider(searchTerm: searchTerm).notifier) //
          .next,
    );

    useAsyncValueListener(ref, booksResult);

    return ref.watch(booksResult).maybeWhen(
          data: (books) => books.data.isNotEmpty
              ? ListView.separated(
                  controller: booksScrollController,
                  itemCount: books.data.length,
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => onTapBook?.call(books.data[index]),
                    child: BookSearchResult(
                      book: books.data[index],
                    ),
                  ),
                  separatorBuilder: (context, index) => const Divider(),
                )
              : Align(
                  alignment: const Alignment(0, -0.95),
                  child: Text(
                    'Nenhum livro com o título inserido',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorExtension?.gray[500],
                        ),
                  ),
                ),
          orElse: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}
