import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/shared/domain/has_name.dart';
import 'package:reading/shared/presentation/hooks/use_dd_mm_yy_h_m.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class AuthorTimestamp extends HookWidget {
  const AuthorTimestamp({
    super.key,
    required this.author,
    this.timestamp,
  });

  final HasName author;

  final DateTime? timestamp;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: Theme.of(context).colorExtension?.gray[400],
            fontWeight: FontWeight.w400,
          ),
      child: Row(
        children: [
          Flexible(
            child: Text(
              author.name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            timestamp != null ? useddMMyyHm(timestamp!) : 'Não sincronizado',
          ),
        ],
      ),
    );
  }
}
