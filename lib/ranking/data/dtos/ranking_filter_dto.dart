enum RankingType {
  $class,
  school,
  city,
  state,
  country,
  global,
}

class RankingFilterDTO {
  const RankingFilterDTO({
    required this.type,
    this.data = 0,
  });

  final RankingType type;

  final int data;
}
