enum PhoneError { empty, invalid }

class Phone {
  const Phone([this.value = '']);

  final String value;

  static PhoneError? validate(String? value) {
    if (value?.isEmpty ?? true) {
      return PhoneError.empty;
    }

    if (!RegExp(r'^\(\d{2}\)(?:\d )?\d{4}-\d{4}$').hasMatch(value!)) {
      return PhoneError.invalid;
    }

    return null;
  }
}
