import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/debugging/presentation/widgets/debug_scaffold.dart';
import 'package:reading/shared/presentation/pages/book_home_page.dart';
import 'package:reading/shared/presentation/pages/book_ranking_page.dart';
import 'package:reading/shared/presentation/pages/bookshelf_page.dart';
import 'package:reading/shared/presentation/pages/options_page.dart';
import 'package:reading/shared/presentation/pages/ranking_page.dart';
import 'package:reading/shared/presentation/widgets/navbar_home.dart';
import 'package:unicons/unicons.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController(initialPage: 1);

    return DebugScaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              children: const [
                OptionsPage(),
                BookHomePage(),
                BookshelfPage(),
                RankingPage(),
                BookRankingPage(),
              ],
            ),
          ),
          const SizedBox(height: 84),
        ],
      ),
      bottomSheet: NavBarHome(
        controller: pageController,
        icons: const [
          UniconsLine.bars,
          UniconsLine.home_alt,
          UniconsLine.book_alt,
          UniconsLine.medal,
          UniconsLine.book_reader,
        ],
      ),
    );
  }
}
