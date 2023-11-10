import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/achievements/data/cached/achievements.dart';
import 'package:reading/achievements/presentation/widgets/achievement_section.dart';
import 'package:reading/debugging/presentation/widgets/debug_scaffold.dart';
import 'package:reading/shared/presentation/hooks/use_asyncvalue_listener.dart';
import 'package:reading/shared/presentation/widgets/app_bar_leading.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class AchivementsScreen extends ConsumerWidget {
  const AchivementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAsyncValueListener(ref, achievementsProvider);

    return DebugScaffold(
      appBar: AppBar(
        actions: const [SizedBox()],
        leading: const AppBarLeading(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Text(
                    'Conquistas',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Acompanhe suas conquistas de leitura',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorExtension?.gray[600],
                        ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: ref.watch(achievementsProvider).maybeWhen(
                  data: (achievements) => SliverList.builder(
                    itemCount: achievements.length,
                    itemBuilder: (context, index) => AchievementSection(
                      category: achievements[index],
                    ),
                  ),
                  orElse: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
