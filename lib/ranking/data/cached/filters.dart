import 'package:reading/classes/data/cached/classes.dart';
import 'package:reading/classes/domain/models/class.dart';
import 'package:reading/ranking/domain/models/ranking.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filters.g.dart';

@riverpod
AsyncValue<Map<RankingType, List<Class>>> filters(FiltersRef ref) {
  return ref.watch(myClassesProvider).when(
        data: (classes) {
          final filters = <RankingType, List<Class>>{};

          void addFilter(
            RankingType type,
            Class $class,
            String Function(Class $class) get,
          ) {
            filters[type] ??= [];

            if (!filters[type]!.any((e) => get(e) == get($class))) {
              filters[type]!.add($class);
            }
          }

          for (final $class in classes.data) {
            addFilter(RankingType.$class, $class, (e) => e.name);
            addFilter(RankingType.school, $class, (e) => e.school.name);
            addFilter(RankingType.city, $class, (e) => e.school.city);
            addFilter(RankingType.state, $class, (e) => e.school.state);
            addFilter(RankingType.country, $class, (e) => e.school.country);
          }

          return AsyncData(filters);
        },
        error: AsyncError.new,
        loading: AsyncLoading.new,
      );
}
