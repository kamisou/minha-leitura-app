// ignore_for_file: only_throw_errors

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/debugging/presentation/controllers/debug_drawer_controller.dart';

void useControllerListener(
  WidgetRef ref, {
  required ProviderListenable<AsyncValue<dynamic>> controller,
  String? Function(Object error)? onError,
  void Function()? onSuccess,
}) {
  final context = useContext();

  ref.listen(
    controller,
    (previous, next) {
      final error = next.asError;

      if (error == null) {
        if ((previous?.hasValue ?? false) && next.asData != null) {
          onSuccess?.call();
        }
      } else {
        final message = onError?.call(error.error);

        if (message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(message),
              ),
            ),
          );
        }

        if (ref.read(debugDrawerStateProvider).isDebugMode) {
          throw error.error;
        }
      }
    },
  );
}
