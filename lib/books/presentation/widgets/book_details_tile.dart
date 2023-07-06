import 'package:flutter/material.dart';

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
            color: const Color(0xFFFAFAFA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(
                color: Color(0xFFE8EAED),
              ),
            ),
          ),
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.all(14),
          child: Icon(
            icon,
            // TODO(kamisou): lidar com essa cor repetida
            color: const Color(0xFF3B4149),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF3B4149),
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
