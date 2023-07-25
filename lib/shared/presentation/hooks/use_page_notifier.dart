import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Creates a value notifier whenever `pageController` changes pages.
///
/// Unlike useState, it doesn't subscribe to the `ValueNotifer`.
ValueNotifier<int> usePageNotifier(PageController pageController) {
  final page = ValueNotifier(pageController.initialPage);

  useEffect(() {
    void listener() {
      if (!pageController.hasClients) {
        return;
      }

      final controllerPage = pageController.page!.round();

      if (controllerPage != page.value) {
        page.value = controllerPage;
      }
    }

    pageController.addListener(listener);

    return () => pageController.removeListener(listener);
  });

  return page;
}
