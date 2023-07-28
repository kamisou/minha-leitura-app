import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void useSnackbarErrorListener(
  WidgetRef ref, {
  required ProviderListenable<AsyncValue<dynamic>> provider,
  required String? Function(Object error) messageBuilder,
}) {
  final context = useContext();

  ref.listen(provider, (previous, next) {
    if (next.asError != null) {
      final message = messageBuilder(next.error!);

      if (message == null) {
        if (next.error is Error) {
          throw next.error! as Error;
        } else if (next.error is Exception) {
          throw next.error! as Exception;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  });
}