import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class NavBarHome extends HookWidget {
  const NavBarHome({
    super.key,
    required this.controller,
    required this.icons,
  });

  final PageController controller;

  final List<String> icons;

  @override
  Widget build(BuildContext context) {
    const double iconSize = 48;

    final page = useState(0.0);
    final pixels = useState(0.0);
    final distance = useMemoized(
      () => 2 * (0.5 - (page.value - page.value.truncate())).abs(),
      [page, pixels],
    );

    final controllerListener = useCallback(() {
      if (!controller.hasClients && !controller.position.hasPixels) {
        return;
      }

      pixels.value =
          controller.position.pixels / controller.position.maxScrollExtent;
      page.value = controller.page!;
    }, [controller]);

    useEffect(
      () {
        controller.addListener(controllerListener);

        page.value = controller.initialPage.toDouble();
        pixels.value = controller.initialPage / (icons.length - 1);

        return () => controller.removeListener(controllerListener);
      },
      [controller],
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(36),
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: const [
          BoxShadow(
            blurRadius: 16,
            color: Color(0x1A000000),
            offset: Offset(0, -4),
            spreadRadius: 0,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: MediaQuery.of(context).size.width * .23,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: pixels.value * (constraints.maxWidth - iconSize),
              width: iconSize,
              height: iconSize,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  width: iconSize,
                  height: iconSize,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int index = 0; index < icons.length; index += 1)
                  GestureDetector(
                    onTap: () => controller.animateToPage(
                      index,
                      curve: Curves.easeInOutQuart,
                      duration: const Duration(milliseconds: 300),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: iconSize,
                      height: iconSize,
                      child: SvgPicture(
                        AssetBytesLoader(
                          'assets/icons/compiled/${icons[index]}.svg.vec',
                        ),
                        colorFilter: ColorFilter.mode(
                          index == page.value.round()
                              ? Color.lerp(
                                  const Color(0xFFB7BCBF),
                                  Theme.of(context).colorScheme.onPrimary,
                                  distance,
                                )!
                              : const Color(0xFFB7BCBF),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
