enum RatingError { empty }

class Rating {
  const Rating([this.value]);

  final double? value;

  static RatingError? validate(String? value) {
    if (value?.isEmpty ?? true) {
      return RatingError.empty;
    }

    return null;
  }
}
