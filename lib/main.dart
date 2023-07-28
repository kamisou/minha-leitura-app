import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:reading/intro/data/repositories/intro_repository.dart';
import 'package:reading/routes.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = Platform.localeName;
  await initializeDateFormatting(Intl.defaultLocale);

  await Hive.initFlutter();

  runApp(
    ProviderScope(
      parent: await initRiverpod(),
      child: const App(),
    ),
  );
}

Future<ProviderContainer> initRiverpod() async {
  final container = ProviderContainer();

  try {
    await container.read(introSeenProvider.future);
    await container.read(connectionStatusProvider.future);
  } catch (error, stackTrace) {
    log('riverpod initialization error', error: error, stackTrace: stackTrace);
  }

  return container;
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
