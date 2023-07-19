import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/common/presentation/hooks/use_dd_mm_yy_h_m.dart';
import 'package:reading/readings/domain/models/reading.dart';

class BookReadingTile extends HookWidget {
  const BookReadingTile({
    super.key,
    required this.reading,
  });

  final Reading reading;

  @override
  Widget build(BuildContext context) {
    final color = useMemoized(() {
      // TODO(kamisou): lógica para meta de leitura (depende de cada livro)
      return const Color(0xFF007F00);
    });

    return Row(
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0xFFEEEEEE),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              FeatherIcons.calendar,
              color: Color(0xFF5D6C75),
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            useddMMyyHm(reading.date),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF5D6C75),
                ),
          ),
        ),
        const SizedBox(width: 8),
        DecoratedBox(
          decoration: ShapeDecoration(
            color: color.withOpacity(0.13),
            shape: const StadiumBorder(),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: Text(
              '${reading.pages} pág. lida(s)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
