enum PagesError { empty, invalid }

class Pages {
  const Pages([this.value]);
  Pages.fromString(String value) : value = int.tryParse(value);

  final int? value;

  static PagesError? validate(String? value) {
    if (value?.isEmpty ?? true) {
      return PagesError.empty;
    }

    if (int.tryParse(value!) == null) {
      return PagesError.invalid;
    }

    return null;
  }
}
