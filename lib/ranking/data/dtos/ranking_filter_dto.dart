import 'package:reading/classes/domain/models/class.dart';

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
    this.$class,
  });

  final RankingType type;

  final Class? $class;
}
