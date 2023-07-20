import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

String useddMMyyHm(DateTime dateTime) {
  return useMemoized(
    () => DateFormat("dd'/'MM'/'yy' - 'H':'m").format(dateTime),
    [dateTime],
  );
}