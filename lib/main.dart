import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:reading/authentication/data/repositories/auth_repository.dart';
import 'package:reading/intro/data/repositories/intro_repository.dart';
import 'package:reading/routes.dart';
import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:reading/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = Platform.localeName;
  await initializeDateFormatting(Intl.defaultLocale);

  await Hive.initFlutter();

  final container = ProviderContainer();
  try {
    await container.read(introSeenProvider.future);
    await container.read(connectionStatusProvider.future);
    await container.read(myUserProvider.future);
  } catch (error, stackTrace) {
    log('initialization error', error: error, stackTrace: stackTrace);
  }

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
