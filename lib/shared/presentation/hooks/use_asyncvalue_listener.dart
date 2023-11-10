import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/shared/infrastructure/debugger.dart';

void useAsyncValueListener(
  WidgetRef ref,
  ProviderListenable<AsyncValue<dynamic>> asyncValue,
) {
  ref.listen(asyncValue, (previous, next) {
    final error = next.asError;

    if (error != null) {
      ref
          .read(debuggerProvider.notifier)
          .logException(error.error, error.stackTrace);
    }
  });
}
