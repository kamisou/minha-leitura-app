import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/data/cached/books.dart';
import 'package:reading/shared/presentation/pages/content/bookshelf_content.dart';
import 'package:reading/shared/presentation/widgets/loading/bookshelf_loading.dart';
import 'package:reading/shared/presentation/widgets/user_app_bar.dart';

class BookshelfPage extends HookConsumerWidget {
  const BookshelfPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const UserAppBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ref.watch(myBooksProvider).maybeWhen(
                  skipLoadingOnRefresh: false,
                  data: (books) => BookshelfContent(books: books),
                  orElse: () => const BookshelfLoading(),
                ),
          ),
        ),
      ],
    );
  }
}
