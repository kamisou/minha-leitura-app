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
