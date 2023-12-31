import 'package:flutter/foundation.dart';
import 'package:reading/classes/domain/models/class.dart';
import 'package:reading/ranking/domain/models/ranking.dart';

@immutable
class RankingFilterDTO {
  const RankingFilterDTO({
    required this.type,
    this.$class,
  });

  final RankingType type;

  final Class? $class;

  @override
  bool operator ==(Object? other) {
    if (other is! RankingFilterDTO) {
      return false;
    }

    return other.type == type && other.$class == $class;
  }

  @override
  int get hashCode => Object.hashAll([type, $class]);
}
