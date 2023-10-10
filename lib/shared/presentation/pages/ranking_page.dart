import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/ranking/data/dtos/ranking_filter_dto.dart';
import 'package:reading/ranking/data/repositories/ranking_repository.dart';
import 'package:reading/ranking/presentation/dialogs/ranking_filter_dialog.dart';
import 'package:reading/shared/presentation/widgets/user_app_bar.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class RankingPage extends HookConsumerWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = useState(
      const RankingFilterDTO(type: RankingType.global),
    );

    return Column(
      children: [
        AppBar(
          title: const UserAppBar(),
        ),
        Text(
          'Ranking',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: 8),
        Text(
          'Acompanhe seu ranking de leitura',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorExtension?.gray[600],
              ),
        ),
        const SizedBox(height: 32),
        FilledButton.icon(
          onPressed: () => showDialog<RankingFilterDTO?>(
            context: context,
            builder: (context) => const RankingFilterDialog(),
          ).then((value) => value != null ? filter.value = value : null),
          icon: const Icon(FeatherIcons.filter),
          label: const Text('Filtrar'),
        ),
        const SizedBox(height: 32),
        ref.watch(rankingProvider(filter.value)).maybeWhen(
              data: (data) => Column(
                children: [
                  Text(
                    filter.value.$class?.name ?? 'Global',
                  ),
                  Flexible(
                    child: Table(
                      children: [
                        const TableRow(
                          children: [
                            Text('Posição'),
                            Text('Aluno'),
                            Text('Páginas'),
                          ],
                        ),
                        for (final spot in data.spots)
                          TableRow(
                            children: [
                              Text('${spot.position}'),
                              Text(spot.user, overflow: TextOverflow.ellipsis),
                              Text('${spot.pages}'),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              orElse: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
      ],
    );
  }
}
