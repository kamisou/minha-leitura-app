import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/shared/presentation/widgets/user_app_bar.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class RankingPage extends HookConsumerWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          onPressed: () {},
          icon: const Icon(FeatherIcons.filter),
          label: const Text('Filtrar'),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
