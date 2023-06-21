import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'authentication/data/repositories/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await container.read(authRepositoryProvider.future);

  runApp(
    ProviderScope(
      parent: container,
      child: const App(),
    ),
  );
}
