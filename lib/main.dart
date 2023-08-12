import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:reading/authentication/data/repositories/token_repository.dart';
import 'package:reading/intro/data/repositories/intro_repository.dart';
import 'package:reading/profile/data/repositories/profile_repository.dart';
import 'package:reading/routes.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocale();

  final riverpod = await initRiverpod();

  runApp(
    ProviderScope(
      parent: riverpod,
      child: const App(),
    ),
  );
}

Future<void> initLocale() async {
  Intl.defaultLocale = Platform.localeName;
  return initializeDateFormatting(Intl.defaultLocale);
}

Future<ProviderContainer> initRiverpod() async {
  final container = ProviderContainer();

  try {
    await container.read(databaseProvider).initialize();
    await container.read(introSeenProvider.future);
    await container.read(connectionStatusProvider.future);
    await container.read(tokenRepositoryProvider.future);
    await container.read(profileProvider.future);
  } catch (_) {}

  return container;
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeManagerProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: theme,
    );
  }
}
