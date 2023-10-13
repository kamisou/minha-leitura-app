import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/data/repositories/book_repository.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/books/presentation/widgets/book_search_result.dart';
import 'package:reading/shared/presentation/hooks/use_lazy_scroll_controller.dart';

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
    final booksScrollController = useLazyScrollController(
      onEndOfScroll: ref
          .read(booksProvider(searchTerm: searchTerm).notifier) //
          .next,
    );

    return ref.watch(booksProvider(searchTerm: searchTerm)).maybeWhen(
          data: (books) => ListView.separated(
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
          ),
          orElse: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}
