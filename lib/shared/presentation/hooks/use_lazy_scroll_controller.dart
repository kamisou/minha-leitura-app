import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ScrollController useLazyScrollController({
  Future<void> Function()? onEndOfScroll,
  double endOfScrollthreshold = 80,
}) {
  final controller = useScrollController();
  final loading = useRef(false);

  final listener = useCallback(
    () async {
      if (loading.value || !controller.hasClients) {
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
