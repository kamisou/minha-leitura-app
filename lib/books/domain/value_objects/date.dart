import 'package:intl/intl.dart';

enum DateError { empty, invalid }

class Date {
  const Date([this.value]);
  Date.fromString(String value) : value = _parse(value);

  static DateTime? _parse(String value) {
    try {
      return DateFormat.yMd().parse(value);
    } on FormatException {
      return null;
    }
  }

  final DateTime? value;

  static DateError? validate(String? value) {
    if (value?.isEmpty ?? true) {
      return DateError.empty;
    } else if (!RegExp(r'^\d{2}/\d{2}/\d{2}$').hasMatch(value!)) {
      return DateError.invalid;
    }

    return null;
  }
}
