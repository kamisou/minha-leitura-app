import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/shared/infrastructure/error_logger.dart';

void logAsyncValueError(
  WidgetRef ref,
  ProviderListenable<AsyncValue<dynamic>> asyncValue,
) {
  ref.listen(asyncValue, (previous, next) {
    final error = next.asError;

    if (error != null) {
      ref.read(errorLoggerProvider.notifier).log(error.error, error.stackTrace);
    }
  });
}
