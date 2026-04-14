import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/ranking/data/cached/book_reading_ranking.dart';
import 'package:reading/ranking/data/dtos/ranking_filter_dto.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class BookReadingRankingTab extends HookConsumerWidget {
  const BookReadingRankingTab({
    super.key,
    required this.filter,
  });

  final RankingFilterDTO filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    return ref.watch(bookReadingRankingProvider(filter)).maybeWhen(
          data: (data) => (data?.spots.isNotEmpty ?? false)
              ? Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FixedColumnWidth(72),
                      2: FixedColumnWidth(64),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorExtension?.gray[300],
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
                              'Leituras',
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
                      for (final (i, entry) in data!.spots.indexed)
                        TableRow(
                          decoration: BoxDecoration(
                            color: i.isEven
                                ? Theme.of(context).colorExtension?.gray[150]
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
                              maxLines: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 8,
                              ),
                              child: Text(
                                '${entry.total}',
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                )
              : Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Não há dados para o filtro',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorExtension?.gray[400],
                        ),
                  ),
                ),
          orElse: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}
