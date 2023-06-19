import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:unicons/unicons.dart';

import '../../../shared/presentation/widgets/appbar_user_content.dart';
import '../../../shared/presentation/widgets/navbar_home.dart';
import '../pages/book_home_page.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(initialPage: 1);

    return Scaffold(
      appBar: AppBar(
        title: const AppBarUserContent(
          userName: 'João Marcos Kaminoski de Souza',
        ),
      ),
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          BookHomePage(),
          BookHomePage(),
          BookHomePage(),
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
