import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/classes/data/repositories/class_repository.dart';
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
        height: 360,
        child: ref.watch(myClassesProvider).maybeWhen(
              orElse: () => const Center(
                child: CircularProgressIndicator(),
              ),
              data: (data) => SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ExpansionPanelList(
                  dividerColor: Colors.white,
                  elevation: 0,
                  expandedHeaderPadding: EdgeInsets.zero,
                  expandIconColor: Colors.white,
                  expansionCallback: (panelIndex, isExpanded) {
                    if (panelIndex == 5) {
                      context.pop(
                        const RankingFilterDTO(type: RankingType.global),
                      );
                    } else {
                      expanded.value = isExpanded ? panelIndex : null;
                    }
                  },
                  materialGapSize: 0,
                  children: [
                    for (final (i, tab, type) in tabs)
                      ExpansionPanel(
                        backgroundColor: Colors.white,
                        canTapOnHeader: true,
                        isExpanded: expanded.value == i,
                        headerBuilder: (context, isExpanded) => Padding(
                          padding: const EdgeInsets.all(16),
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
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
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
                                      i == 0 ? $class.name : $class.schoolName,
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
                    ExpansionPanel(
                      backgroundColor: Colors.white,
                      canTapOnHeader: true,
                      headerBuilder: (context, isExpanded) => Padding(
                        padding: const EdgeInsets.all(16),
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
                      body: const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
