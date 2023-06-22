import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../authentication/data/repositories/auth_repository.dart';
import '../../data/repositories/book_repository.dart';
import '../../../shared/presentation/widgets/user_app_bar.dart';
import 'content/book_carrousel_content.dart';
import 'content/greeting_content.dart';

class BookHomePage extends ConsumerWidget {
  const BookHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        AppBar(
          title: UserAppBar(
            user: ref.watch(authRepositoryProvider).requireValue!,
          ),
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
