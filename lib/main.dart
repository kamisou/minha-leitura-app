import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:reading/app.dart';
import 'package:reading/authentication/data/repositories/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = Platform.localeName;
  await initializeDateFormatting(Intl.defaultLocale);

  final container = ProviderContainer();
  await container.read(authRepositoryProvider.future);

  runApp(
    ProviderScope(
      parent: container,
      child: const App(),
    ),
  );
}
