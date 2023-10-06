import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/data/repositories/book_repository.dart';
import 'package:reading/books/presentation/widgets/bookshelf.dart';
import 'package:reading/shared/presentation/hooks/use_lazy_scroll_controller.dart';
import 'package:reading/shared/presentation/widgets/user_app_bar.dart';
import 'package:reading/shared/util/theme_data_extension.dart';
import 'package:unicons/unicons.dart';

class BookshelfPage extends HookConsumerWidget {
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
                data: (books) {
                  final controller = useLazyScrollController(
                    finished: books.finished,
                    onEndOfScroll: ref.read(myBooksProvider.notifier).next,
                  );

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ListView(
                      controller: controller,
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
                                  color: Theme.of(context)
                                      .colorExtension
                                      ?.gray[600],
                                ),
                            children: [
                              TextSpan(
                                text: '${books.data.length} livros',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700),
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
                            // OutlinedButton.icon(
                            //   onPressed: () {
                            //     // TODO: implement search books
                            //     throw UnimplementedError();
                            //   },
                            //   icon: const Icon(UniconsLine.search),
                            //   label: const Text('Buscar'),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Bookshelf(
                          books: books.data,
                          booksPerRow: 3,
                        ),
                      ],
                    ),
                  );
                },
                orElse: () => const SizedBox(),
              ),
        ),
      ],
    );
  }
}
