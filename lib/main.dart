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

  await initLocale();
  await initHive();

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

Future<void> initHive() async {
  return Hive.initFlutter();
}

Future<ProviderContainer> initRiverpod() async {
  final container = ProviderContainer();

  await container.read(introSeenProvider.future);
  await container.read(connectionStatusProvider.future);

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
