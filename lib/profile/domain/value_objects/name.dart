enum NameError { empty, invalid }

class Name {
  const Name([this.value = '']);

  final String value;

  static NameError? validate(String? value) {
    if (value?.isEmpty ?? true) {
      return NameError.empty;
    }

    if (value!.trim().split(' ').length == 1) {
      return NameError.invalid;
    }

    return null;
  }
}
