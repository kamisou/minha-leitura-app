import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

PageController useLazyPageController({
  Future<void> Function()? onEndOfScroll,
  double endOfScrollthreshold = 80,
  double viewportFraction = 1.0,
}) {
  final controller = usePageController(viewportFraction: viewportFraction);
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
      }
    },
    [controller],
  );

  useEffect(
    () {
      controller.addListener(listener);
      return () => controller.removeListener(listener);
    },
    [controller],
  );

  return controller;
}
