import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/books/data/repositories/book_repository.dart';
import 'package:reading/books/presentation/pages/content/book_carrousel_content.dart';
import 'package:reading/books/presentation/pages/content/greeting_content.dart';
import 'package:reading/common/presentation/widgets/user_app_bar.dart';

class BookHomePage extends ConsumerWidget {
  const BookHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        AppBar(
          title: const UserAppBar(),
        ),
        Expanded(
          child: ref.watch(myBooksProvider).maybeWhen(
                data: (books) => books.isEmpty
                    ? const GreetingContent()
                    : BookCarrouselContent(books: books),
                orElse: () => const SizedBox(),
              ),
        ),
      ],
    );
  }
}
