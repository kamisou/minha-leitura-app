import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/data/cached/books.dart';
import 'package:reading/shared/presentation/hooks/use_asyncvalue_listener.dart';
import 'package:reading/shared/presentation/hooks/use_lazy_page_controller.dart';
import 'package:reading/shared/presentation/pages/content/book_carrousel_content.dart';
import 'package:reading/shared/presentation/widgets/loading/book_carrousel_loading.dart';
import 'package:reading/shared/presentation/widgets/user_app_bar.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class BookHomePage extends HookConsumerWidget {
  const BookHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = useLazyPageController(
      onEndOfScroll: ref.read(myBooksProvider.notifier).next,
      viewportFraction: 0.72,
    );

    useAutomaticKeepAlive();
    useAsyncValueListener(ref, myBooksProvider);

    return Column(
      children: [
        const UserAppBar(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => RefreshIndicator(
              onRefresh: () => _onRefresh(context, ref, pageController),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: constraints.maxHeight,
                  child: AnimatedSwitcher(
                    duration: Theme.of(context).animationExtension!.duration,
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: ref.watch(myBooksProvider).maybeWhen(
                          skipLoadingOnRefresh: false,
                          data: (books) => BookCarrouselContent(
                            books: books,
                            pageController: pageController,
                          ),
                          orElse: BookCarrouselLoading.new,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onRefresh(
    BuildContext context,
    WidgetRef ref,
    PageController pageController,
  ) async {
    final theme = Theme.of(context);

    await ref.read(myBooksProvider.notifier).refresh();

    if (pageController.hasClients) {
      await pageController.animateToPage(
        0,
        duration: theme.animationExtension!.duration,
        curve: theme.animationExtension!.curve,
      );
    }
  }
}
