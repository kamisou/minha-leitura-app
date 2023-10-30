import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reading/achievements/domain/models/achievement.dart';
import 'package:reading/shared/util/theme_data_extension.dart';
import 'package:vector_graphics/vector_graphics.dart';

class AchievementCard extends StatelessWidget {
  const AchievementCard({
    super.key,
    required this.achievement,
  });

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture(
          width: 58,
          colorFilter: !achievement.completed
              ? const ColorFilter.mode(
                  Colors.black,
                  BlendMode.saturation,
                )
              : null,
          const AssetBytesLoader(
            'assets/vectors/compiled/achievement-completed.svg.vec',
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Text(
            achievement.title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorExtension?.gray[800],
                ),
          ),
        ),
      ],
    );
  }
}
