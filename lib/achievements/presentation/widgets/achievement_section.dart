import 'package:flutter/material.dart';
import 'package:reading/achievements/domain/models/achievement.dart';
import 'package:reading/achievements/presentation/widgets/achievement_card.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class AchievementSection extends StatelessWidget {
  const AchievementSection({
    super.key,
    required this.category,
  });

  final AchievementCategory category;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              category.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorExtension?.gray[800],
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                color: Theme.of(context).colorExtension?.gray[800],
                height: 1,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              for (var i = 0; i < category.achievements.length; i += 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: AchievementCard(
                    achievement: category.achievements[i],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
