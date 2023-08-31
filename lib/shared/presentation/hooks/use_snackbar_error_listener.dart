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
        // ignore: only_throw_errors
        throw next.error!;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(message),
            ),
          ),
        );
      }
    }
  });
}
