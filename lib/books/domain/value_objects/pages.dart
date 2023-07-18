enum PagesError { empty, invalid }

class Pages {
  const Pages([this.value]);
  const Pages.fromJson(int json) : value = json;
  Pages.fromString(String string) : value = int.parse(string);

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

  static int? toJson(Pages pages) => pages.value;
}
