import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/books/data/repositories/book_repository.dart';
import 'package:reading/shared/presentation/pages/content/book_carrousel_content.dart';
import 'package:reading/shared/presentation/pages/content/greeting_content.dart';
import 'package:reading/shared/presentation/widgets/user_app_bar.dart';

class BookHomePage extends ConsumerStatefulWidget {
  const BookHomePage({super.key});

  @override
  ConsumerState<BookHomePage> createState() => _BookHomePageState();
}

class _BookHomePageState extends ConsumerState<BookHomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        AppBar(
          title: const UserAppBar(),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => RefreshIndicator(
              onRefresh: ref.read(myBooksProvider.notifier).refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: constraints.maxHeight,
                  child: ref.watch(myBooksProvider).maybeWhen(
                        skipLoadingOnReload: true,
                        data: (books) => books.data.isEmpty
                            ? const GreetingContent()
                            : const BookCarrouselContent(),
                        orElse: () => const SizedBox(),
                      ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
