enum DescriptionError { empty }

class Description {
  const Description([this.value = '']);

  final String value;

  static DescriptionError? validate(String? value) {
    if (value?.isEmpty ?? true) {
      return DescriptionError.empty;
    }

    return null;
  }
}
