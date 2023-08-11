enum PagesError { empty, invalid, zero }

class Pages {
  const Pages([this.value]);
  Pages.fromString(String value) : value = int.tryParse(value);

  final int? value;

  static PagesError? validate(String? value) {
    if (value?.isEmpty ?? true) {
      return PagesError.empty;
    }

    final integer = int.tryParse(value!);

    if (integer == null) {
      return PagesError.invalid;
    } else if (integer == 0) {
      return PagesError.zero;
    }

    return null;
  }
}
