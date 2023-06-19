import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:unicons/unicons.dart';

import '../../../profile/presentation/pages/profile_page.dart';
import '../widgets/navbar_home.dart';
import '../../../books/presentation/pages/book_home_page.dart';

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
                ProfilePage(),
                BookHomePage(),
                BookHomePage(),
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
        ],
      ),
    );
  }
}
