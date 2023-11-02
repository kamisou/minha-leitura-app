import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/shared/infrastructure/error_logger.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class DebugLog extends HookConsumerWidget {
  const DebugLog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSize = useState<double>(10);
    final hideStack = useState(false);

    return Stack(
      children: [
        Container(
          decoration: ShapeDecoration(
            color: Theme.of(context).colorExtension?.gray[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Consumer(
            builder: (context, ref, child) {
              final errors = ref.watch(errorLoggerProvider);
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: errors.length,
                itemBuilder: (context, index) => RichText(
                  text: TextSpan(
                    text: '${errors[index].exception}\n',
                    style: TextStyle(
                      color: Theme.of(context).colorExtension?.gray[200],
                      fontWeight: FontWeight.w600,
                      fontSize: fontSize.value + 2,
                    ),
                    children: hideStack.value
                        ? null
                        : [
                            TextSpan(
                              text: '${errors[index].stack}',
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorExtension?.gray[600],
                                fontSize: fontSize.value,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          right: 4,
          bottom: 4,
          child: Theme(
            data: Theme.of(context).copyWith(
              iconButtonTheme: const IconButtonThemeData(
                style: ButtonStyle(
                  iconColor: MaterialStatePropertyAll(
                    Colors.white,
                  ),
                  fixedSize: MaterialStatePropertyAll(
                    Size.square(12),
                  ),
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton.filled(
                  onPressed: () => fontSize.value += 2,
                  icon: const Icon(Icons.add),
                ),
                IconButton.filled(
                  onPressed: () => fontSize.value -= 2,
                  icon: const Icon(Icons.remove),
                ),
                if (hideStack.value)
                  IconButton(
                    onPressed: () => hideStack.value = !hideStack.value,
                    icon: const Icon(Icons.line_weight_sharp),
                  )
                else
                  IconButton.filled(
                    onPressed: () => hideStack.value = !hideStack.value,
                    icon: const Icon(Icons.line_weight_sharp),
                  ),
                IconButton.filled(
                  onPressed: ref.read(errorLoggerProvider.notifier).clear,
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
