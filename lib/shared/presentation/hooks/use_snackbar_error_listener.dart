import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void useSnackbarErrorListener(
  WidgetRef ref, {
  required ProviderListenable<AsyncValue<dynamic>> provider,
  required String message,
}) {
  final context = useContext();

  ref.listen(provider, (previous, next) {
    if (next.asError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  });
}
