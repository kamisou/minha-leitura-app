enum DateError { empty, invalid }

class Date {
  const Date([this.value = '']);

  final String value;

  static DateError? validate(String? value) {
    if (value?.isEmpty ?? true) {
      return DateError.empty;
    } else if (!RegExp(r'^\d{2}/\d{2}/\d{2}$').hasMatch(value!)) {
      return DateError.invalid;
    }

    return null;
  }
}
