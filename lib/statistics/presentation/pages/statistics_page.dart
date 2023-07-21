import 'package:flutter/material.dart';
import 'package:reading/common/extensions/color_extension.dart';
import 'package:reading/common/presentation/widgets/user_app_bar.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const UserAppBar(),
        ),
        Text(
          'Lendo agora',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          'Acompanhe sua evolução de leitura',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorExtension?.gray[600],
              ),
        ),
      ],
    );
  }
}
