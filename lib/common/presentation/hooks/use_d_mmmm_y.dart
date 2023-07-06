import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

String usedMMMMy(DateTime date) {
  return useMemoized(
    () => DateFormat("d' de 'MMMM' de 'y").format(date),
    [date.day, date.month, date.year],
  );
}
