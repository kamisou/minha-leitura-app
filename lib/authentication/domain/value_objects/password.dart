enum PasswordError { empty }

class Password {
  const Password([this.value = '']);
  const Password.fromJson(String json) : value = json;

  final String value;

  static PasswordError? validate(String? value) => switch (value) {
        '' || null => PasswordError.empty,
        _ => null,
      };

  static String toJson(Password password) => password.value;
}

enum PasswordConfirmError { empty, noMatch }

class PasswordConfirm {
  const PasswordConfirm([this.value = '']);
  const PasswordConfirm.fromJson(String json) : value = json;

  final String value;

  static PasswordConfirmError? validate(
    String? value,
    String? other,
  ) {
    if (value?.isEmpty ?? true) {
      return PasswordConfirmError.empty;
    }

    if (value != other) {
      return PasswordConfirmError.noMatch;
    }

    return null;
  }

  static String toJson(PasswordConfirm password) => password.value;
}
