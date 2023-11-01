import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/data/cached/books.dart';
import 'package:reading/shared/presentation/hooks/use_lazy_page_controller.dart';
import 'package:reading/shared/presentation/pages/content/book_carrousel_content.dart';
import 'package:reading/shared/presentation/pages/content/greeting_content.dart';
import 'package:reading/shared/presentation/widgets/loading/book_carrousel_loading.dart';
import 'package:reading/shared/presentation/widgets/user_app_bar.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class BookHomePage extends StatefulHookConsumerWidget {
  const BookHomePage({super.key});

  @override
  ConsumerState<BookHomePage> createState() => _BookHomePageState();
}

class _BookHomePageState extends ConsumerState<BookHomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final pageController = useLazyPageController(
      onEndOfScroll: ref.read(myBooksProvider.notifier).next,
      viewportFraction: 0.72,
    );

    return Column(
      children: [
        AppBar(
          automaticallyImplyLeading: false,
          title: const UserAppBar(),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => RefreshIndicator(
              onRefresh: () => _onRefresh(pageController),
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
                          data: (books) => books.data.isEmpty
                              ? const GreetingContent()
                              : BookCarrouselContent(
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

  Future<void> _onRefresh(PageController pageController) async {
    final theme = Theme.of(context);

    await ref.read(myBooksProvider.notifier).refresh();

    return pageController.animateToPage(
      0,
      duration: theme.animationExtension!.duration,
      curve: theme.animationExtension!.curve,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
