import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/classes/data/cached/classes.dart';
import 'package:reading/ranking/data/dtos/ranking_filter_dto.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class RankingFilterDialog extends HookConsumerWidget {
  const RankingFilterDialog({
    super.key,
    this.filter,
  });

  final RankingFilterDTO? filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = useMemoized(
      () => [
        (0, 'Turma', RankingType.$class),
        (1, 'Escola', RankingType.school),
        (2, 'Cidade', RankingType.city),
        (3, 'Estado', RankingType.state),
        (4, 'País', RankingType.country),
      ],
    );
    final expanded = useState<int?>(
      tabs.indexWhere((tab) => tab.$3 == filter?.type),
    );

    return Dialog(
      child: SizedBox(
        height: 380,
        child: ref.watch(myClassesProvider).maybeWhen(
              orElse: () => const Center(
                child: CircularProgressIndicator(),
              ),
              data: (data) => ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Filtrar por:',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  ExpansionPanelList(
                    dividerColor: Colors.transparent,
                    elevation: 0,
                    expandedHeaderPadding: EdgeInsets.zero,
                    expandIconColor: Colors.white,
                    expansionCallback: (panelIndex, isExpanded) =>
                        expanded.value = isExpanded //
                            ? panelIndex
                            : null,
                    materialGapSize: 0,
                    children: [
                      for (final (i, tab, type) in tabs)
                        ExpansionPanel(
                          backgroundColor: Colors.transparent,
                          canTapOnHeader: true,
                          isExpanded: expanded.value == i,
                          headerBuilder: (context, isExpanded) => Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              tab,
                              style: Theme.of(context)
                                  .textTheme //
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorExtension
                                        ?.gray[600],
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          body: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                if (data.isEmpty)
                                  Text(
                                    'Para filtrar por $tab, '
                                    'entre em uma turma.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorExtension
                                              ?.gray[600],
                                        ),
                                  )
                                else
                                  for (final $class in data)
                                    GestureDetector(
                                      onTap: () => context.pop(
                                        RankingFilterDTO(
                                          type: type,
                                          $class: $class,
                                        ),
                                      ),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          i == 0
                                              ? $class.name
                                              : $class.schoolName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorExtension
                                                    ?.gray[600],
                                              ),
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () => context.pop(
                        const RankingFilterDTO(type: RankingType.global),
                      ),
                      child: Text(
                        'Global',
                        style: Theme.of(context)
                            .textTheme //
                            .bodyLarge
                            ?.copyWith(
                              color:
                                  Theme.of(context).colorExtension?.gray[600],
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
