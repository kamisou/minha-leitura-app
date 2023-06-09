import 'package:flutter/material.dart';

import 'books/presentation/screens/books_home_screen.dart';

part 'configuration/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      theme: _theme,
    );
  }
}
