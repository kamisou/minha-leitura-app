import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'configuration/pages.dart';
import 'configuration/theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeManagerProvider);
    final pages = ref.watch(pagesProvider);

    return MaterialApp(
      home: Navigator(
        pages: pages,
        onPopPage: (route, result) => route.didPop(result),
      ),
      theme: theme,
    );
  }
}
