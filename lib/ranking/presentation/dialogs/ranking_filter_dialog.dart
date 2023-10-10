import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/classes/data/repositories/class_repository.dart';
import 'package:reading/ranking/data/dtos/ranking_filter_dto.dart';

class RankingFilterDialog extends HookConsumerWidget {
  const RankingFilterDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = useState<int?>(null);
    final tabs = useMemoized(
      () => [
        (0, 'Turma', RankingType.$class),
        (1, 'Escola', RankingType.school),
        (2, 'Cidade', RankingType.city),
        (3, 'Estado', RankingType.state),
        (4, 'País', RankingType.country),
        (5, 'Mundo', RankingType.global),
      ],
    );

    return Dialog(
      child: ref.watch(myClassesProvider).maybeWhen(
            orElse: () => const Center(
              child: CircularProgressIndicator(),
            ),
            data: (data) => ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) => isExpanded //
                  ? expanded.value = panelIndex
                  : null,
              children: [
                for (final (i, tab, type) in tabs)
                  ExpansionPanel(
                    isExpanded: expanded.value == i,
                    headerBuilder: (context, isExpanded) => Text(tab),
                    body: Column(
                      children: [
                        for (final $class in data)
                          GestureDetector(
                            onTap: () => context.pop(
                              RankingFilterDTO(
                                type: type,
                                $class: $class,
                              ),
                            ),
                            child:
                                Text(i == 0 ? $class.name : $class.schoolName),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
    );
  }
}
