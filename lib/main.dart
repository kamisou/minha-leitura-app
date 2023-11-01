import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:reading/authentication/data/repositories/token_repository.dart';
import 'package:reading/intro/data/repositories/intro_repository.dart';
import 'package:reading/profile/data/cached/profile.dart';
import 'package:reading/routes.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/shared/infrastructure/database.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
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

Future<ProviderContainer> initRiverpod() async {
  final container = ProviderContainer();

  try {
    // services
    await Future.wait([
      container.read(connectionStatusProvider.future),
      container.read(tokenRepositoryProvider.future),
      container.read(databaseProvider).initialize(),
      container.read(introRepositoryProvider.future),
      container.read(restApiServerProvider.future),
    ]);

    await container.read(profileProvider.future);
  } catch (error, stackTrace) {
    log(
      'initialization failed:',
      error: error,
      stackTrace: stackTrace,
      name: 'Riverpod',
    );
  }

  return container;
}

Future<void> initLocale() async {
  Intl.defaultLocale = 'pt_BR';
  return initializeDateFormatting(Intl.defaultLocale);
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
