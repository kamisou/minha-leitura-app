import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ValueNotifier<int> usePageNotifier(PageController pageController) {
  final page = useState(pageController.initialPage);

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
  }, [pageController]);

  return page;
}
