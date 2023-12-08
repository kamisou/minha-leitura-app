import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/presentation/widgets/star_rating_widget.dart';
import 'package:reading/ranking/data/cached/book_ranking.dart';
import 'package:reading/ranking/data/cached/book_reading_ranking.dart';
import 'package:reading/ranking/data/dtos/ranking_filter_dto.dart';
import 'package:reading/ranking/domain/models/ranking.dart';
import 'package:reading/ranking/presentation/dialogs/ranking_filter_dialog.dart';
import 'package:reading/shared/presentation/hooks/use_asyncvalue_listener.dart';
import 'package:reading/shared/presentation/hooks/use_filter_name.dart';
import 'package:reading/shared/presentation/widgets/user_app_bar.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class BookRankingPage extends HookConsumerWidget {
  const BookRankingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = useState(const RankingFilterDTO(type: RankingType.global));
    final filterName = useFilterName(filter.value.type, filter.value.$class);
    final controller = useTabController(initialLength: 2);

    useAutomaticKeepAlive();
    useAsyncValueListener(ref, bookRankingProvider(filter.value));

    return Column(
      children: [
        const UserAppBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: Text(
                    'Ranking de Livros',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 8),
                ),
                SliverToBoxAdapter(
                  child: Text(
                    'Acompanhe o ranking dos livros mais bem avaliados '
                    'e os mais lidos',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorExtension?.gray[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
                SliverToBoxAdapter(
                  child: Center(
                    child: FilledButton.icon(
                      onPressed: () => showDialog<RankingFilterDTO?>(
                        context: context,
                        builder: (context) => RankingFilterDialog(
                          initialState: filter.value,
                        ),
                      ).then(
                        (value) => value != null //
                            ? filter.value = value
                            : null,
                      ),
                      icon: const Icon(FeatherIcons.filter),
                      label: const Text('Filtrar'),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
                SliverToBoxAdapter(
                  child: Text(
                    filterName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
                SliverToBoxAdapter(
                  child: TabBar(
                    controller: controller,
                    labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorExtension?.gray[800],
                          fontWeight: FontWeight.w700,
                        ),
                    splashFactory: NoSplash.splashFactory,
                    unselectedLabelStyle: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                          color: Theme.of(context).colorExtension?.gray[600],
                        ),
                    tabs: const [
                      Tab(text: 'Avaliação'),
                      Tab(text: 'Leitura'),
                    ],
                  ),
                ),
              ],
              body: RefreshIndicator(
                onRefresh: () =>
                    ref.refresh(bookRankingProvider(filter.value).future),
                child: TabBarView(
                  controller: controller,
                  children: [
                    ref.watch(bookRankingProvider(filter.value)).maybeWhen(
                          data: (data) => (data?.spots.isNotEmpty ?? false)
                              ? Table(
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  columnWidths: const {
                                    0: FixedColumnWidth(72),
                                    2: FixedColumnWidth(110),
                                  },
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorExtension
                                            ?.gray[300],
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
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                        Text(
                                          'Livro',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          child: Text(
                                            'Avaliação',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    for (final (i, entry)
                                        in data!.spots.indexed)
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
                                              '${entry.rank}',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Text(
                                            entry.title,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${entry.ratingAvg}',
                                                  textAlign: TextAlign.end,
                                                ),
                                                const SizedBox(width: 8),
                                                StarRatingWidget(
                                                  value: entry.ratingAvg,
                                                  iconSize: 14,
                                                  color: Theme.of(context)
                                                      .colorExtension
                                                      ?.gray[800],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                )
                              : Text(
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
                          orElse: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ref
                        .watch(bookReadingRankingProvider(filter.value))
                        .maybeWhen(
                          data: (data) => (data?.spots.isNotEmpty ?? false)
                              ? Table(
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  columnWidths: const {
                                    0: FixedColumnWidth(72),
                                    2: FixedColumnWidth(110),
                                  },
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorExtension
                                            ?.gray[300],
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
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                        Text(
                                          'Livro',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          child: Text(
                                            'Leitura',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    for (final (i, entry)
                                        in data!.spots.indexed)
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
                                              '${entry.rank}',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Text(
                                            entry.title,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            child: Text(
                                              '${entry.readings}',
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                )
                              : Text(
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
                          orElse: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
