enum EmailError { empty }

class Email {
  const Email([this.value = '']);

  final String value;

  static EmailError? validate(String? value) {
    if (value?.isEmpty ?? true) {
      return EmailError.empty;
    }

    return null;
  }
}
