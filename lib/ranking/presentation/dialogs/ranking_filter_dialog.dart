import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/ranking/data/cached/filters.dart';
import 'package:reading/ranking/data/dtos/ranking_filter_dto.dart';
import 'package:reading/ranking/domain/models/ranking.dart';
import 'package:reading/shared/presentation/hooks/use_filter_name.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class RankingFilterDialog extends HookConsumerWidget {
  const RankingFilterDialog({
    super.key,
    this.initialState,
  });

  final RankingFilterDTO? initialState;

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
      tabs.indexWhere((tab) => tab.$3 == initialState?.type),
    );

    return Dialog(
      child: SizedBox(
        height: 380,
        child: ref.watch(filtersProvider).maybeWhen(
              orElse: () => const Center(
                child: CircularProgressIndicator(),
              ),
              data: (filters) => ListView(
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
                          body: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (filters[type]?.isEmpty ?? true)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 8,
                                    bottom: 8,
                                    left: 8,
                                  ),
                                  child: Text(
                                    'Para filtrar por $tab, '
                                    'entre em uma turma.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorExtension
                                              ?.gray[300],
                                        ),
                                  ),
                                )
                              else
                                for (final filter in filters[type]!)
                                  GestureDetector(
                                    onTap: () => context.pop(
                                      RankingFilterDTO(
                                        type: type,
                                        $class: filter,
                                      ),
                                    ),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        useFilterName(type, filter),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
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
