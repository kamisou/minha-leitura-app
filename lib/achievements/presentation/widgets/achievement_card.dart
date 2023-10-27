import 'package:flutter/material.dart';
import 'package:reading/achievements/domain/models/achievement.dart';
import 'package:reading/shared/util/color_extension.dart';
import 'package:reading/shared/util/theme_data_extension.dart';
import 'package:unicons/unicons.dart';

class AchievementCard extends StatelessWidget {
  const AchievementCard({
    super.key,
    required this.achievement,
  });

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final mainColor = achievement.completed
        ? Theme.of(context).colorExtension!.achieved
        : Theme.of(context).colorExtension!.gray[200]!;

    final darkerColor = mainColor.withLightness(.3);

    return Container(
      decoration: ShapeDecoration(
        color: mainColor,
        shadows: const [
          BoxShadow(
            blurRadius: 8,
            color: Color(0x18000000),
            offset: Offset(2, 4),
          ),
        ],
        shape: CircleBorder(
          side: achievement.completed
              ? BorderSide(
                  color: darkerColor,
                  width: 2,
                )
              : BorderSide.none,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (achievement.completed) const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // if (achievement.max > 1)
              //   Padding(
              //     padding: const EdgeInsets.only(right: 4),
              //     child: Text(
              //       '${achievement.max}',
              //       style: Theme.of(context).textTheme.titleMedium?.copyWith(
              //             color: darkerColor,
              //             fontWeight: FontWeight.w700,
              //           ),
              //     ),
              //   ),
              Icon(
                UniconsLine.book_open,
                color: darkerColor,
                size: achievement.completed ? 28 : 24,
              ),
            ],
          ),
          if (!achievement.completed) const SizedBox(height: 6),
          if (achievement.completed)
            Icon(
              UniconsLine.check,
              color: darkerColor,
            ),
          // else
          //   Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(4),
          //       color: Theme.of(context).colorScheme.onPrimary,
          //     ),
          //     width: 40,
          //     height: 6,
          //     child: FractionallySizedBox(
          //       alignment: Alignment.centerLeft,
          //       widthFactor: achievement.achieved / achievement.max,
          //       child: DecoratedBox(
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(4),
          //           color: darkerColor,
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
