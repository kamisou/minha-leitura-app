import 'package:flutter/material.dart';
import 'package:reading/common/extensions/color_extension.dart';
import 'package:reading/common/presentation/widgets/user_app_bar.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const UserAppBar(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Conquistas',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Acompanhe suas conquistas de leitura',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorExtension?.gray[600],
                ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
