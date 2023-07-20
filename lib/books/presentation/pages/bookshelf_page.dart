import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/books/data/repositories/book_repository.dart';
import 'package:reading/books/presentation/widgets/bookshelf.dart';
import 'package:reading/common/extensions/color_extension.dart';
import 'package:reading/common/presentation/widgets/user_app_bar.dart';
import 'package:unicons/unicons.dart';

class BookshelfPage extends ConsumerWidget {
  const BookshelfPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        AppBar(
          title: const UserAppBar(),
        ),
        Expanded(
          child: ref.watch(myBooksProvider).maybeWhen(
                data: (books) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Sua Biblioteca',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Total de ',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color:
                                    Theme.of(context).colorExtension?.gray[600],
                              ),
                          children: [
                            TextSpan(
                              text: '${books.length} livros',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
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
                            onPressed: () => context.go('/classes/join'),
                            icon: const Icon(UniconsLine.plus),
                            label: const Text('Ingressar turma'),
                          ),
                          OutlinedButton.icon(
                            // TODO(kamisou): buscar livro
                            onPressed: () {},
                            icon: const Icon(UniconsLine.search),
                            label: const Text('Buscar'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Bookshelf(
                          books: books,
                          booksPerRow: 3,
                        ),
                      ),
                    ],
                  ),
                ),
                orElse: () => const SizedBox(),
              ),
        ),
      ],
    );
  }
}