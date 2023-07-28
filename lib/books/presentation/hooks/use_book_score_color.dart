import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/domain/models/book_reading.dart';

Color useBookScoreColor(BookReadingScore score) {
  return useMemoized(
    () => switch (score) {
      BookReadingScore.bad => const Color(0xFFF44336),
      BookReadingScore.regular => const Color(0xFFA47C04),
      BookReadingScore.good => const Color(0xFF007F00),
    },
    [score],
  );
}
