import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/ranking/data/cached/ranking.dart';
import 'package:reading/ranking/data/dtos/ranking_filter_dto.dart';
import 'package:reading/ranking/presentation/dialogs/ranking_filter_dialog.dart';
import 'package:reading/shared/presentation/hooks/use_asyncvalue_listener.dart';
import 'package:reading/shared/presentation/hooks/use_filter_name.dart';
import 'package:reading/shared/presentation/widgets/user_app_bar.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class RankingPage extends StatefulHookConsumerWidget {
  const RankingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RankingPageState();
}

class _RankingPageState extends ConsumerState<RankingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final filter = useState(
      const RankingFilterDTO(type: RankingType.global),
    );

    logAsyncValueError(ref, rankingProvider(filter.value));

    return Column(
      children: [
        const UserAppBar(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Text(
                'Ranking',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Acompanhe seu ranking de leitura',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorExtension?.gray[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Center(
                child: FilledButton.icon(
                  onPressed: () => showDialog<RankingFilterDTO?>(
                    context: context,
                    builder: (context) => RankingFilterDialog(
                      filter: filter.value,
                    ),
                  ).then(
                    (value) => value != null ? filter.value = value : null,
                  ),
                  icon: const Icon(FeatherIcons.filter),
                  label: const Text('Filtrar'),
                ),
              ),
              const SizedBox(height: 32),
              ref.watch(rankingProvider(filter.value)).maybeWhen(
                    data: (data) => Column(
                      children: [
                        Text(
                          useFilterName(filter.value),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FixedColumnWidth(72),
                            2: FixedColumnWidth(64),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).colorExtension?.gray[300],
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 8,
                                    left: 8,
                                  ),
                                  child: Text(
                                    'Posição',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Text(
                                  'Aluno',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    'Páginas',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                            if (data?.spots.isEmpty ?? true)
                              TableRow(
                                children: [
                                  Text(
                                    'Não há dados para o filtro',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorExtension
                                              ?.gray[400],
                                        ),
                                  ),
                                ],
                              )
                            else
                              for (final (i, spot) in data!.spots.indexed)
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: i.isEven
                                        ? Theme.of(context)
                                            .colorExtension
                                            ?.gray[150]
                                        : null,
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        '${spot.position}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Text(
                                      spot.user,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                        '${spot.pages}',
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                          ],
                        ),
                      ],
                    ),
                    orElse: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
