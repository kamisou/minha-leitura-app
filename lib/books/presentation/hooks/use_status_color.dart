import 'dart:ui';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/domain/models/book_details.dart';

Color useStatusColor(BookStatus status) {
  return useMemoized(
    () => switch (status) {
      BookStatus.pending => const Color(0xFFF74235),
      BookStatus.finished => const Color(0xFF29BD1C),
      BookStatus.reading => const Color(0xFFF4B234),
    },
    [status],
  );
}
