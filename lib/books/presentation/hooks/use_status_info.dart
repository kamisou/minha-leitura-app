import 'dart:ui';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/domain/models/book_details.dart';

class StatusInfo {
  const StatusInfo({
    required this.color,
    required this.name,
  });

  final Color color;
  final String name;
}

StatusInfo useStatusInfo(BookStatus status) {
  return useMemoized(
    () => switch (status) {
      BookStatus.pending => const StatusInfo(
          color: Color(0xFFF74235),
          name: 'em andamento',
        ),
      BookStatus.reading => const StatusInfo(
          color: Color(0xFFF4B234),
          name: 'emprestados',
        ),
      BookStatus.finished => const StatusInfo(
          color: Color(0xFF29BD1C),
          name: 'concluídos',
        ),
    },
    [status],
  );
}
