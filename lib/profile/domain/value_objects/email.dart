enum EmailError { empty, invalid }

class Email {
  const Email([this.value = '']);

  final String value;

  static EmailError? validate(String? value) {
    if (value?.isEmpty ?? true) {
      return EmailError.empty;
    }

    if (!RegExp(r'^\w+(?:\.\w+)*@\w+(?:\.\w+)*$').hasMatch(value!)) {
      return EmailError.invalid;
    }

    return null;
  }
}
