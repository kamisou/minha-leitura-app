import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ScrollController useLazyScrollController({
  required bool finished,
  Future<void> Function()? onEndOfScroll,
  double endOfScrollthreshold = 80,
}) {
  final controller = useScrollController();
  final loading = useRef(false);
  final reachedEnd = useRef(false);

  final listener = useCallback(
    () async {
      if (reachedEnd.value || loading.value || !controller.hasClients) {
        return;
      }

      if (controller.position.extentAfter < endOfScrollthreshold) {
        loading.value = true;
        await onEndOfScroll?.call();
        loading.value = false;

        if (controller.position.extentAfter < endOfScrollthreshold) {
          reachedEnd.value = true;
        }
      }
    },
    [controller],
  );

  useEffect(
    () {
      if (!finished) {
        controller.addListener(listener);
        return () => controller.removeListener(listener);
      }
      return null;
    },
    [controller, finished],
  );

  return controller;
}
