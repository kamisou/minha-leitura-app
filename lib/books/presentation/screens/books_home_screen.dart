import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../shared/presentation/widgets/appbar_user_content.dart';
import '../../../shared/presentation/widgets/navbar_home.dart';
import '../pages/books_home_page.dart';

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
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 50,
            ),
            child: BooksHomePage(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 50,
            ),
            child: BooksHomePage(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 50,
            ),
            child: BooksHomePage(),
          ),
        ],
      ),
      bottomSheet: NavBarHome(
        controller: pageController,
        // TODO: utilizar classe de ícones svg customizada
        icons: const ['bars', 'home', 'book'],
      ),
    );
  }
}
