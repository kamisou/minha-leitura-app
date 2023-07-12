import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:reading/authentication/data/repositories/auth_repository.dart';
import 'package:reading/intro/data/repositories/intro_repository.dart';
import 'package:reading/router.dart';
import 'package:reading/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = Platform.localeName;
  await initializeDateFormatting(Intl.defaultLocale);

  final container = ProviderContainer();
  await container
      .read(authRepositoryProvider.future)
      .catchError((error) => null);
  await container.read(introSeenProvider.future);

  runApp(
    ProviderScope(
      parent: container,
      child: const App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeManagerProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      theme: theme,
    );
  }
}
