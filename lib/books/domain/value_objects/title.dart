enum TitleError { empty }

class Title {
  const Title([this.value = '']);

  final String value;

  static TitleError? validate(String? value) {
    if (value?.isEmpty ?? true) {
      return TitleError.empty;
    }

    return null;
  }
}
