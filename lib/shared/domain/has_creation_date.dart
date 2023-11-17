mixin HasCreationDate {
  DateTime? get createdAt;

  int compareByCreationDate(HasCreationDate b) {
    if (createdAt == null) {
      return -1;
    }

    return b.createdAt?.compareTo(createdAt!) ?? 1;
  }
}
