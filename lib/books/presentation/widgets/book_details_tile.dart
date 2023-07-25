import 'package:flutter/material.dart';
import 'package:reading/common/presentation/theme_extension.dart';

class BookDetailsTile extends StatelessWidget {
  const BookDetailsTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;

  final String label;

  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: ShapeDecoration(
            color: Theme.of(context).colorExtension!.gray[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Theme.of(context).colorExtension!.gray[200]!,
              ),
            ),
          ),
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.all(14),
          child: Icon(
            icon,
            color: Theme.of(context).colorExtension?.gray[800],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorExtension?.gray[800],
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
