// ignore_for_file: only_throw_errors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      if (previous?.hasValue ?? false) {
        onSuccess?.call();
      }
    },
    onError: (error, stackTrace) {
      final message = onError?.call(error);

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

      if (kDebugMode) {
        throw error;
      }
    },
  );
}
