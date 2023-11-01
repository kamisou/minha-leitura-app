import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/shared/presentation/pages/book_home_page.dart';
import 'package:reading/shared/presentation/pages/bookshelf_page.dart';
import 'package:reading/shared/presentation/pages/options_page.dart';
import 'package:reading/shared/presentation/pages/ranking_page.dart';
import 'package:reading/shared/presentation/widgets/debug_settings_drawer.dart';
import 'package:reading/shared/presentation/widgets/navbar_home.dart';
import 'package:unicons/unicons.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(initialPage: 1);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                OptionsPage(),
                BookHomePage(),
                BookshelfPage(),
                RankingPage(),
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
        ],
      ),
      drawer: DebugSettingsDrawer.buildIfDebugMode(overrideDebugMode: true),
    );
  }
}
