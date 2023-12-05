import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/classes/domain/models/class.dart';
import 'package:reading/ranking/domain/models/ranking.dart';

String useFilterName(RankingType type, [Class? $class]) {
  return useMemoized(
    () => switch (type) {
      RankingType.$class => $class!.name,
      RankingType.school => $class!.school.name,
      RankingType.city => $class!.school.city,
      RankingType.state => $class!.school.state,
      RankingType.country => $class!.school.country,
      RankingType.global => 'Global',
    },
    [type, $class],
  );
}
