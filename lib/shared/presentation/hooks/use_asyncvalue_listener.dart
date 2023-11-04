import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/debugging/presentation/controllers/debug_drawer_controller.dart';

void logAsyncValueError(
  WidgetRef ref,
  ProviderListenable<AsyncValue<dynamic>> asyncValue,
) {
  ref.listen(asyncValue, (previous, next) {
    final error = next.asError;

    if (error != null) {
      ref
          .read(debugDrawerControllerProvider.notifier)
          .logException(error.error, error.stackTrace);
    }
  });
}
