enum PasswordError { empty, noMatch }

class Password {
  const Password([this.value = '']);

  final String value;

  static PasswordError? validate(String? value) {
    if (value?.isEmpty ?? true) {
      return PasswordError.empty;
    }

    return null;
  }
}

class PasswordConfirm {
  const PasswordConfirm([this.value = '']);

  final String value;

  static PasswordError? validate(String? value, String? other) {
    if (value?.isEmpty ?? true) {
      return PasswordError.empty;
    }

    if (other != null && other != value) {
      return PasswordError.noMatch;
    }

    return null;
  }
}
