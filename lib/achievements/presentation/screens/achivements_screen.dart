import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/achievements/data/cached/achievements.dart';
import 'package:reading/achievements/presentation/widgets/achievement_section.dart';
import 'package:reading/shared/presentation/widgets/user_app_bar.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class AchivementsScreen extends ConsumerWidget {
  const AchivementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const UserAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
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
            ref.watch(achievementsProvider).maybeWhen(
                  data: (achievements) => SliverList.builder(
                    itemCount: achievements.length,
                    itemBuilder: (context, index) => AchievementSection(
                      category: achievements[index],
                    ),
                  ),
                  orElse: () => const SliverToBoxAdapter(
                    child: SizedBox(),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
