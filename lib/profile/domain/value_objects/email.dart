enum EmailError { empty }

class Email {
  const Email([this.value = '']);
  const Email.fromJson(String json) : value = json;

  final String value;

  static EmailError? validate(String? value) => switch (value) {
        '' || null => EmailError.empty,
        _ => null,
      };

  static String toJson(Email email) => email.value;
}
