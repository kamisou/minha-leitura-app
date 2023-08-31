import 'package:flutter/material.dart';
import 'package:reading/shared/presentation/widgets/user_app_bar.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class AchivementsScreen extends StatelessWidget {
  const AchivementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const UserAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Column(
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
