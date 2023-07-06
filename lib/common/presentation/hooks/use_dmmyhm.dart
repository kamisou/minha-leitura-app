import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

String usedMMyHm(DateTime dateTime) {
  return useMemoized(
    () => DateFormat("d'/'MM'/'y' - 'H':'m").format(dateTime),
    [dateTime],
  );
}
