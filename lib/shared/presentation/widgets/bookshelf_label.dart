import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/books/presentation/hooks/use_status_info.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class BookshelfLabel extends HookWidget {
  const BookshelfLabel({super.key, required this.status});

  final BookStatus status;

  @override
  Widget build(BuildContext context) {
    final statusInfo = useStatusInfo(status);

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: statusInfo.color,
            shape: BoxShape.circle,
          ),
          width: 8,
          height: 8,
        ),
        const SizedBox(width: 5),
        Text(
          'Livros ${statusInfo.name}',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorExtension?.gray[400],
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }
}
